#!/bin/zsh
# setupMatterEnvironment.sh
#
# A blend of human creativity by TheMisfit68 and
# AI assistance from ChatGPT.
# Crafting the future, one line of shell script at a time.
# Copyright © 2023 Jan Verrept. All rights reserved.

# Consolidated PATH setup
export PATH=/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin

# Global paths
SCRIPTS_DIR="$(dirname "$0")"

ESP_PARENT_DIR="$HOME/esp"
ESP_TOOLS_DIR="$HOME/.espressif"
ESP_IDF_REPO="$ESP_PARENT_DIR/esp-idf"
ESP_MATTER_REPO="$ESP_PARENT_DIR/esp-matter"

# Source the subscripts for installations
source "$SCRIPTS_DIR/MatterDevelopmentInstaller.sh"

consoleSeparator(){
	echo "________________________________________________________________________________________________________________________________________________________________________________________________________"
	echo
}

# Unified warning and exit function
warnAndExitScript() {
	echo
	echo "⚠️ $1"
	echo "⚠️ Please fix the issue and rerun this setup."
	echo
	exit 1
}

# Function to set up the ESP-IDF and ESP-Matter environments
setupMatterEnvironment() {
	
	# Enable the cache for quicker recompiling
	# for now disable it during testing
#	export IDF_CCACHE_ENABLE=1
	
	# Set up the ESP-IDF environment
	echo
	local esp_idf_path="$ESP_IDF_REPO/export.sh"
	if [ -f "$esp_idf_path" ]; then
	echo "⚙️ Setting up ESP-IDF environment..."
	echo
	cd "$ESP_IDF_REPO"
	source "$esp_idf_path"
	echo
	echo "✅ ESP-IDF environment set up."
	else
	warnAndExitScript "ESP-IDF setup script not found at $esp_idf_path."
	fi
	consoleSeparator
	
	# Set up the ESP-Matter environment
	local esp_matter_path="$ESP_MATTER_REPO/export.sh"
	if [ -f "$esp_matter_path" ]; then
	echo "⚙️ Setting up ESP-Matter environment..."
	echo
	cd "$ESP_MATTER_REPO"
	source "$esp_matter_path"
	echo
	echo "✅ ESP-Matter environment set up."
	else
	warnAndExitScript "ESP-Matter setup script not found at $esp_matter_path."
	fi
	consoleSeparator
}

cleanBuildFolder(){
	if [[ -d "build" ]]; then
	echo "🧽 Cleaning old builds."
	rm -rf build
	echo "✅ 🧽 Removed existing 'build' folder."
	consoleSeparator
	fi
}

# Function to build the project for a specific board
buildProjectForBoard() {
	echo
	local esp_board_type="${1:-esp32c6}"   # Default to esp32c6 if no first argument is passed
	
	# Set the ESP board type
	echo "⚙️ Setting the target board type to: $esp_board_type ..."
	echo
	idf.py set-target "$esp_board_type" || warnAndExitScript "Failed to set the target board type."
	echo
	echo "⚙️ Target board set successfully!"
	consoleSeparator
	
	# Build the project
	echo "🔧 Building the project..."
	echo
	idf.py build || warnAndExitScript "Failed to build the target."
	echo
	echo "🔧 ✅ Build completed successfully!"
	consoleSeparator
}

# Flash the new firmware
flashFirmware(){
	echo "⚡️ Flashing firmware!..."
	echo
	idf.py flash monitor || warnAndExitScript "Flashing the firmware failed."
	echo
	echo "⚡️ ✅ Flashing completed successfully!"
	consoleSeparator
}

# Erase the firmware
eraseFirmware(){
	echo "🗑️ Erasing firmware!..."
	echo
	idf.py erase-flash || warnAndExitScript "Erasing the firmware failed."
	echo
	echo "🗑️ ✅ Erasing completed successfully!"
	consoleSeparator
}

# Navigate to the test project
navigateTo() {
	local targetDirectory="$1"
	
	# Check if the specified directory exists and navigate to it
	if [ -d "$targetDirectory" ]; then
	cd "$targetDirectory" || warnAndExitScript "Failed to change to directory: $targetDirectory"
	echo "✅ Navigated to directory: $(pwd)"
	else
	echo "⚠️ Directory does not exist: $targetDirectory. Skipping navigation."
	fi
	consoleSeparator
}

# Function to set up aliases
setup_aliases() {
	# Check if the shell is interactive before setting up aliases
	case $- in
	*i*)
	alias install="install" # You can add true as an argument, when you use the alias, to force a complete reinstall
	alias setup='setupMatterEnvironment'
	alias clean='cleanBuildFolder'
	alias build='buildProjectForBoard'
	alias flash='flashFirmware'
	alias erase='eraseFirmware'
	
	source "$SCRIPTS_DIR/MatterDevelopmentUserAliases.sh"
	
	echo
	echo "✅ 🏷️⃕ Aliases are in place."
	;;
	*)
	echo
	echo "❌ 🏷️⃕ Non-interactive shell detected. Aliases will not be set up."
	;;
	esac
	consoleSeparator
}


echo "🔧 Setting up the Matter Development environment..."
echo

# Install without cleaning
install false


# Set up the Matter environment and export the Swift toolchain identifier
setupMatterEnvironment

# Set up aliases
setup_aliases

echo
echo "✅ 🔧 Setting up the Matter Development completed successfully."
echo "👍 You can now start your build cycle."
consoleSeparator

