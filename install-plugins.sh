#!/usr/bin/env nu

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
