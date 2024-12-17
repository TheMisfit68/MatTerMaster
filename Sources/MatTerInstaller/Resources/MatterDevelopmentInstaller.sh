#!/bin/zsh
# MatterDevelopmentInstaller.sh
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

consoleSeparator(){
	echo "________________________________________________________________________________________________________________________________________________________________________________________________________"
	echo
}

# Unified check and install function for commands and Homebrew packages
check_or_install() {
	local package=$1
	local install_cmd=$2
	
	# Check if command is available (for non-brew packages)
	if [[ "$install_cmd" != *"brew install"* ]]; then
	if ! command -v "$package" &>/dev/null; then
	warnAndExitScript "$package is not installed."
	else
	echo "✅ $package is already installed."
	echo
	fi
	else
	# Check if Homebrew based package is installed
	if ! brew list "$package" &>/dev/null; then
	confirm_and_install "$package" "$install_cmd"
	else
	echo "✅ $package is already installed."
	echo
	fi
	fi
}

# Ask for user confirmation before installing a missing package
confirm_and_install() {
	local package=$1
	local install_cmd=$2
	
	local attempts=0
	while true; do
	read "response?⚠️ $package is not installed. Do you want to install it now? (y/n): "
	case $response in
	[Yy]* )
	echo "📦 Installing $package..."
	eval "$install_cmd"
	if [ $? -eq 0 ]; then
	echo "✅ 📦 $package installed successfully."
	echo
	break
	else
	warnAndExitScript "Failed to install $package."
	fi
	;;
	[Nn]* )
	warnAndExitScript "$package is required. Exiting."
	;;
	* )
	echo "Please answer yes or no."
	attempts=$((attempts + 1))
	if (( attempts >= 3 )); then
	echo "Maximum attempts reached. Exiting."
	exit 1
	fi
	;;
	esac
	done
}

check_Or_install_Xcode_Tools() {
	if ! xcode-select -p &>/dev/null; then
	confirm_and_install "Xcode Command Line Tools" "xcode-select --install"
	# Wait for the installation to complete
	until xcode-select -p &>/dev/null; do
	sleep 5
	done
	else
	echo "✅ Xcode Command Line Tools are already installed."
	fi
}

install_Swift_Nightly_Toolchain(){
	# Get the path to the Swift toolchain
	echo "⚙️ Setting the Swift toolchain..."
	echo
	
	local toolchain_path
	toolchain_path=$(ls -d ~/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-*-a.xctoolchain 2>/dev/null | head -n 1)
	
	if [ -z "$toolchain_path" ]; then
	warnAndExitScript "Swift toolchain not found in ~/Library/Developer/Toolchains/"
	fi
	
	echo "ℹ️ Swift toolchain path: $toolchain_path"
	
	# Extract the toolchain identifier
	local swift_toolchain_identifier
	swift_toolchain_identifier=$(plutil -extract CFBundleIdentifier raw -o - "$toolchain_path/Info.plist")
	
	if [ -z "$swift_toolchain_identifier" ]; then
	warnAndExitScript "Could not extract the toolchain identifier from $toolchain_path"
	fi
	
	# Export the Swift toolchain identifier
	echo "🚚 Exporting Swift toolchain with identifier: $swift_toolchain_identifier"
	export TOOLCHAINS=$swift_toolchain_identifier
	
	# Test the toolchain
	TOOLCHAINS=$swift_toolchain_identifier swift --version &>/dev/null
	
	echo
	if [ $? -eq 0 ]; then
	xcrun -f swift
	echo "✅ Swift toolchain is functioning correctly."
	else
	warnAndExitScript "Failed to use the Swift toolchain."
	fi
}

check_Or_Install_Brew_Packages() {
	
	check_or_install "brew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
	
	check_or_install "python3" "brew install python3"
	check_or_install "cmake" "brew install cmake"
	check_or_install "ninja" "brew install ninja"
	check_or_install "dfu-util" "brew install dfu-util"
	check_or_install "ccache" "brew install ccache"  # Optional CCache
	
}


