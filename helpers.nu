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
#
# This automatically ignores typical directories, however
# you may want to add more arguments as needed
def nrg --wrapped [
    --no-ignore     # Ignore stadard CHIP dirs (third_party, out, .git)
    --no-hidden     # Do not enter hidden directories
    --add-dir       # Add directory to the output
    ...more_args    # Arguments to pass to `rg` (i.e. ripgrep). Generally term and directory
] {
  let extra_args = []
  let extra_args = if $no_ignore {
    $extra_args
  } else {
    ($extra_args ++ --glob ++ '!third_party' ++ --glob ++ '!out' ++ --glob ++ '!.git')
  }
  let extra_args = if $no_hidden { $extra_args } else { ($extra_args ++ --hidden) }
  let $extra_args = $extra_args ++ $more_args

  let results = rg --color=always -n --hidden --no-ignore ...$extra_args | lines | split column --number 3 ':' path line match | update line {ansi strip | into int}

  let results = if $add_dir {
    $results | insert dir {$in.path | path dirname} | sort-by dir path 
  } else {
    $results | sort-by path
  }

  $results
}
