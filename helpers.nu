# Select a specific file using sk, reasonably fast
# Ignores third_party and out by default
#
# Use to pipe to future commands like git lg or vim
def sf [] {
  sk -c {fd -HI -E third_party -E out -E .git .} --preview {bat -f $in}
}

def gs [] {
  (git status --porcelain | detect columns  --no-headers | rename status path)
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
    --include-gen   # Included generated output greps (chip specific)
    --pipe          # when piping, we generally do not want coloring
    ...more_args    # Arguments to pass to `rg` (i.e. ripgrep). Generally term and directory
] {
  # Basically NEVER want to see these:
  let extra_args = [
     --glob '!\.git'
     --glob '!\.mypy_cache'
     --glob '!\.pytest_cache'
     --glob '!\.ruff_cache'
     --glob '!\.cache'
     --glob '!\.ipynb_checkpoints'
  ]

  let extra_args = if $no_ignore {
    $extra_args
  } else {
    [...$extra_args --glob '!third_party' --glob '!out']
  }
  let extra_args = if $no_hidden { $extra_args } else { [...$extra_args --hidden] }


  let extra_args = if $include_gen {
    $extra_args
  } else {
    [...$extra_args
       --glob '!zzz_generated'
       --glob '!src/darwin/Framework/CHIP/zap-generated'
       --glob '!src/controller/java/zap-generated'
       --glob '!src/controller/python/chip/clusters'
    ]
  }

  let extra_args = if $pipe {
     [...$extra_args --color never]
  } else {
     [...$extra_args --color always]
  }


  # Got all RG default args, so run the command
  let results = rg -n --hidden --no-ignore ...$extra_args ...$more_args | lines | split column --number 3 ':' path line match | update line {ansi strip | into int} | update path {ansi strip}

  let results = if $add_dir {
    $results | insert dir {$in.path | path dirname} | sort-by dir path
  } else {
    $results | sort-by path
  }

  $results
}
