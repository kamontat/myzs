# Release notes

## Version 5.3.5 (10 May 2021)

- Wrong License type on `myzs-info` command (it should be **AGPL-3.0**, not **MIT**)

## Version 5.3.4 (10 May 2021)

- add logging when checking os and shell
- upgrade app/gcloud.sh to support latest version
- add new plugin `myzs-plugins/python` for conda support
- now plugin default branch will be **main** instead of **master**

## Version 5.3.3 (21 Apr 2021)

- add error progress when zplug load failed
- add error progress when configured zplug failed
- add error when loading module with error and `pb/performance` is enabled
- change custom zplug plugins list name from `myzs:zplug:plugin-list` to `myzs:zplug:custom:plugin-list`
- fix not color final message from progressbar
- fix `source "$file"` return zero even error occurred

## Version 5.3.2 (21 Apr 2021)

- fix `/tmp/myzs` didn't create for data and log path
- log file will create even never write any log to file

## Version 5.3.1 (16 Apr 2021)

- fix deploy-plugins scripts

## Version 5.3.0 (16 Apr 2021)

- [BREAK] module will not reload if last load is passed
- move `$MYZS_SETTINGS_AUTOLOAD_SETUP_LOCAL`, `$MYZS_SETTINGS_SETUP_FILES` and `$MYZS_LOG_LEVEL` to new settings format
- add new settings `myzs/zplug` for enabled / disabled zplug completely
- change settings `path/auto-open` to `automatic/open-path`
- change default metrics to disabled
- add **alias/git.sh** by default
- remove **src/alias/fuck.sh** use `myzs-plugins/thefuck#master` plugins instead
- remove **src/app/generator.sh** and **src/app/github.sh** use `kamontat/mplugin-kamontat#master` plugins instead
- remove **src/app/fuck.sh**
- remove **src/app/fzf.sh**
- remove **src/app/trivis.sh**
- support settings value as array
- comment a lot of unused zplug plugins
- remove all `_myzs:internal:log:set-level` function
- add new array support apis in settings.sh module
- update helpers apis list
- remove project myzs-setup since git is loaded by default
- remove `$MYZS_TYPE` on plugin template [plugin]
- fix deploy script throw error when beta/alpha version is preset

## Version 5.3.0-beta.2 (15 Apr 2021)

- re-release 5.3.0-beta.1 due to push failed

## Version 5.3.0-beta.1 (15 Apr 2021)

- move settings to single array `${MYZS_LOADING_SETTINGS}`
- add new modules **helper/setting.sh** to manage about all settings
- make all debug log from checker to be lower case
- remove log from `_myzs:internal:checker:string-exist`
- update myzs type to use setting api
- add quote to all data in checker api debug log
- change all warning log from checker api to debug
- remove start command and start command arguments
- remove welcome message
- reduce log when initial modules from 2 to 1 line
- format log level to print on the same column
- remove `$MYZS_USER`, `$__MYZS__USER` and `$DEFAULT_USER`

## Version 5.2.1 (15 Apr 2021)

- regular update version

## Version 5.2.0 (21 Sep 2020)

- [BREAK] refactor plugin loader modules
- [BREAK] migrate some code from private helper to internal helper
- reduce builtin module to `myzs-plugins` plugin
  - move docker and kube to docker plugin
  - move yarn alias and app to nodejs plugin
  - move editor and vim to editor plugin
- remove tmux module from builtin
- change `app/thefuck.sh` to `app/fuck.sh`
- change **data.csv** to **modules.csv** for metric log
- add new plugin metric as plugins.csv file
- add `myzs:log:<silent|debug|info|warn|error>` for compack log settings
- move metric helper to top
- change progress helper loading from using file loader to module loader
- reduce predefined modules and plugins
- add support modules in `settings` and `utils` folder in plugins repository
- change default value of auto-setup-local to true and add `.myzs-setup` as alias for setup local
- update progress typo when start initial script

## Version 5.1.0 (16 Sep 2020)