# Install ESP IDF SDK
install_ESP_IDF_SDK() {
	cd "$ESP_PARENT_DIR" || exit 1
	
	# Clone ESP-IDF repository if it doesn't exist
	if [ ! -d "$ESP_IDF_REPO" ]; then
	echo "🐑 Cloning ESP-IDF repository..."
	echo
	
	git clone --branch v5.2.1 --depth 1 --shallow-submodules --recursive https://github.com/espressif/esp-idf.git --jobs 24
	
	echo "✅ 🐑 🐑 ESP-IDF cloned successfully."
	echo
	else
	echo "✅ ESP-IDF repository already exists."
	echo
	fi
	
	# Install ESP-IDF if the install script exist
	echo "📦 Installing ESP-IDF SDK..."
	local esp_idf_install_script="$ESP_IDF_REPO/install.sh"
	if [ -f "$esp_idf_install_script" ]; then
	"$esp_idf_install_script" all
	echo "✅ 📦 ESP-IDF SDK installed successfully."
	else
	warnAndExitScript "Install script for ESP-IDF not found."
	fi
}

# Install ESP-Matter SDK
install_ESP_Matter_SDK() {
	cd "$ESP_PARENT_DIR" || exit 1
	
	# Clone ESP-Matter repository if it doesn't exist
	if [ ! -d "$ESP_MATTER_REPO" ]; then
	echo "🐑 Cloning ESP-Matter repository..."
	echo
	
	git clone --branch release/v1.3 --depth 1 --shallow-submodules --recursive https://github.com/espressif/esp-matter.git --jobs 24
	
	echo "✅ 🐑 🐑 ESP-Matter cloned successfully."
	echo
	else
	echo "✅ ESP-Matter repository already exists."
	echo
	fi
	
	# Install ESP-Matter if the install script exist
	echo "📦 Installing ESP-MATTER SDK..."
	local esp_matter_install_script="$ESP_MATTER_REPO/install.sh"
	if [ -f "$esp_matter_install_script" ]; then
	"$esp_matter_install_script"
	echo "✅ 📦 ESP-Matter SDK installed successfully."
	else
	warnAndExitScript "Install script for ESP-Matter not found."
	fi
}

# Main script starts here
echo "🔍 Checking and installing ESP SDKs..."
consoleSeparator

# 1. xcode-tools
check_Or_install_Xcode_Tools
consoleSeparator

# 2. Swift Developer toolchain
install_Swift_Nightly_Toolchain
consoleSeparator

# 3. Brew support packages
check_Or_Install_Brew_Packages
consoleSeparator

# 4. Check if cleanInstall parameter is passed and if so remove any old SDK's and tools
local cleanInstall=$1
if [[ "$cleanInstall" == "true" ]]; then
echo "🗑️ Deleting existing frameworks and tools folders..."
rm -rf "$ESP_IDF_REPO" "$ESP_MATTER_REPO" "$ESP_TOOLS_DIR" || warnAndExitScript "Failed to remove old frameworks and tools."
echo "✅ 🗑️ Old frameworks and tools folders deleted."
echo
else
echo "ℹ️ Reusing existing ESP-frameworks."
fi
consoleSeparator

# 5. ESP parent folder
echo "🔍 Checking for ESP parent folder at $ESP_PARENT_DIR"
if [ ! -d "$ESP_PARENT_DIR" ]; then
echo "🗂️ Creating ESP parent folder..."
mkdir -p "$ESP_PARENT_DIR" || warnAndExitScript "Failed to create ESP parent folder."
echo "✅ 🗂️ ESP parent folder created successfully."
else
echo "✅ ESP parent folder is present."
fi
consoleSeparator

# 6. ESP-IDF SDK
echo "🔍 Checking for esp-idf at $ESP_IDF_REPO"
if [ ! -d "$ESP_IDF_REPO" ]; then
echo "❔ esp-idf is missing. Reinstalling..."
install_ESP_IDF_SDK
else
echo "✅ esp-idf is present."
fi
consoleSeparator

# 7. ESP-Matter SDK
echo "🔍 Checking for esp-matter at $ESP_MATTER_REPO"
if [ ! -d "$ESP_MATTER_REPO" ]; then
echo "❔ esp-matter is missing. Reinstalling..."
install_ESP_Matter_SDK
else
echo "✅ esp-matter is present."
fi
consoleSeparator

