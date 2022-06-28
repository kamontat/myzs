# Release notes

We will maintain not more than 10 minor version changes.

## Unreleased

- [TODO] add load time table each release that might effect performance
- [TODO] migrate all utils docs to new format
- [TODO] refactor utils `index.sh` file and use module:load as much as possible
- [TODO] update completion to removed if feature is disabled
- [TODO] improve getting path list and make it configable
- [TODO] refactor `settings/path.sh` and `settings/system.sh`
- [TODO] support loading group inside group to simplify group list
- [TODO] re-enabled myzs.init files to initial some data before and after run plugins
- [TODO] defined exitcode as constants and use everywhere

## Version 5.7.9 (28 Jun 2022)

- add new possible plugins
- prepare design review for next major version

## Version 5.7.8 (08 May 2022)

- add new rust plugins
- add advance profiling metrics
- fix duplicated call setting initiate

## Version 5.7.7 (24 Mar 2022)

- fix auto-complete of myzs changelogs (since `v5.7.3`)

## Version 5.7.6 (24 Mar 2022)

- add `node` group for lts and yarn support
- fix fixed username in $PATH variable

## Version 5.7.4 (30 Nov 2021)

- fix perf usage didn't works in zsh
- add thefuck module as dev group

## Version 5.7.3 (28 Sep 2021)

- add myzs help for more command detail
- change `myzs changelogs` to `myzs changelog`
- remove module key in logging since it didn't work correctly
- remove myzs-setup feature, use group instead
- change some of info log to debug
- move some of warning log to error
- fix `myzs deploy` didn't work when it failed

## Version 5.7.2 (12 Jun 2021)

- getting path list from `/etc/paths` and `/etc/paths.d`

## Version 5.7.1 (12 Jun 2021)

- disabled `app/autocd.sh` in favar of group module feature is faster and easier to use

| Type                           | Tasks | Load time |
| ------------------------------ | ----- | --------- |
| Default config                 | 11    | 3s:463ms  |
| Second load on default config  | 11    | 2s:682ms  |
| Disable group feature          | 10    | 3s:250ms  |
| Enable all log level           | 11    | 4s:138ms  |
| Enable performance log         | 11    | 4s:334ms  |
| Enable all log and performance | 11    | 4s:664ms  |

## Version 5.7.0 (12 Jun 2021)

- [BREAK] change all `pb/*` setting to `pg/*` instead
- [BREAK] change `myzs-*` commands to single `myzs` command with subcommand instead
  - `myzs-upload`          changes to `myzs deploy [all|app|plugin]`  (alias `mdp`)
  - `myzs-download`        changes to `myzs upgrade [all|app|plugin]` (alias `mup`)
  - `myzs-info`            changes to `myzs info`                     (alias `mi`)
  - `myzs-load`            changes to `myzs load`                     (alias `ml`)
  - `myzs-list-changelogs` changes to `myzs changelogs`               (alias `mcs`)
  - `myzs-list-modules`    changes to `myzs modules`                  (alias `mms`)
- new loading variable called `MYZS_LOADING_GROUPS` with same format of settings but command type is only **group**
- new task on initialization for loading group data
- new group feature for grouping multiple modules from different plugins together, you can toggle via setting `group`
- new myzs subcommand called `loads` (alias `mls`) for loading group to current terminal
- migrate several utils document format to new version using details in Github
- migrate all `myzs-*` completion to `myzs` command instead
- reduce number of files by reduce v1 of plugins and settings util
- did not load certain utils if feature of that utils is disabled, currently support group and metrics
- cleanup comments on database apis
- fix metric methods not found when we disable them
- fix module always add to module csv even we skip them
- fix database custom setter didn't work
- fix plugin cache isn't works on 5.6.x
- fix pg (progressbar) command not found when run with small type

## Version 5.6.2 (10 Jun 2021)

- fix application type missing on `myzs-info`

## Version 5.6.1 (10 Jun 2021)

- change default time format to `%S:%l` (1s:200ms)
- remove myzs/ prefix in settings
- add configable caching plugins in settings (`plugin/cache`)
- significate reduce load time from `~5s -> ~3s` and `~10s -> ~5s`
- disable plugins module by default except some of core modules and builtin module

| Type                           | Tasks | Load time |
| ------------------------------ | ----- | --------- |
| Default config                 | 10    | 3s:181ms  |
| Second load on default config  | 10    | 2s:319ms  |
| Enable all log level           | 10    | 3s:570ms  |
| Enable performance log         | 10    | 3s:800ms  |
| Enable all log and performance | 10    | 4s:179ms  |

