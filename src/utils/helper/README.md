# List of utilities inside this directory

## Checker

1. `_myzs:internal:checker:shell:bash` - check current shell is bash?
2. `_myzs:internal:checker:shell:zsh` - check current shell is zsh?
3. `_myzs:internal:checker:shell:fish` - check current shell is fish?
4. `_myzs:internal:checker:command-exist(string)` - check is input string is executable?
5. `_myzs:internal:checker:file-exist(string)` - check is input path is file?
6. `_myzs:internal:checker:folder-exist(string)` - check is input path is folder?
7. `_myzs:internal:checker:file-contains(string, search)` - check is file content contains search string?
8. `_myzs:internal:checker:string-exist(string)` - check is input string is empty or not?
9. `_myzs:internal:checker:small-type` - check type of config is small?
10. `_myzs:internal:checker:fully-type` - check type of config is fully?
11. `_myzs:internal:checker:mac` - check is current os is macos?

## Logger

1. `_myzs:internal:log:debug` - log **debug** message to log file
2. `_myzs:internal:log:info` - log **info** message to log file
3. `_myzs:internal:log:warn` - log **warn** message to log file
4. `_myzs:internal:log:error` - log **error** message to log file

## Common

1. `_myzs:internal:completed` - return zero exit code
2. `_myzs:internal:failed(number)` - return non-zero exit code
3. `_myzs:internal:shell([zsh], [bash], [fish])` - return input start base on current shell
4. `_myzs:internal:module:initial($0)` - initial module, should add to first line of code
5. `_myzs:internal:module:cleanup` - cleanup all initial setup
6. `_myzs:internal:project:cleanup` - cleaning .zshrc, must add to end of code in .zshrc file
7. `_myzs:internal:load(name, path)` - load path via source "path" and log result to log file
8. `_myzs:internal:alias(key, value)` - alias key to value (ignore is key is existed)
9. `_myzs:internal:alias-force(key, value)` - alias key to value
10. `_myzs:internal:fpath-push(...path)` - push all input path to the end of fpath array
11. `_myzs:internal:manpath-push(...path)` - push all input path to the end of manpath array
12. `_myzs:internal:path-push(...path)` - push all input path to the end of path variable
13. `_myzs:internal:path-append(...path)` - append all input path to a first of path variable

## Module

1. `_myzs:internal:module:checker:validate(name)` - check is input a valid module
2. `_myzs:internal:module:index(name)` - get module index or -1 if not exist
3. `_myzs:internal:module:status(name)` - get module status by name, otherwise exit non-zero
4. `_myzs:internal:module:fullpath(name)` - get module path by name
5. `_myzs:internal:module:load(filename, filepath)` - load file as module
6. `_myzs:internal:module:skip(filename, filepath)` - mark file as skipped module
7. `_myzs:internal:module:loop(cmd)` - loop modules and execute input function

## Plugin

1. `_myzs:private:initial-plugins` - download plugin repository from github and initial to project

## Changelog

1. `_myzs:internal:changelog:loop(cmd)` - loop changelog and execute input function

## Metric

1. `_myzs:internal:metric:saved` - saving information to metric file

## Zplug

1. `myzs:zplug:checker:plugin-installed` - check is zplug plugin installed