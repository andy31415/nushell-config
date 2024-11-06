#!/usr/bin/env nu
echo "Installing SKIM plugin..."
cargo install nu_plugin_skim
plugin add ~/.cargo/bin/nu_plugin_skim
