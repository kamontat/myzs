# MYZS (My Z Shell)

This is a configable rc file (shell initial file) mainly support `zshrc`, with possible to support bash.

- [Development](./docs/DEV.md)
- [Utilities](./docs/README_UTILS.md)
- [Plugins](./docs/README_PLUGINS.md)
- [Changelog](./docs/CHANGELOG.md)
- [Line of Code](./docs/LOC.md)

## Usage

This project wroted all with shell script. 
No installation require and support MacOS and Linux and Window (with `Windows Subsystem for Linux` installed).
You need to copy the application place to correct location and every work fine. Always check configuration before use it because configuration might not suit for you ([config](#configuration)).

### Automatic

1. Open terminal / iTerm 2
2. Run command `source <(curl -sNL https://github.com/kamontat/myzs/raw/master/scripts/global.sh)`
3. Answer all question and all set

### Manually

1. Fork the project
2. Clone project via `git clone $HOME/.myzs` or download by Github UI
3. Link `.zshrc` from myzs to root $HOME via `ln -s "$HOME/.myzs/.zshrc" "$HOME/.zshrc"`.

### Command

utils script for manage this project.

1. `./scripts/command.sh install` - This will install command to current .zshrc files
2. `./scripts/command.sh uninstall` - This will uninstall this project add delete all file

## Configuration

All configuration already listed in `.zshrc` file.

### Tips

I attach a lot of features including debugging so by default I might enable some settings / modules depend on my personal needs. This is a list of features you might set differently to improve load time. Your point of view is on `$MYZS_LOADING_SETTINGS` and `$MYZS_LOADING_MODULES`

1. progressbar - by default I will always enabled progressbar to improve UX (improving ~7.3%)
   1. aggregate data - plugins and modules tend to have many of it, we can aggregate result and report once with setting below (improving ~30.4%)

```bash
"$" disabled pg # MYZS_LOADING_SETTINGS
"$" enabled myzs/plugin/aggregation
"$" enabled myzs/module/aggregation
```

2. metrics - currently metric apis subject to changes a lot so now it not improve anything yet

```bash
"$" disabled metric # MYZS_LOADING_SETTINGS
```

3. logging - on normal situation only error log should enough to make script works and idenify problem if any (improving ~7.8%)

```bash
"$" array logger/level "error" # MYZS_LOADING_SETTINGS
```

## Dependencies

1. [zplug](https://github.com/zplug/zplug): for plugin manangement
2. [gitgo](https://github.com/kamontat/gitgo): for git commit management
