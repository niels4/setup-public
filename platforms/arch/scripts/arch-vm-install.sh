#!/usr/bin/env bash
# This script was created to install arch using the archboot ISO (*-aarch64-ARCH-latest-aarch64.iso) inside of a parallels VM on ARM based apple silicon
# Its usually the top one with the largest file size
# https://release.archboot.com/aarch64/latest/iso/
# https://www.parallels.com/

# Boot up the VM using the archboot ISO
# First run initial script to enable internet, set locale, set timezone, set pacman mirror and keyring.  
# Exit the setup UI after the first set of scripts have run (this script will setup the storage device)

## To download and run install script:
# curl https://raw.githubusercontent.com/niels4/setup-public/refs/heads/main/platforms/arch/scripts/arch-vm-install.sh -o /root/install.sh

## Open the file in a text editor to make any modifications before installing (such as changing hostname, partition sizes, installed packages, etc)
# nvim /root/install.sh

## Run the script:
# bash /root/install.sh

## The script will prompt to create a user with a password

## Once the script finishes running, reboot the VM. (you can just type "reboot" in the terminal)
#  reboot

# Once rebooted, login with the newly created username and password
# From the home directory, checkout the repo and run the setup script

# git clone https://github.com/niels4/setup-public.git setup && ./setup/setup.sh

# because the script uses pacman and pacman requires sudo to install packages, sudo will ask for your password if it needs it


SET_HOSTNAME="arch-vm"

# Partition Disk:
# Use `cfdisk /dev/sda` to check for and delete any existing partitions (WILL ERASE ANY EXISTING DATA ON DISK)
# Because this is going to be installed in a VM, we'll just use a simple partition setup with ext4.
# We don't need BTRFS here as our VM host will be able to create system snapshots

# The sfdisk script will create the following partitions with types:
#   - sda1: EFI System - 512Mib
#   - sda2: Linux swap - 8Gib
#   - sda3: Linux root (ARM-64) - remainder of disk
# edit the script below to increase or decrease swap or boot size as needed

sfdisk /dev/sda << EOF
label: gpt
size=512M, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
size=8G, type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
type=B921B045-1DF0-41C3-AF44-4C6F280D3FAE
EOF

# format partitions:

# root:
mkfs.ext4 /dev/sda3

# efi:
mkfs.fat -F 32 /dev/sda1

# swap:
mkswap /dev/sda2

# mount file systems:

# mount root:
mount /dev/sda3 /mnt

# mount efi:
mount --mkdir /dev/sda1 /mnt/boot

# enable swap:
swapon /dev/sda2

# Tell system how to mount partitions on boot:
genfstab -U /mnt >> /mnt/etc/fstab

# setup locale. Copy choices made in intial setup menu

cp -P /etc/localtime /mnt/etc/localtime

cp /etc/locale.gen /mnt/etc/locale.gen

cp /etc/locale.conf /mnt/etc/locale.conf

cp /etc/vconsole.conf /mnt/vconsole.conf

# set hostname
echo ${SET_HOSTNAME} > /mnt/etc/hostname

# install packages:

# core:
pacstrap -K /mnt base linux linux-firmware sudo which

# keyring for archlinux arm
pacstrap -K /mnt archlinuxarm-keyring

# utilities:
pacstrap -K /mnt vi rsync git man less expect 

# network and ssh server:
pacstrap -K /mnt networkmanager openssh

# The following function has to run within a chroot context
arch_chroot_setup() {
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

  pacman-key --populate archlinuxarm

  # install bootloader

  bootctl install

  ROOT_PART_UUID=$(lsblk -o uuid /dev/sda3 | grep -v UUID)

  cat << EOF > /boot/loader/entries/arch.conf
title	Arch Linux
linux	/Image
initrd	/initramfs-linux.img
options	root=UUID=${ROOT_PART_UUID} rw
EOF

  cat << EOF > /boot/loader/entries/arch-fallback.conf
title	Arch Linux (fallback initramfs)
linux	/Image
initrd	/initramfs-linux-fallback.img
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

  # create initial user
  echo "Creating initial user..."
  read -p "Enter initial user name: " username

  # try again forever until user is able to enter 2 matching passwords
  while true; do
    read -s -p "Enter intial user password: " password
    echo
    read -s -p "Re-enter Password: " password2
    echo

    if [[ "$password" == "$password2" ]]; then
      echo "Passwords match."
      break
    else
      echo "Passwords do not match. Please try again."
    fi
  done

  useradd -m -G wheel -s /bin/bash ${username}

  chpasswd <<EOF
${username}:${password}
EOF

  mkdir /home/${username}/.ssh
  chown ${username}:${username} /home/${username}/.ssh
}

# export the function so we can call it with arch-chroot
export -f arch_chroot_setup

# run the function in arch-chroot context
arch-chroot /mnt /bin/bash -c "arch_chroot_setup"
