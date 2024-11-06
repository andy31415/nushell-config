# NUShell aliases

## Prerequisites

These scripts require some things from [awesome-nu](https://github.com/nushell/awesome-nu).

Specifically run `install-plugins.sh`

## Usage

Edit using `config nu` and add something like:

```nu
# NOTE: cannot use $env.HOME as it is not a compile time constant
#
# see https://www.nushell.sh/book/how_nushell_code_gets_run.html#parse-time-evaluation
const myconfig_path = ("/home/andrei" | path join "devel" "nushell-config")

source $"($myconfig_path)/aliases.nu"
source $"($myconfig_path)/helpers.nu"
source $"($myconfig_path)/keybindings.nu"

source ~/.cache/starship/init.nu
```
