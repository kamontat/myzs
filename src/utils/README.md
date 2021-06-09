# List of utilities inside this directory

## Preload

1. `_myzs:internal:call(cmd, ...args)` - execute **_myzs:internal:<cmd>** when it exist, silent ignore if not
2. `_myzs:internal:call-or(cmd, fallback, ...args)` - execute **_myzs:internal:<cmd>** when it exist, or fallback command if not

## Database

1. `_myzs:internal:db:varname(key, name)` - combine **key** and **name** to data key
2. `_myzs:internal:db:setter:string(key, name, data)` - save **data** content to **key & name**
3. `_myzs:internal:db:setter:number(key, name, data)` - mirror `_myzs:internal:db:setter:string`
4. `_myzs:internal:db:setter:array(key, name, ...args)` - save **args** array to **key & name**
5. `_myzs:internal:db:append:array(key, name, ...args)` - append **args** array to **key & name**
6. `_myzs:internal:db:setter:disabled(key, name)` - set **key & name** to false
7. `_myzs:internal:db:setter:enabled(key, name)` - set **key & name** to true
8. `_myzs:internal:db:getter:string(key, name, [default])` - return data at **key & name**
9. `_myzs:internal:db:getter:array(key, name, varname)` - get array and set result as varname
10. `_myzs:internal:db:loader(key, ...args)` - load database format array and saved to key
11. `_myzs:internal:db:checker:string(key, name, ...args)` - compare each **args** with data get from **key & name**
12. `_myzs:internal:db:checker:enabled(key, name)` - compare is data on **key & name** is true or not
13. `_myzs:internal:db:checker:disabled(key, name)` - compare is data on **key & name** is false or not
14. `_myzs:internal:db:checker:greater-than(key, name, ...args)` - compare each **args** with data get from **key & name**
15. `_myzs:internal:db:checker:less-than(key, name, ...args)` - compare each **args** with data get from **key & name**
16. `_myzs:internal:db:checker:contains(key, name, ...args)` - compare each **args** contains data get from **key & name**

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
4. `myzs:module:new($0)` - initial module, should add to first line of code
5. `_myzs:internal:module:cleanup(key)` - cleanup module data with optional module_key
6. `_myzs:internal:project:cleanup` - cleaning .zshrc, must add to end of code in .zshrc file
7. `_myzs:internal:load(name, path)` - load path via source "path" and log result to log file
8. `_myzs:internal:alias(key, value)` - alias key to value (ignore is key is existed)
9. `_myzs:internal:alias-force(key, value)` - alias key to value
10. `_myzs:internal:fpath-push(...path)` - push all input path to the end of fpath array
11. `_myzs:internal:manpath-push(...path)` - push all input path to the end of manpath array
12. `_myzs:internal:path-push(...path)` - push all input path to the end of path variable
13. `_myzs:internal:path-append(...path)` - append all input path to a first of path variable

## Setting

1. `_myzs:internal:setting:initial` - build settings data from `${MYZS_LOADING_SETTINGS}` array
2. `_myzs:internal:setting:is-enabled(name)` - checking is **setting name** is enabled or not (return non-zero)
3. `_myzs:internal:setting:is-disabled(name)` - checking is **setting name** is disabled or not (return non-zero)
4. `_myzs:internal:setting:is(name, ...value)` - check is **setting name** equals to values or not (return non-zero)
5. `_myzs:internal:setting:greater-than(name, ...value)` - check is **setting name** greater than values or not (return non-zero)
6. `_myzs:internal:setting:less-than(name, ...value)` - check is **setting name** less than values or not (return non-zero)
7. `_myzs:internal:setting:contains(name, ...value)` - check is **setting name** contains in value or not (return non-zero)
8. `myzs:setting:get(name, fallback)` - return value of **setting name** or fallback if data not exist
9. `myzs:setting:get-array(name, varname)` - set array value to input `varname`

## Module

1. `_myzs:internal:module:name-deserialize(key, cmd)` - convert module key and call cmd with cmd(type, name, key)
2. `_myzs:internal:module:name-serialize(type, name)` - convert module type and name back to key 
3. `_myzs:internal:module:checker:validate(name)` - check is input a valid module
4. `_myzs:internal:module:index(name)` - get module index or -1 if not exist
5. `_myzs:internal:module:search-name(name, cmd)` - search module key and start callback
6. `_myzs:internal:module:search-module-type(type, cmd)` - search module by type and start callback
7. `_myzs:internal:module:search-status(status, cmd)` - search module by status (pass|fail|skip) and start callback
8. `_myzs:internal:module:fullpath(name)` - get module path by name
9. `_myzs:internal:module:load(filename, filepath)` - load file as module
10. `_myzs:internal:module:skip(filename, filepath)` - mark file as skipped module
11. `_myzs:internal:module:loaded-list(cmd)` - loop loaded modules with status
12. `_myzs:internal:module:total-list(cmd)` - loop all exist modules and myzs builtin and plugins

## Plugin

1. `_myzs:internal:plugin:name-deserialize(key)` - convert plugin key (<repo>#<version>) to plugin name and version
2. `_myzs:internal:plugin:name-serialize(name, version)` - convert plugin name and version back to plugin key
3. `_myzs:internal:plugin:install(name, version)` - install plugin repository from github and initial plugin
4. `_myzs:internal:plugin:upgrade(name, version)` - upgrade plugin repository from github and re-initital plugin
5. `_myzs:internal:plugin:initial(...args)` - run installing on each **args** input

## Changelog

1. `_myzs:internal:changelog:loop(cmd)` - loop changelog and execute input function

## Metric

1. `_myzs:internal:metric:log-module` - saving information to metric file

## Zplug

1. `myzs:zplug:checker:plugin-installed` - check is zplug plugin installed
