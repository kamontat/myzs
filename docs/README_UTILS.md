# Utilities APIs

- [Preload](#preload)
- [Database](#database)
- [Checker](#checker)
- [Logger](#logger)
- [Common](#common)
- [Setting](#setting)
- [Module](#module)
- [Plugin](#plugin)
- [Changelog](#changelog)
- [Metric](#metric)
- [Zplug](#zplug)
- [Group](#group)

## Preload

<details>
  <summary>
    <strong>_myzs:internal:call(cmd, ...args)</strong> - execute _myzs:internal:[cmd] if exist, silent ignore
  </summary>

This method is for execute internal command but we not sure is it available or not

```bash
# e.g. with debug log
_myzs:internal:call log:debug "debug message"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:call-or(cmd, fallback, ...args)</strong> - execute _myzs:internal:[cmd] if exist, or fallback command
  </summary>

This method is for execute internal command but we not sure is it available or not

```bash
# e.g. with debug log or echo if log not available
_myzs:internal:call log:debug echo "debug message"
```
</details>

## Database

<details>
  <summary>
    <strong>_myzs:internal:db:varname(key, name)</strong> - convert key and name to database key
  </summary>

Usually we would use this directly, but I expose this method for client convenience

```bash
# e.g. generator variable by combine key and name
_myzs:internal:db:varname "setting" "data-setup"
```

</details>


<details>
  <summary>
    <strong>_myzs:internal:db:setter:string(key, name, data)</strong> - save data to database key
  </summary>

We will create variable with given key and name, with data inside

```bash
# e.g. setup setting color to blue
_myzs:internal:db:setter:string "setting" "color" "blue"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:setter:number(key, name, data)</strong> - same with `_myzs:internal:db:setter:string(key, name, data)`
  </summary>

We will create variable with given key and name, with data inside

```bash
# e.g. setup batch size to 15
_myzs:internal:db:setter:string "setting" "batch-size" 15
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:setter:array(key, name, ...args)</strong> - save args to database key as array type
  </summary>

We will create variable with given key and name, with initial array data to that variable name

```bash
# e.g. setup support ids to 5, 6, 7, and 8
_myzs:internal:db:setter:array "setting" "support-ids" 5 6 7 8
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:setter:enabled(key, name)</strong> - mark database key as true
  </summary>

Internally, we use _myzs:internal:db:setter:string to set value as 'true'

```bash
# e.g. enable module experiment
_myzs:internal:db:setter:enabled "module" "experiment"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:setter:disabled(key, name)</strong> - mark database key as false
  </summary>

Internally, we use _myzs:internal:db:setter:string to set value as 'false'

```bash
# e.g. disabled module experiment
_myzs:internal:db:setter:disabled "module" "experiment"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:append:array(key, name, ...args)</strong> - append array args to database key
  </summary>

We will append or create data to given key and name variable

```bash
# e.g. add more element in support ids
_myzs:internal:db:append:array "setting" "support-ids" 10, 11, 12
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:getter:string(key, name, [fallback])</strong> - query data or fallback data
  </summary>

We query data from given database key or using fallback data if data on database key is not exist

```bash
# e.g. get plugin status or return unknown if data is missing
_myzs:internal:db:getter:string "plugin" "status" "unknown"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:getter:array(key, name, varname)</strong> - initial queried data to given varname
  </summary>

Since bash cannot return array from method, so we use setting variable technique instead

```bash
# e.g. getting user id from database, and echo result
_myzs:internal:db:getter:array "user" "ids" userids
echo "${userids[@]}"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:loader(key, ...args)</strong> - create data from data storage format
  </summary>

We define data storage format so we can create data as array and initial all together once. 
Data storage format: `$ <command_type> <...command_arguments>`. 
Possible `command_type` is all `_myzs:internal:db:getter:<command_type>` method and `_myzs:internal:<key>:getter:<command_type>` if db is not exist

```bash
# e.g. single data creator
_myzs:internal:db:loader "key" "$" "string" "data/example" "hello"
# e.g. multiple data creator
_myzs:internal:db:loader "key" \
  "$" "string" "data/example" "hello" \
  "$" "number" "example/count" 5
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:checker:string(key, name, ...args)</strong> - checking data from database is equals to args
  </summary>

We compare with OR opts, meaning only one args return `true` method will return true instantly

```bash
# e.g. check is type equals to large OR small
_myzs:internal:db:checker:string "setting" "type" "large" "small"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:checker:enabled(key, name)</strong> - check is data equal to enabled value
  </summary>

Checking data must be true. fail to get data will result as non-zero error

```bash
# e.g. check are we enable color
if _myzs:internal:db:checker:enabled "setting" "color"; then
  echo "we enable color"
fi
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:checker:disabled(key, name)</strong> - check is data equal to disabled value
  </summary>

Checking data must be false. fail to get data will result as non-zero error

```bash
# e.g. check are we disable color
if _myzs:internal:db:checker:disabled "setting" "color"; then
  echo "we disable color"
fi
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:checker:greater-than(key, name, number)</strong> - check is data must greater than number
  </summary>

```bash
# e.g. check size more than 100
_myzs:internal:db:checker:greater-than "setting" "name-size" 100
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:checker:less-than(key, name, number)</strong> - check is data must less than number
  </summary>

```bash
# e.g. check time less than 5 (ms)
_myzs:internal:db:checker:less-than "module" "duration" 5
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:db:checker:contains(key, name, ...args)</strong> - check is data contains args or not
  </summary>

This using grep as a searching algorithm for checking contains text

```bash
# e.g. check plugins contains myzs-plugins/core or not
_myzs:internal:db:checker:contains "plugin" "list" "myzs-plugins/core"
```
</details>

## Checker

<details>
  <summary>
    <strong>_myzs:internal:checker:shell:bash</strong> - check current shell is bash?
  </summary>

Return as non-zero code if current shell is not bash

```bash
# e.g. check current shell type
_myzs:internal:checker:shell:bash
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:shell:zsh</strong> - check current shell is zsh?
  </summary>

Return as non-zero code if current shell is not zsh

```bash
# e.g. check current shell type
_myzs:internal:checker:shell:zsh
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:string-exist(string)</strong> - check string is not empty?
  </summary>

Input as command string and return zero if input string is exist

```bash
# e.g. check is input == "" (empty string) or not
_myzs:internal:checker:string-exist ""
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:command-exist(string)</strong> - check string is executable?
  </summary>

Input as command string, and will check whether command is executable

```bash
# e.g. check is grep command exist or not
_myzs:internal:checker:command-exist "grep"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:file-exist(string)</strong> - check filepath is available and correct
  </summary>

Input filepath and will check is input file is exist or not
Will return non-zero if file is not exist or it's not file (for example it's directory)

```bash
# e.g. check is data.txt in tmp directory is exist or not
_myzs:internal:checker:file-exist "/tmp/data.txt"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:folder-exist(string)</strong> - check dirpath is available and correct
  </summary>

Input dirpath and will check is input directory is exist or not.
Will return non-zero if directory is not exist or it's not directory

```bash
# e.g. check is caching is exist and it's directory
_myzs:internal:checker:folder-exist "/tmp/caching"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:file-contains(string, search)</strong> - file content must contains search string
  </summary>

read file content from input filepath string, and check if it contains input string or not

```bash
# e.g. data.txt is contains 'hello world' or not
_myzs:internal:checker:file-contains "./data.txt" "hello world"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:small-type</strong> - myzs type is small, or not?
  </summary>

reading data from myzs setting, and check type

```bash
# e.g. current terminal loading with small type
_myzs:internal:checker:small-type
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:fully-type</strong> - myzs type is fully, or not?
  </summary>

reading data from myzs setting, and check type

```bash
# e.g. current terminal loading with fully type
_myzs:internal:checker:fully-type
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:checker:mac</strong> - check is current os is macos?
  </summary>

return zero code if current os is macos

```bash
# e.g. running on macos
_myzs:internal:checker:mac
```
</details>

## Logger

<details>
  <summary>
    <strong>_myzs:internal:log:debug(...args)</strong> - log debug message to log file
  </summary>

formatted debug message and write to log file ($MYZS_LOGPATH)

```bash
# e.g. print debug message to log file
_myzs:internal:log:debug "this is debug message"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:log:info(...args)</strong> - log info message to log file
  </summary>

formatted info message and write to log file ($MYZS_LOGPATH)

```bash
# e.g. print info message to log file
_myzs:internal:log:info "this is info message"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:log:warn(...args)</strong> - log warn message to log file
  </summary>

formatted warn message and write to log file ($MYZS_LOGPATH)

```bash
# e.g. print warn message to log file
_myzs:internal:log:warn "this is warn message"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:log:error(...args)</strong> - log error message to log file
  </summary>

formatted error message and write to log file ($MYZS_LOGPATH)

```bash
# e.g. print error message to log file
_myzs:internal:log:error "this is error message"
```
</details>

## Common

<details>
  <summary>
    <strong>myzs:module:new($0)</strong> - start new module $0 is module filepath
  </summary>

This will initial and notify script to know that new module is created

```bash
# e.g. initial new module
myzs:module:new "$0"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:module:cleanup(key)</strong> - cleanup module with optional module key
  </summary>

It will cleanup module from given key if no key provided it will try to find current module from memory

```bash
# e.g. cleanup builtin/core
_myzs:internal:module:cleanup "builtin#app/core.sh"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:project:cleanup</strong> - cleanup whole project
  </summary>

This must be called only on the end of `.zshrc` file

```bash
# e.g. cleanup project
_myzs:internal:project:cleanup
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:shell([zsh], [bash])</strong> - return input base on current shell
  </summary>

It's will check current shell name and return input string base on shell that you on

```bash
# e.g. on bash shell, this will return bash
#      on zsh  shell, this will return zsh
_myzs:internal:shell
# e.g. on bash shell, this will return bbb
#      on zsh  shell, this will return zzz
_myzs:internal:shell 'zzz' 'bbb'
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:load(name, path)</strong> - source input "path"
  </summary>

This will load input path to current shell env and write result to log file.
Exit code:
- 0   - successfully
- 4   - file not found
- ANY - error code from input file

```bash
# source file from /tmp/test.sh
_myzs:internal:load "test" "/tmp/test.sh"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:alias(key, value)</strong> - safe create alias
  </summary>

Safe create alias only if command is not existed

```bash
# alias b to boom
_myzs:internal:alias "b" "boom"
```
</details>


<details>
  <summary>
    <strong>_myzs:internal:alias-force(key, value)</strong> - force create alias
  </summary>

Create alias or overwrite if it existed

```bash
# alias b to boom
_myzs:internal:alias "b" "boom"
```
</details>


1.  `_myzs:internal:fpath-push(...path)` - push all input path to the end of fpath array
2.  `_myzs:internal:manpath-push(...path)` - push all input path to the end of manpath array
3.  `_myzs:internal:path-push(...path)` - push all input path to the end of path variable
4.  `_myzs:internal:path-append(...path)` - append all input path to a first of path variable

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
4. `_myzs:internal:module:search-name(name, cmd)` - search module key and start callback
5. `_myzs:internal:module:search-module-type(type, cmd)` - search module by type and start callback
6. `_myzs:internal:module:fullpath(name)` - get module path by name
7. `_myzs:internal:module:load(name, filepath)` - load file as module
8.  `_myzs:internal:module:skip(name, filepath)` - mark file as skipped module
9.  `_myzs:internal:module:loaded-list(cmd)` - loop loaded modules with status
10. `_myzs:internal:module:total-list(cmd)` - loop all exist modules and myzs builtin and plugins

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

## Group

1. `_myzs:internal:group:initial(...args)` - parse formated args and install as group data
2. `_myzs:internal:group:load(name)` - load group name to current terminal
