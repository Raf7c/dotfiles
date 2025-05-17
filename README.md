# dotfiles
[ 🇺🇸 ](./README.md)  [ 🇫🇷 ](docs/fr/README_fr.md)

> [!NOTE] This is written more as a reminder for myself than for you.

## Table of Contents

- [Feature Highlights](#feature-highlights)
- [TODO Roadmap](docs/TODO.md)
- [Requirements](#requirements)
- [Structure](#structure)
- [Secrets Management](#secrets-management)
- [Tools and Applications](#tools-and-applications)
- [Getting Started](#getting-started)
- [Maintenance](#maintenance)

## Feature Highlights

- **Multi-host Configuration**
  - MacStudio (dev-lab) and MacBookPro (dev-lab-bis) support
  - Dynamic host-specific configurations
  - Shared common configurations

- **Development Environment**
  - Neovim with custom configuration
  - VSCode integration
  - Git configuration
  - ASDF version manager
  - Custom shell setup with Starship

- **System Management**
  - Nix Flakes for reproducible builds
  - Home Manager for user configurations
  - Homebrew integration for macOS packages
  - Automatic garbage collection and optimization

- **UI/UX**
  - Kitty terminal with custom theme
  - Catppuccin Mocha theme
  - JetBrains Mono font
  - Adaptive font sizes for different devices

## Requirements

- **System Requirements**
  - macOS >= 15.2
  - Nix >= 2.25.4
  - Homebrew

- **Hardware Support**
  - Apple Silicon (M1/M2) support
  - Multi-monitor setup support
  - Laptop/Desktop adaptive configurations

## Structure

```
.
├── flake.nix                 # Main entry point
├── nix/
│   ├── darwin/              # macOS specific configurations
│   │   ├── hosts/          # Host-specific configurations
│   │   └── modules/        # Darwin modules
│   ├── home/               # Home Manager configurations
│   │   ├── programs/       # Program configurations
│   │   └── profiles/       # User profiles
│   ├── common/             # Shared configurations
│   │   ├── packages/       # Common packages
│   │   └── fonts/         # Font configurations
│   └── lib/                # Custom library functions
└── docs/                   # Documentation
```

## Tools and Applications

### Development Tools
- **Editors**
  - Neovim
  - VSCode
  - Cursor

- **Version Control**
  - Git
  - GitHub CLI
  - LazyGit

- **Terminal**
  - Kitty
  - Tmux
  - Starship prompt

### System Tools
- **Package Management**
  - Nix
  - Homebrew
  - ASDF

- **System Monitoring**
  - iStat Menus
  - CleanMyMac

### Productivity
- **Note Taking**
  - Obsidian
  - Notion

- **Communication**
  - Slack
  - Discord

- **Design**
  - Figma

## Getting Started

1. **Clone the Repository**
```shell
nix-shell -p git --run 'git clone https://github.com/Raf7c/dotfiles.git .dotfiles'
```

2. **Initialize Submodules**
```shell
git submodule update --init --recursive
```

3. **Install Configuration**
```shell
# For MacStudio
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#raf-devlab 

# For MacBookPro
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#raf-devlab-bis 
```

## Maintenance

### Common Commands
```shell
# Rebuild system configuration
darwin-rebuild --flake .#<host>

# Update user configuration
home-manager --flake .#<host>

# Build packages
nix build

# Clean up old generations
nix-collect-garbage -d
```

### Updating
- Regular `nix flake update` to update dependencies
- `home-manager switch` for user configuration updates
- `brew update` for Homebrew packages

## Contributing

Feel free to use this configuration as a reference or starting point for your own setup. If you find any issues or have suggestions, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.