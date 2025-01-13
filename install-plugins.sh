#!/usr/bin/env nu

# TODO: temporary removed, have different settings for now
#
# echo "Installing starship"
# cargo install starship
# echo "Set up starship config for nu"
# if not ('~/.cache/starship' | path exists ) { 
#   mkdir ~/.cache/starship
#   starship init nu | save -f ~/.cache/starship/init.nu
# }

let plugins = [
  # Official plugins
  nu_plugin_inc
  nu_plugin_polars
  nu_plugin_gstat
  nu_plugin_formats
  nu_plugin_query

  # Good ones
  nu_plugin_skim
  nu_plugin_clipboard
]

echo "installing some plugins"

$plugins | each {
  echo $"Installing ($in)";
  cargo install $in;
  plugin add ([ "~/.cargo/bin/" $in ] | path join | path expand)
} | ignore

# NOT INSTALLED: not yet updated to latest nushell
# echo "Installing compress plugin"
# cargo install nu_plugin_compress
# plugin add ~/.cargo/bin/nu_plugin_compress
#
echo "Installing pueue for background tasks"
cargo install pueue

echo "Installing just for executing scripts"
cargo install just
