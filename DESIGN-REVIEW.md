# Design review

- [Description](#description)
- [Myzs Plugins](#myzs-plugins)
- [Variables syntax](#variables-syntax)
  - [Public variable](#public-variable)
  - [Protected variable](#protected-variable)
  - [Private variable](#private-variable)
- [Functions syntax](#functions-syntax)
  - [Public function](#public-function)
  - [Protected function](#protected-function)
  - [Private function](#private-function)

## Description

MYZS - Core repository contains all builtin utilities.
We have plugins, modules, settings and groups concept.
**Plugins** is a set of code provide functionality to core repository
with plug and play principle. Each plugin can contains **module**

1. Configure initiate plugins in `configs/plugins.sh`

```bash
# Default branch is `main`
myzs__plugins_add "myzs-plugins/core"
# Custom branch is `master`
myzs__plugins_add "myzs-plugins/git" "master"
```

2. Configure initiate modules for preload on startup in `configs/modules.sh`

```bash
# Add app/myzs.sh from myzs-plugins/core plugin
myzs__modules_add "myzs-plugins/core" "app/myzs.sh"
# Add all alias/*.sh from myzs-plugins/git plugin
myzs__modules_add "myzs-plugins/git" "alias"
```

1. Configure global settings in `configs/settings.sh`

```bash
# Setup 'core/myzs/enabled' to true boolean
myzs__modules_setting_set "core/myzs/enabled" "true"
# Setup 'core/progress/color' to "red" string
myzs__modules_setting_set "core/progress/color" "red"
# Setup 'core/logger/level' to list of string
myzs__modules_setting_set "core/logger/level" "error" "warn" "info" "debug"
```

1. Configure custom groups

```bash
# Add all modules from myzs-plugins/core to `dev` group
myzs__groups_add-plugin "dev" "myzs-plugins/core"
# Add only module `alias/git.sh` from myzs-plugins/git to `dev` group
myzs__groups_add-module "dev" "myzs-plugins/git" "alias/git.sh"
# Add another group on `dev` group
myzs__groups_add-group  "dev" "test"                                                                                                                     
```

## Myzs Plugins

`MYZS_PLUGINS` - Plugins for extends MYZS. Contains `modules`, `groups`, `settings`

Plugin Structure
   1. myzs-init.sh  - plugins information
   2. groups/*.sh   - plugin group for single command action
   3. apps/*.sh     - app module (this will skip if user on SMALL type)
   4. alias/*.sh    - alias definition module
   5. settings/*.sh - module settings definition

## Variables syntax

For Variable all characters must be UPPER_CASE and can be only `A-Z`, `0-9` and `_`.
However, both module and submodule name can NOT have any special characters.

Submodule is **optional**.

### Public variable

> Syntax: `MYZS__<module_name>_<submodule_name>_<key>` (e.g. `MYZS_LOGGER_FILENAME`)

This is read and write permission variable
However, update this variable will not guaranteed will be read on current shell.

### Protected variable

> Syntax: `_MYZS__<module_name>_<submodule_name>_<key>` (e.g. `_MYZS_LOGGER_FILEPATH`)

This should be read only and should not manually update on any circumstance;
Otherwise, it might break application.

### Private variable

> Syntax: `__MYZS__<module_name>_<submodule_name>_<key>` (e.g. `__MYZS__PLUGINS_CURRENT_LOAD`)

This should be deleted after initiate script is completed.
If this variable visible after initiate, it might possible mean bug.
You should not depend on this kind of variables.

## Functions syntax

For functions characters usage

- All characters must be **lower_case**.
- Module name can be `a-z` only.
- Submodule name can be `a-z` only.
- Action can be `a-z` and `-` only.

For function key description

- Module is directory name where file located.
- Submodule(**optional**) is sub directory name where file located.
- Action must be verb v1 only

### Public function

> Syntax: `myzs__<module_name>_<submodule_name>_<action>` (e.g. `myzs__core_module_add`)

All functions with this syntax will have proper document, break change and version.
You can call this function from any-place any-time.

### Protected function

> Syntax: `_myzs__<module_name>_<submodule_name>_<action>` (e.g. `_myzs__group_load`)

This function will have proper document 
however, it will not notice if there are some break change.
You should not call this function outside initiate phase.

### Private function

> Syntax: `__myzs__<module_name>_<submodule_name>_<action>` (e.g. `__myzs__group_parser`)

This is private function for same file only.
You must not call this function.
