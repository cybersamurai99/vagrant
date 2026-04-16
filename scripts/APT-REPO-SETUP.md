# APT Repository Setup Guide

This provides automatic optimal APT repository selection for Debian/Ubuntu systems with a Netherlands fallback.

## Features

- **Dynamic Speed Testing**: Tests multiple repositories to find the fastest one
- **Geographic Fallbacks**: Tests repos from Netherlands, Germany, France, UK, Switzerland, and global mirrors
- **Netherlands Default**: Falls back to Netherlands (ftp.nl.debian.org) if dynamic testing fails
- **Backup/Restore**: Creates backups and allows restoration of original sources.list
- **Works Offline**: Falls back to default Netherlands repo if curl is unavailable

## Usage

### In Vagrant Provisioning (No Arguments Required)

Simply add it as the first provisioning step in your Vagrantfile:

```ruby
config.vm.provision "shell", path: "../scripts/setup-apt-repo.sh"
```

When called with no arguments, it automatically runs `configure` with dynamic speed testing to find the fastest repository. If curl is unavailable or all tests fail, it falls back to the Netherlands mirror.

### As a Standalone Script

Test all repositories:
```bash
bash scripts/setup-apt-repo.sh test
```

Find the fastest repository:
```bash
bash scripts/setup-apt-repo.sh find-fastest
```

Configure APT with fastest repository:
```bash
bash scripts/setup-apt-repo.sh configure
```

Configure APT with specific repository:
```bash
bash scripts/setup-apt-repo.sh configure "http://ftp.de.debian.org/debian"
```

Restore original sources.list:
```bash
bash scripts/setup-apt-repo.sh restore
```

### Source in Other Scripts

Add this to your provisioning scripts to use optimal repo:

```bash
#!/bin/bash
source scripts/setup-apt-repo.sh

# Configure apt with fastest repository (automatic speed testing)
configure_apt_repo
```

Or with a specific repository:

```bash
source scripts/setup-apt-repo.sh
configure_apt_repo "http://ftp.nl.debian.org/debian"
apt-get update
```

### Using in Vagrant Provisioning (Simple)

In your Vagrantfile, add as the first provisioning step (no arguments needed):

```ruby
# Will automatically find fastest repo or use Netherlands fallback
config.vm.provision "shell", path: "../scripts/setup-apt-repo.sh"
```

With explicit repository selection:

```ruby
config.vm.provision "shell", inline: <<-SHELL
  bash /vagrant/scripts/setup-apt-repo.sh configure "http://ftp.nl.debian.org/debian"
SHELL
```

### Environment Variable Override

Override the automatic/fallback behavior:

```bash
#!/bin/bash
# Force Netherlands repo
APT_REPO="http://ftp.nl.debian.org/debian" 
source scripts/setup-apt-repo.sh
configure_apt_repo "$APT_REPO"
```

## Available Repositories (Priority Order)

1. **Netherlands**: `http://ftp.nl.debian.org/debian` (Primary fallback)
2. **Global**: `http://deb.debian.org/debian`
3. **Germany**: `http://ftp.de.debian.org/debian`
4. **France**: `http://ftp.fr.debian.org/debian`
5. **UK**: `http://ftp.uk.debian.org/debian`
6. **Switzerland**: `http://ftp.ch.debian.org/debian`

## Security

- Original `sources.list` is backed up to `sources.list.backup`
- Security repository remains unchanged (security.debian.org)
- Works with both Debian and Ubuntu
- Supports non-free and restricted repositories

## Supported Distributions

- Debian (Bullseye, Bookworm, etc.)
- Ubuntu (Focal, Jammy, etc.)
