# MYZS (My Z Shell)

This is a configable rc file (shell initial file) mainly support `zshrc`, with possible to support bash.

## Table of Content

1. [Dependencies](#dependencies)
2. [Usage](#usage)

## Dependencies

1. [zplug](https://github.com/zplug/zplug): for plugin manangement
2. [gitgo](https://github.com/kamontat/gitgo): for git commit management

## Usage

This project wroted all with shell script. 
No installation require and support MacOS and Linux and Window (with `Windows Subsystem for Linux` installed).
You need to copy the application place to correct location and every work fine.

### Automatic

1. Open terminal / iTerm 2
2. Run command `source <(curl -sNL https://github.com/kamontat/myzs/raw/master/scripts/global.sh)`
3. Answer all question and all set

### Manually

1. Fork the project
2. Clone project via `git clone $HOME/.myzs` or download by Github UI
3. Link `.zshrc` from myzs to root $HOME via `ln -s "$HOME/.myzs/.zshrc" "$HOME/.zshrc"`.

## Configuration

All configuration already listed in `.zshrc` file.

### Tips

1. Improve start time: below setup will improve start time up to 50%

```bash
export MYZS_LOG_LEVEL=("error")   # log only error message
export MYZS_PG_DISABLED=true      # disable progress bar
export MYZS_METRIC_DISABLED=true  # disable metric log message
exprot MYZS_PG_SHOW_PERF=false    # disable performance message
```

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
