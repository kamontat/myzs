# MYZS (My Z Shell)

This is a configable rc file (shell initial file) support both `bash` and `zshrc`.

## Dependencies

1. [zplug](https://github.com/zplug/zplug): for plugin manangement
2. [gitgo](https://github.com/kamontat/gitgo): for git commit management

## Usage

Clone this project to `$HOME/.myzs` and run `ln -s "$HOME/.myzs/.zshrc" "$HOME/.zshrc"`

## Command

I create command utils script for manage this project.

1. `./scripts/command.sh install` - This will install command to current .zshrc files
2. `./scripts/command.sh uninstall` - This will uninstall this project add delete all file
