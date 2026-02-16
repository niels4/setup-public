#!/usr/bin/env bash
set -euo pipefail
# This script was created to install arch using the archboot ISO
#
# For Arm64 first download the latest version of the ISO here
# https://release.archboot.com/aarch64/latest/iso/
# Find the file that ends with *-aarch64-ARCH-latest-aarch64.iso
#
# For x86_64 first download the latest version of the ISO here
# https://release.archboot.com/x86_64/latest/iso/
# Find the file that ends with *-latest-x86_64.iso
#
# Use a tool like balena etcher or caligula to create a bootable usb stick from the ISO
# https://etcher.balena.io (GUI)
# https://github.com/ifd3f/caligula (CLI)
#
# Boot up the machine using the archboot ISO on the usb stick
# First run initial script `archinstall` to enable internet, set locale, set timezone, set pacman mirror and keyring.  
# Exit the setup UI after the first set of scripts have run
# This script will setup the storage device. (** Warning it will erase entire hard drive! **)
#
# To download and run install script:
# curl -fL https://raw.githubusercontent.com/niels4/setup-public/refs/heads/main/platforms/arch/scripts/arch-install.sh -o /root/install.sh
#
# Open the file in a text editor to make any modifications before installing (such as changing hostname, partition sizes, installed packages, etc):
# vim /root/install.sh
#
# Find the name of your target disk:
# lsblk -f
#
# USB drives will be named something like /dev/sda or /dev/sdb
# NVMe drives will be named something like /dev/nvme0n1 or /dev/nvme1n1
#
# Make sure the target disk is not mounted. If any partitions are mounted, the script will exit.
#
# Run the script to install on your target disk:
# bash /root/install.sh /dev/sda   # replace /dev/sda with your target disk if different
#
# The script will prompt to create a user with a password
#
# Once the script finishes running, reboot the VM. (you can just type "reboot" in the terminal)
#  reboot

# Once rebooted, login with the newly created username and password
#
# Set up your wifi using `nmtui` (networkctl terminual UI):
# nmtui
#
# Choose Activate a Connection
# Find you wifi network in the list and enter your password to connect
#
# Test your connection:
# ping google.com
#
# From your home directory, create a development folder and checkout the repo:
# git clone https://github.com/niels4/setup-public.git ~/setup
# ~/setup/setup.sh

# because the script uses pacman and pacman requires sudo to install packages, sudo will ask for your password if it needs it

ARCH=$(uname -m)

HOSTNAME="arch-$ARCH"

# --- Target disk (default to /dev/sda) ---
TARGET_DISK="${1:-/dev/sda}"

# Check if disk exists
if [ ! -b "$TARGET_DISK" ]; then
    echo "Error: $TARGET_DISK does not exist or is not a block device." >&2
    exit 1
fi

# Check if any partitions on the disk are mounted
if lsblk -ln -o MOUNTPOINT "${TARGET_DISK}"* | grep -qv '^$'; then
    echo "Error: One or more partitions on $TARGET_DISK are currently mounted. Refusing to format." >&2
    exit 1
fi

read -rp "About to erase all partitions on $TARGET_DISK. Continue? [y/N] " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "Aborting."; exit 1; }


case "$ARCH" in
    aarch64)
        ROOT_GPT_GUID="b921b045-1df0-41c3-af44-4c6f280d3fae" # GPT GUID for Linux root aarch64
        ;;
    x86_64)
        ROOT_GPT_GUID="2c7357ed-ebd2-46d9-aec1-23d437ec2bf5" # GPT GUID for Linux root 86x_64
        ;;
    *)
        echo "Unsupported platform: $ARCH" >&2
        exit 1
        ;;
esac

# Partition Disk:
# Use `cfdisk $TARGET_DISK (sdX) to check for and delete any existing partitions (WILL ERASE ANY EXISTING DATA ON DISK)
# Because this is going to be installed in a VM, we'll just use a simple partition setup with ext4.
# We don't need BTRFS here as our VM host will be able to create system snapshots

# The sfdisk script will create the following partitions with types:
#   - sdX1: EFI System - 512Mib
#   - sdX2: Linux swap - 8Gib
#   - sdX3: Linux root - remainder of disk
# edit the script below to increase or decrease swap or boot size as needed


sfdisk "$TARGET_DISK" << EOF
label: gpt
size=512M, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
size=8G, type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
type=$ROOT_GPT_GUID
EOF

# format partitions:

EFI_PART="${TARGET_DISK}1"
SWAP_PART="${TARGET_DISK}2"
ROOT_PART="${TARGET_DISK}3"

# root:
mkfs.ext4 "$ROOT_PART"

# efi:
mkfs.fat -F 32 "$EFI_PART"

# swap:
mkswap "$SWAP_PART"

# mount file systems:

