# MYZS (My Z Shell)

This is a configable rc file (shell initial file) support both `bash` and `zshrc`.

## Dependencies

1. [zplug](https://github.com/zplug/zplug): for plugin manangement
2. [gitgo](https://github.com/kamontat/gitgo): for git commit management

## Usage

Clone this project to `$HOME/.myzs` and run `ln -s "$HOME/.myzs/.zshrc" "$HOME/.zshrc"`

## Configuration

All configuration already listed in `.zshrc` file.

> Tip: Default setup is my personal setup
> Speed up by setting below, it improve around 50% or start time
>             set MYZS_LOG_LEVEL=("error")
>             set MYZS_PG_DISABLED=true
>             set MYZS_PG_SHOW_PERF=false

## Plugin

Plugin is a repository contains multiple module together, that support loading only with first load.
The myzs will clone plugin repository to local and initial them with some scripts.
Plugin can upgrade via myzs-download (mdownload) command. All myzs plugin has listed at [myzs-plugins](https://github.com/myzs-plugins). And this is a [template](https://github.com/myzs-plugins/template).

## Module

## Command

I create command utils script for manage this project.

1. `./scripts/command.sh install` - This will install command to current .zshrc files
2. `./scripts/command.sh uninstall` - This will uninstall this project add delete all file

## Developer Documentation

1. Helper: [README.md](./src/utils/helper/README.md)
