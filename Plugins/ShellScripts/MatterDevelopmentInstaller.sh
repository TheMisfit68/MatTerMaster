#!/bin/zsh
# MatterDevelopmentInstaller.sh
#
# A blend of human creativity by TheMisfit68 and
# AI assistance from ChatGPT.
# Crafting the future, one line of shell script at a time.
# Copyright © 2023 Jan Verrept. All rights reserved.

# Unified check and install function for commands and Homebrew packages
check_or_install() {
    local package=$1
    local install_cmd=$2

    # Check for the version directly
    local version
    version=$(get_version "$package")

    if [[ "$version" != "unknown" ]]; then
        echo "✅ $package ($version) is already installed."
        echo
    else
        # Package is not installed, confirm and install
        confirm_and_install "$package" "$install_cmd"
    fi
}

# Function to extract the version number for a package
get_version() {
	local cmd=$1
	# Try --version or -v and extract just the version number
	"$cmd" --version 2>/dev/null | grep -Eo '[0-9]+(\.[0-9]+)+' || \
	"$cmd" -v 2>/dev/null | grep -Eo '[0-9]+(\.[0-9]+)+' || \
	echo "unknown"
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

    echo "⚙️ Setting the Swift toolchain..."
    echo

	# Get the path to the Swift toolchain
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
        
        git clone --branch v5.2.3 --depth 1 --shallow-submodules --recursive https://github.com/espressif/esp-idf.git --jobs 24
        
        echo "✅ 🐑 🐑 ESP-IDF cloned successfully."
        echo
    else
        echo "✅ ESP-IDF repository already exists."
        echo
    fi

    # Install ESP-IDF if the install script exist
    echo "📦 Installing ESP-IDF SDK..."
    if [ -f "$ESP_IDF_INSTALL" ]; then
        "$ESP_IDF_INSTALL" all
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
                
        git clone --branch release/v1.4 --depth 1 --shallow-submodules --recursive https://github.com/espressif/esp-matter.git --jobs 24
        echo "✅ 🐑 🐑 ESP-Matter cloned successfully."
        echo
    else
        echo "✅ ESP-Matter repository already exists."
        echo
    fi

    # Discard all changes in the checked out CHIP-submodule
    # it sometimes is in a dirty state after cloning the ESP-Matter repository
    echo "⏬️ Discarding all changes in the GIT submodules..."
	cd "$ESP_MATTER_REPO/connectedhomeip/connectedhomeip" || exit 1
	git submodule update --init --recursive
	git submodule foreach --recursive git reset --hard
	echo "✅ GIT changes discarded successfully."
    echo

    # Install ESP-Matter if the install script exists
    echo "📦 Installing ESP-MATTER SDK..."
    if [ -f "$ESP_MATTER_INSTALL" ]; then
        "$ESP_MATTER_INSTALL"
        echo "✅ 📦 ESP-Matter SDK installed successfully."
    else
        warnAndExitScript "Install script for ESP-Matter not found."
    fi
}

# Install method
install() {
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
}
