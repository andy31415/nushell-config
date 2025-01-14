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
const myconfig_path = ([$nu.home-path "devel" "nushell-config"] | path join)

# ORDER is important here ...
source $"($myconfig_path)/helpers.nu"
source $"($myconfig_path)/aliases.nu"
source $"($myconfig_path)/keybindings.nu"

source ~/.cache/starship/init.nu
```

## Other recommended items

I use the following as well (install-plugins also installs these):

- Use [pueue](https://github.com/Nukesor/pueue) to have background tasks (tasks below will also use it).
  Generally `cargo install pueue` and then `pueued -d`,
- Using [starship](https://starship.rs/). Generally `cargo install starship`
- Using [just](https://github.com/casey/just). Generally `cargo install just`
- using [carapace](https://github.com/carapace-sh/carapace/tree/master/example) for completions. Specifically
  see [here](https://carapace-sh.github.io/carapace-bin/setup.html) for install logic.

Should install [jc](https://kellyjonbrazil.github.io/jc/#installation) manually, like `apt-get install jc`.
This way we can convert outputs of commands.

From [nu_scripts](https://github.com/nushell/nu_scripts):

```nu

const nu_scripts_path = ([$nu.home-path "devel" "nu_scripts"] | path join)

# Custom completions
source $"($nu_scripts_path)/custom-completions/bat/bat-completions.nu"
source $"($nu_scripts_path)/custom-completions/cargo/cargo-completions.nu"
source $"($nu_scripts_path)/custom-completions/docker/docker-completions.nu"
source $"($nu_scripts_path)/custom-completions/git/git-completions.nu"
source $"($nu_scripts_path)/custom-completions/just/just-completions.nu"
source $"($nu_scripts_path)/custom-completions/make/make-completions.nu"
source $"($nu_scripts_path)/custom-completions/npm/npm-completions.nu"
source $"($nu_scripts_path)/custom-completions/pytest/pytest-completions.nu"
source $"($nu_scripts_path)/custom-completions/rustup/rustup-completions.nu"
source $"($nu_scripts_path)/custom-completions/ssh/ssh-completions.nu"
source $"($nu_scripts_path)/custom-completions/tar/tar-completions.nu"
source $"($nu_scripts_path)/custom-completions/virsh/virsh-completions.nu"

# backtround tasks: "task spawn"
use $"($nu_scripts_path)/modules/background_task/task.nu"

# JC support
use $"($nu_scripts_path)/modules/jc"

# Available "sockets" call
use $"($nu_scripts_path)/modules/network/sockets/sockets.nu"

# Theme that seems ok
source $"($nu_scripts_path)/themes/nu-themes/harper.nu"

```
