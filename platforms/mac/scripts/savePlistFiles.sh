#!/bin/sh

# convert plist files to xml and copy them back to the setup dir so they can be checked into git

preferencesDir="${HOME}/Library/Preferences"
macModulesDir="${HOME}/setup/platforms/mac/modules"

# iterm2 preferences
plutil -convert xml1 ${preferencesDir}/com.googlecode.iterm2.plist -o ${macModulesDir}/iterm2/com.googlecode.iterm2.plist