# mount root:
mount "$ROOT_PART" /mnt

# mount efi:
mount --mkdir "$EFI_PART" /mnt/boot

# enable swap:
swapon "$SWAP_PART"

mkdir -p /mnt/etc

# Tell system how to mount partitions on boot:
genfstab -U /mnt > /mnt/etc/fstab

# setup locale. Copy choices made in initial setup menu

cp -P /etc/localtime /mnt/etc/localtime

cp /etc/locale.gen /mnt/etc/locale.gen

cp /etc/locale.conf /mnt/etc/locale.conf

cp /etc/vconsole.conf /mnt/etc/vconsole.conf

# set hostname
echo "$HOSTNAME" > /mnt/etc/hostname

# prompt for initial user info

is_valid_username() {
  local u="$1"
  # must not be empty, max 32 chars, starts with letter or _, contains only letters, digits, _ or -
  if [[ "$u" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]; then
    return 0  # valid
  else
    return 1  # invalid
  fi
}

# try again forever until user enters non empty username
while true; do
  read -r -p "Enter initial user name: " username
  if is_valid_username "$username"; then
    break
  else
    echo "Invalid username. Must start with a letter or _, only use lowercase letters, digits, _ or -, max 32 chars."
  fi
done

# try again forever until user is able to enter 2 matching passwords
while true; do
  read -s -rp "Enter initial password for $username: " password
  echo
  read -s -rp "Re-enter Password: " password2
  echo

  if [[ "$password" == "$password2" ]]; then
    echo "Passwords match."
    break
  else
    echo "Passwords do not match. Please try again."
  fi
done

# install packages:

# core:
pacstrap -K /mnt base linux linux-firmware sudo which zsh

if [[ "$ARCH" == "aarch64" ]]; then
    # keyring package only needed for archlinux arm, comes default with x86 install
    pacstrap -K /mnt archlinuxarm-keyring
fi

# utilities:
pacstrap -K /mnt vi rsync git man less expect 

# network and ssh server:
pacstrap -K /mnt networkmanager openssh

# The following function has to run within a chroot context
arch_chroot_setup() {
  set -euo pipefail
  hwclock --systohc

  locale-gen

  # enable ssh server on startup:
  systemctl enable sshd

  # disable ssh password
  echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/disable_password.conf

  # enable NetworkManager on startup:
  systemctl enable NetworkManager

  # initialize and populate keyring

  pacman-key --init

  if [[ "$ARCH" == "aarch64" ]]; then
    pacman-key --populate archlinuxarm
  else
    pacman-key --populate archlinux
  fi

  # install bootloader

  bootctl install 2>/dev/null

  ROOT_PART_UUID=$(blkid -s UUID -o value -c /dev/null "$ROOT_PART")

  if [[ "$ARCH" == "aarch64" ]]; then
    KERNEL="/Image"
    INITRD="/initramfs-linux.img"
    INITRD_FALLBACK="/initramfs-linux-fallback.img"
  else
    KERNEL="/vmlinuz-linux"
    INITRD="/initramfs-linux.img"
    INITRD_FALLBACK="/initramfs-linux-fallback.img"
  fi

  cat << EOF > /boot/loader/entries/arch.conf
title	Arch Linux
linux	  $KERNEL
initrd	$INITRD
options	root=UUID=${ROOT_PART_UUID} rw
EOF

  cat << EOF > /boot/loader/entries/arch-fallback.conf
title	Arch Linux (fallback initramfs)
linux	  $KERNEL
initrd	$INITRD_FALLBACK
options	root=UUID=${ROOT_PART_UUID} rw
EOF

  # Timeout is set to 0 because this is being launched inside a VM and I won't be installing any other OSes to boot from
  cat << EOF > /boot/loader/loader.conf
default		arch.conf
timeout		0
console-mode	max
editor		no
EOF

  # enable wheel group sudoers
  echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/enable_wheel
  chmod 440 /etc/sudoers.d/enable_wheel

  # create initial user
  echo "Creating initial user '$username'"


  useradd -m -G wheel -s /bin/zsh "$username"

  chpasswd <<EOF
${username}:${password}
EOF

  mkdir -p "/home/$username/.ssh"
  chown "$username:$username" "/home/$username/.ssh"
  chmod 700 "/home/$username/.ssh"

  touch "/home/$username/.ssh/authorized_keys"
  chown "$username:$username" "/home/$username/.ssh/authorized_keys"
  chmod 600 "/home/$username/.ssh/authorized_keys"

  echo "Install script completed successfully."
}

# export the function so we can call it with arch-chroot
export -f arch_chroot_setup

# run the function in arch-chroot context
export ARCH
export username
export password
export ROOT_PART
arch-chroot /mnt /bin/bash -c "arch_chroot_setup"
