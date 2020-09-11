# Naming

Work in process, not implement yet.

## Variable

1. Every variable must be uppercase
2. only `A-Z` and `0-9` and `_` are accepted

### Internal

Internal variable is a private variable and 
shouldn't read or write by any end user.

1. Must prefix with `__MYZS__`

### External

External variable is a readonly variable 
writing anything might cause scripts crash or bug.

1. Must prefix with `_MYZS_`

### Configable

Configable variable is a read / write variable
which able to set what ever value it needs to
update script configuration

1. Must prefix with `MYZS_`

## Method

1. Every method must be lowercase
2. only `a-z`, `-` and `:` are accepted

### Private

Private method should using by current file only, 
not shared with any files or directories

1. Must prefix with `_myzs:private:`

### Internal

Internal method will available for this scripts only.
This not meant to used by any end user.
Expected rapidly changes from time over time.

1. Must prefix with `_myzs:internal:`

### Public

Public method is for end user to use.

1. Must prefix with `myzs:`

# Progressbar

Configable variable syntax

1. Must prefix with `MYZS_PG_`

Method syntax

1. Must prefix with `myzs:pg:`

# Zplug

Configable variable syntax

1. Must prefix with `MYZS_ZP_`

Method syntax

1. Must prefix with `myzs:zplug:`
