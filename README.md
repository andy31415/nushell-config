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

source $"($myconfig_path)/aliases.nu"
source $"($myconfig_path)/helpers.nu"
source $"($myconfig_path)/keybindings.nu"

source ~/.cache/starship/init.nu
```

## Other recommended items

I use the following as well:

Use [pueue](https://github.com/Nukesor/pueue) to have background tasks (tasks below will also use it). Generally `cargo install pueue` and then `pueued -d`

Using [starship](https://starship.rs/). Generally `cargo install starship`

From [nu_scripts](https://github.com/nushell/nu_scripts):

```nu

# Custom completions
source ~/devel/nu_scripts/custom-completions/bat/bat-completions.nu
source ~/devel/nu_scripts/custom-completions/cargo/cargo-completions.nu
source ~/devel/nu_scripts/custom-completions/docker/docker-completions.nu
source ~/devel/nu_scripts/custom-completions/git/git-completions.nu
source ~/devel/nu_scripts/custom-completions/just/just-completions.nu
source ~/devel/nu_scripts/custom-completions/make/make-completions.nu
source ~/devel/nu_scripts/custom-completions/npm/npm-completions.nu
source ~/devel/nu_scripts/custom-completions/pytest/pytest-completions.nu
source ~/devel/nu_scripts/custom-completions/rustup/rustup-completions.nu
source ~/devel/nu_scripts/custom-completions/ssh/ssh-completions.nu
source ~/devel/nu_scripts/custom-completions/tar/tar-completions.nu
source ~/devel/nu_scripts/custom-completions/virsh/virsh-completions.nu

# backtround tasks: "task spawn"
use ~/devel/nu_scripts/modules/background_task/task.nu
```

```

```