- [BREAK] change myzs-load to accept at least 2 parameters which is module type and name
- add completion for `myzs-load` command to listed all skipping module (closed #3)
- add new resource format (completion) which hosted completion files (closed #4)
- load completion folder by default in `settings/zsh.sh`
- fix adding new completion path to fpath didn't work and throw error
- new 3 helper method and module helper along with rename search
- remove docker module as it no needs
- update typo in this file (changelog.md)

## Version 5.0.2 (15 Sep 2020)

- fix some typo in the log message and return value
- fix wrong module name in the log message when using skip
- fix unnecessary pass module path to module arguments
- remove changelog of version 4.0.0 - 4.5.2

## Version 5.0.1 (15 Sep 2020)

- fix disable progressbar should not disable loading time
- update document on root and helper
- update default $MYZS_SETTINGS_SETUP_FILES to only 1 file name ("myzs-setup")
- reduce default $MYZS_LOG_LEVEL to log only "error" and "warn"
- update default $MYZS_PG_SHOW_PERF to false
- increase default $MYZS_PG_TIME_DANGER_THRESHOLD_MS from **500** to **600**
- increase default $MYZS_PG_TIME_WARN_THRESHOLD_MS from **100** to **200**

## Version 5.0.0 (15 Sep 2020)

- introduce a new plugin system
- introduce a new module system
- refactor all method to support the new syntax
- the progress bar will support 3 levels of color that is normal, warning, and danger
- support config progress bar message size via $MYZS_PG_FULLMESSAGE_LENGTH and $MYZS_PG_MESSAGE_KEY_LENGTH
- support disable some log level as $MYZS_LOG_LEVEL variable
- support disabled progress bar via .zshrc config
- improve log message for progress dump in small type
- reduce builtin module, and use a plugin instead
- module resolve will check all builtin and plugin files. It might cause a high load
- `myzs-download` now support upgrade myzs and myzs-p

## Version 4.8.0 (10 Sep 2020)

- move `alias/agoda.sh` to `app/agoda.sh`
- add gitgo config to ensure commit syntax
- change private and internal method name to prefix with _
- add 2 more command myzs-git-personal (mgitp) and myzs-git-agoda (mgita)
- add new config $MYZS_SETTINGS_SETUP_FILES to custom myzs setup files
- myzs-setup-local now able to load multiple files (base on $MYZS_SETTINGS_SETUP_FILES config)

## Version 4.7.5 (04 Sep 2020)

- update default plugins list
- improvement of utilities and helper code
- create changelog as file (CHANGELOG.md)
- add `__myzs_loop_changelogs` <cmd> to preform action to changelogs

## Version 4.7.4 (28 Aug 2020)

- fix zplug not found

## Version 4.7.3 (25 Aug 2020)

- change metric from /caches/data.csv to /data/metric.csv
- improve metrics format as load time in millisecond
- refactor modules deserialization
- add support loop modules by function
- add new agrun-<application> category in alias/agoda.sh

## Version 4.7.2 (22 Aug 2020)

- add new alias/project.sh modules for create new tmp project
- include environment loading in progress bar
- remove gc for git commit and use gcm for git commit
- change gcod from dev branch to develop branch
- fix linter in ggc command
- cleanup output from myzs-info message
- fix 'mload' didn't check modules name before load
- add 'minfo' as alias of 'myzs-info'
- add 'reshell' as alias of 'restart-shell'

## Version 4.7.1 (10 Aug 2020)

- add short command as default enable modules

## Version 4.7.0 (10 Aug 2020)

- reduce start time by loading only important modules
- add myzs-load / mload for load modules after initial finish
- alias all myzs-XXXXX command
- reduce start time from ~7 seconds to ~2 seconds
- add .myzs-setup file to automatic load when it present (configuable)
- manually load .myzs-setup file by run myzs-setup-local command

## Version 4.6.0 (10 Aug 2020)

- change logic to load modules
- remove exclude module variable
- add prefix to modules name
- improve around 1% load time
