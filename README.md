# dotfiles
> [!NOTE] This is written more as a reminder for myself than for you.

## Table of Contents

- [Feature Highlights](#feature-highlights)
- [TODO Roadmap](docs/TODO.md)
- [Requirements](#requirements)
- [Structure](#structure-quick-reference)
- [Secrets Management](#secrets-management)
- [Tools and Applications I Use](#acknowledgments)

## Feature Highlights

- Multi-host and multi-user configurations based on Flake, Darwin, and Home-Manager.
  - The base configurations for hosts and users dynamically manage host specifications based on Darwin.
  - Optional configurations for specific user and host needs.


The roadmap for additional features is spread across short-term goals, detailed in the [TODO Roadmap](docs/).

Completed features will be added here as each step is finalized.

## Requirements

- *MacOS =>* `15.2`
- *Nix =>* `2.25.4`
- *`Homebrew`*

This is a custom configuration that requires several technical prerequisites to be successfully built. This Nix setup will serve best as a reference, a learning resource, and a model for creating your own configuration.

## Structure

For more details on design concepts:

- `flake.nix` - Entry point for host and user configurations.
- `hosts` - NixOS configurations accessible via `darwin-rebuild switch --flake .#<host>`.
  - `common` - Shared configurations used by specific machines.
    - `core` - Configurations present on all hosts. This is a strict rule! If something is not essential, it is optional.
    - `optional` - Optional configurations present on multiple hosts.
- `dev-lab` - MacStudio
- `dev-lab-bis` - MacBookPro
- `home/<user>` - Home-manager configurations, automatically built during host rebuilds.
  - `common` - Shared home-manager configurations consumed by the user's specific machine.
    - `core` - Home-manager configurations present for the user on all machines. This is a strict rule! If something is not essential, it is optional.
    - `optional` - Optional home-manager configurations that can be added for specific machines.
- `lib` - Custom library used in nix-config to make import paths more readable. Accessible via `lib.custom`.
- `modules` - Custom modules to enable special features and options.
  - `darwin` - Custom modules specific to Darwin-based hosts.
- `scripts` - Custom scripts for automation.

## How to Get Started

Run:

Download configuration

```shell
$ nix-shell -p git --run 'git clone https://github.com/Raf7c/dotfiles.git .dotfiles'
```

Install

```shell
$ nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#raf-devlab --impure
```

`.#raf-devlab` or `.#raf-devlab-bis`

`darwin-rebuild --flake .#<host>` To build system configurations.</br>
`home-manager --flake .#<host>` To create user configurations.</br>
`nix build` (or shell or run) To build and use packages.</br>
</br>

Avoid errors related to missing dependencies:
```shell
git submodule update --init --recursive
```

## Tools and Applications I Use