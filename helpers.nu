# Select a specific file using sk, reasonably fast
# Ignores third_party and out by default
#
# Use to pipe to future commands like git lg or vim
def sf [] {
  sk -c {fd -HI -E third_party -E out .} --preview {bat -f $in}
}

# Select a specific file using sk, reasonably fast
# Ignores third_party and out by default
#
# Use to pipe to future commands that accept multiple files as arguments
def smf [] {
  sk -m -c {fd -HI -E third_party -E out .} --preview {bat -f $in}
}
