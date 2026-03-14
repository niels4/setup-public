import sharedLinuxSshSetup from "#shared/modules/linux-ssh/setup.ts"

export default async function setup() {
  await sharedLinuxSshSetup({ mirrorUserPassword: true })
}
