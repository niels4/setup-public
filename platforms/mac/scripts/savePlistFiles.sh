#!/usr/bin/env zsh

# convert plist files to xml and copy them back to the setup dir so they can be checked into git

preferencesDir="${HOME}/Library/Preferences"
macModulesDir="${SETUP_DIR}/platforms/mac/modules"

echo "This script isn't used anymore now that I can just use iTerm's DynamicProfiles feature."
echo "I left the command commented out for future reference in case I need to save any other plist files"

# iterm2 preferences
# plutil -convert xml1 ${preferencesDir}/com.googlecode.iterm2.plist -o ${macModulesDir}/iterm2/com.googlecode.iterm2.plist
