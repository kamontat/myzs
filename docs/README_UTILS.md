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
4. `_myzs:internal:module:search-name(name, cmd)` - search module key and start callback
5. `_myzs:internal:module:search-module-type(type, cmd)` - search module by type and start callback
6. `_myzs:internal:module:fullpath(name)` - get module path by name
7. `_myzs:internal:module:load(filename, filepath)` - load file as module
8.  `_myzs:internal:module:skip(filename, filepath)` - mark file as skipped module
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
