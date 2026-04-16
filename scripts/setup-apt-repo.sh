#!/bin/bash

# Setup optimal apt repository with Netherlands fallback
# This script can be sourced in other provisioning scripts
# Works with both Debian and Ubuntu

# Detect distribution
if command -v lsb_release &> /dev/null; then
    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
else
    DISTRO=$(grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
fi

# Set repository mirrors based on distribution
if [ "$DISTRO" = "ubuntu" ]; then
    DEFAULT_APT_REPO="http://nl.archive.ubuntu.com/ubuntu"
    
    # List of Ubuntu APT repos to test (geographically distributed)
    declare -a APT_REPOS=(
        "http://archive.ubuntu.com/ubuntu"              # Default global
        "http://nl.archive.ubuntu.com/ubuntu"           # Netherlands
        "http://de.archive.ubuntu.com/ubuntu"           # Germany
        "http://fr.archive.ubuntu.com/ubuntu"           # France
        "http://uk.archive.ubuntu.com/ubuntu"           # UK
        "http://ch.archive.ubuntu.com/ubuntu"           # Switzerland
    )
else
    # Debian defaults
    DEFAULT_APT_REPO="http://ftp.nl.debian.org/debian"
    
    # List of Debian APT repos to test (geographically distributed)
    declare -a APT_REPOS=(
        "http://deb.debian.org/debian"                  # Default global
        "http://ftp.nl.debian.org/debian"               # Netherlands
        "http://ftp.de.debian.org/debian"               # Germany
        "http://ftp.fr.debian.org/debian"               # France
        "http://ftp.uk.debian.org/debian"               # UK
        "http://ftp.ch.debian.org/debian"               # Switzerland
    )
fi

# Function to test repository latency
test_repo_speed() {
    local repo="$1"
    local timeout=2
    
    # Extract host from URL
    local host=$(echo "$repo" | sed -E 's|https?://||' | cut -d'/' -f1)
    
    # Use curl to test connection speed with very short timeout
    local start_time=$(date +%s%N)
    if curl -s -m $timeout -I "$repo" >/dev/null 2>&1; then
        local end_time=$(date +%s%N)
        local elapsed=$(( (end_time - start_time) / 1000000 ))  # Convert to milliseconds
        echo "$elapsed"
    else
        echo "9999"  # Return high number if timeout/unreachable
    fi
}

# Function to find the fastest apt repository
find_fastest_repo() {
    echo "Testing apt repository speeds..." >&2
    
    local fastest_repo="$DEFAULT_APT_REPO"
    local fastest_speed=9999
    
    for repo in "${APT_REPOS[@]}"; do
        local speed=$(test_repo_speed "$repo")
        local host=$(echo "$repo" | sed -E 's|https?://||' | cut -d'/' -f1)
        
        if [ "$speed" != "9999" ]; then
            echo "  $host: ${speed}ms" >&2
            if [ "$speed" -lt "$fastest_speed" ]; then
                fastest_speed=$speed
                fastest_repo="$repo"
            fi
        else
            echo "  $host: UNREACHABLE" >&2
        fi
    done
    
    echo "$fastest_repo"
}

# Function to configure apt with selected repository
configure_apt_repo() {
    local repo="${1:-}"
    
    # Use provided repo, or find fastest, or use default
    if [ -z "$repo" ]; then
        if command -v curl &> /dev/null; then
            repo=$(find_fastest_repo)
        else
            repo="$DEFAULT_APT_REPO"
        fi
    fi
    
    echo "Configuring apt to use: $repo" >&2
    
    # Backup original sources.list
    if [ ! -f /etc/apt/sources.list.backup ]; then
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
    fi
    
    # Get distribution info
    local release=$(lsb_release -cs)
    
    # Disable new DEB822 format ubuntu.sources if it exists to avoid duplication
    if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
        echo "Disabling /etc/apt/sources.list.d/ubuntu.sources to avoid duplication..." >&2
        sudo mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.disabled
    fi
    
    if [ "$DISTRO" = "debian" ]; then
        cat << EOF | sudo tee /etc/apt/sources.list > /dev/null
deb $repo $release main contrib non-free non-free-firmware
deb-src $repo $release main contrib non-free non-free-firmware

deb $repo $release-updates main contrib non-free non-free-firmware
deb-src $repo $release-updates main contrib non-free non-free-firmware

deb $repo $release-backports main contrib non-free non-free-firmware
deb-src $repo $release-backports main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security $release-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security $release-security main contrib non-free non-free-firmware
EOF
    elif [ "$DISTRO" = "ubuntu" ]; then
        cat << EOF | sudo tee /etc/apt/sources.list > /dev/null
deb $repo $release main restricted universe multiverse
deb-src $repo $release main restricted universe multiverse

deb $repo $release-updates main restricted universe multiverse
deb-src $repo $release-updates main restricted universe multiverse

deb $repo $release-backports main restricted universe multiverse
deb-src $repo $release-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu $release-security main restricted universe multiverse
deb-src http://security.ubuntu.com/ubuntu $release-security main restricted universe multiverse
EOF
    fi
    
    echo "✓ APT repository configured successfully" >&2
}

# Function to restore original sources.list
restore_apt_repo() {
    if [ -f /etc/apt/sources.list.backup ]; then
        echo "Restoring original apt sources..." >&2
        sudo cp /etc/apt/sources.list.backup /etc/apt/sources.list
    fi
}

# If script is called directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-configure}" in
        "configure")
            configure_apt_repo "${2:-}"
            ;;
        "find-fastest")
            find_fastest_repo
            ;;
        "restore")
            restore_apt_repo
            ;;
        "test")
            find_fastest_repo
            ;;
        *)
            echo "Usage: $0 {configure|find-fastest|restore|test} [repo-url]"
            echo ""
            echo "Commands:"
            echo "  configure [repo-url]  - Configure apt repository (uses fastest if no URL provided)"
            echo "  find-fastest          - Find and display fastest repository"
            echo "  restore               - Restore original apt sources.list"
            echo "  test                  - Test all repositories and display speeds"
            echo ""
            echo "If called with no arguments, defaults to 'configure'"
            exit 1
            ;;
    esac
fi
