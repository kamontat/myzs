# Release notes

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

## Version 4.5.2 (13 Jul 2020)

- update alias of agoda and mac
- update app of asdf and add new tmux app
- add more helper in utils helper
- update some minor config in init.sh

## Version 4.5.1 (18 Jun 2020)

- update some default variable
- improve documents on zshrc file

## Version 4.5.0 (18 Jun 2020)

- Introduce new command 'myzs-info' for print myzs information
- Introduce new command 'myzs-list-changelogs' for print myzs changelogs
- Add filename to log message
- Change log files location to /tmp/myzs/logs
- Rename logfile variable from $MYZS_LOGFILE to $MYZS_LOGPATH
- Update new changelog format

## Version 4.4.0 (01 Jun 2020)

- Add substring history search plugins
- Add more alias and application

## Version 4.3.0 (24 Apr 2020)

- Add modules loaded
- Add new myzs command myzs-list-modules
- Add start command

## Version 4.2.0 (15 Apr 2020)

- Add skipping process
- Add new customizable settings

## Version 4.1.1 (04 Feb 2020)

- Add documentation
- Change some default value

## Version 4.1.0 (31 Dec 2019)

- Add more alias
- Fix log detail missing
- Fix duplicate $PATH variable

## Version 4.0.0 (23 Sep 2019)

- First v4.x.x released
