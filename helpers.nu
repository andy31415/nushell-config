# Select a specific file using sk, reasonably fast
# Ignores third_party and out by default
#
# Use to pipe to future commands like git lg or vim
def sf [] {
  sk -c {fd -HI -E third_party -E out -E .git .} --preview {bat -f $in}
}

# Select a specific file using sk, reasonably fast
# Ignores third_party and out by default
#
# Use to pipe to future commands that accept multiple files as arguments
def smf [] {
  sk -m -c {fd -HI -E third_party -E out -E .git .} --preview {bat -f $in}
}

# Just an LS with sorting
def sorted-ls [...x] {
  ls $x | sort-by type name
}

# Run ripgrep but format it for nushell
def nrg [term, ...paths] {
  rg --color=always -n $term ...$paths | lines | split column --number 3 ':' path line match | update line {ansi strip | into int} | insert dir {$in.path | path dirname} | sort-by dir path
}
