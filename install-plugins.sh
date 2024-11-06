#!/usr/bin/env nu

echo "Set up starship config for nu"

if not ('~/.cache/starship' | path exists ) { 
  mkdir ~/.cache/starship
  starship init nu | save -f ~/.cache/starship/init.nu
}


echo "Installing SKIM plugin..."
cargo install nu_plugin_skim
plugin add ~/.cargo/bin/nu_plugin_skim

echo "Installing clipboard plugin"
cargo install nu_plugin_clipboard
plugin add ~/.cargo/bin/nu_plugin_clipboard

# NOT INSTALLED: not yet updated to latest nushell
# echo "Installing compress plugin"
# cargo install nu_plugin_compress
# plugin add ~/.cargo/bin/nu_plugin_compress