## Version 5.6.0 (09 Jun 2021)

- [BREAK] change `_myzs:internal:module:initial` method to `myzs:module:new`
- add configable progressbar time format
- add configable aggregate progressbar in plugin and module
- add plugin cache to improve load time when we fetch on second time (reduce ~70%)
- update document about greater and less than data
- expose module key when deserialize module key
- remove plugin data from init file
- remove unused function in modules
- reduce condition on zplugin loading process
- move zplug loader to end of init process
- improve loadtest output
- add new apis to modified progressbar message
- add doc to start deploy-plugin
- create module `autopath` instead of automatic/open-path settings
- fix title when generator table in myzs-list-module
- when we run autocompletion on `myzs-load` it will auto load modules on given plugin
- improve _myzs:internal:changelog:loop to return changelog index as well
- migrate new format of readme document

## Version 5.5.3 (09 Jun 2021)

- reduce directory check on plugins
- add new error log when validate module failed
- remove variable cleanup because it might use via `myzs-*` commands
- add new apis `_myzs:internal:call-or` for calling if internal command exist or fallback command
- reduce more debug log on low level checker
- auto create directory before anything
- change zplug plugin to zplugin and myzs-plugin to plugin to avoid confuse
- now we can append array in database data via `_myzs:internal:db:append:array`
- implement plugins system to depend on database apis (similar with setting)
- due to migration plugins system, plugin metrics will disabled for a while
- improve how plugin method works to simpify custom steps
- update LOC.md

| Type                               | Tasks | Load time |
| ---------------------------------- | ----- | --------- |
| Default config                     | 28    | 5s:122ms  |
| Enable all log level               | 28    | 5s:607ms  |
| Enable performance log             | 28    | 6s:702ms  |
| Enabled all log and performance    | 28    | 7s:166ms  |
| Enabled all available myzs-plugins | 43    | 7s:368ms  |
| Enabled all features and plugins   | 43    | 10s:474ms |

## Version 5.5.2 (07 Jun 2021)

- add `myzs-debug` with same parameters with myzs-measure, it will print all executed commands
- improve `myzs-measure` to expose error code to exit as well
- improve progressbar on success, skip, and failure case
- fix manpage error on macos
- remove duplicate setup with autocd module
- reduce output length on several place (e.g. progressbar, debug log, or error message)
- remove some useless debug log to improve load time
- remove initial `init file` when load plugin, since we didn't use it anywhere

| Type                                 | Load time |
| ------------------------------------ | --------- |
| All features and plugins             | 13s:148ms |
| Exclude performance                  | 9s:177ms  |
| enabled only error from above config | 8s:667ms  |
| Enabled 3 plugins from above config  | 4s:723ms  |

## Version 5.5.1 (05 Jun 2021)

- reduce 5 builtin modules and create separate plugins instead
- add `app/autocd` module for autoload myzs-setup file if exist when cd to directory
- remove all low-level log, this reduce loadtime up to 35%
- update default values in **.zshrc** file
- not enabled **app/vscode** and **app/git** modules by default
- document database apis and settings apis

## Version 5.5.0 (05 Jun 2021)

- add new database apis in utils for create, update data using in myzs
- move env support as builtin module (you can disable via remove from loading module)
- add new command `myzs-loadtest <n> <cmd...>` for measure and calculate average timing (ms)
- if you didn't provide myzs type, by default it will loading every specify modules
- migrated new settings apis to database apis and deprecate old setting version (will remove soon)
- change golang default path to **$HOME/go**
- avoid calling unknown method when setup setting command type
- fix myzs-info report wrong loading duration when running myzs-measure
- fix revolver throw wrong exception when pg/style is invalid
- upgrade gitgo from v4 to v5 to support new features
- create poc module group (not working)

## Version 5.4.0 (10 May 2021)

- remove MYZS_DEBUG since it useless on debugging (too many log)
- do cleanup on each module loaded instead
- `_myzs:internal:module:cleanup` is accept optional module_key
- notice that `__MYZS__CURRENT_MODULE_*` will exist until end of loading only (not carry over)

## Version 5.3.5 (10 May 2021)

- wrong License type on `myzs-info` command (it should be **AGPL-3.0**, not **MIT**)

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
