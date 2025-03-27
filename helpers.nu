# Select a specific file using sk, reasonably fast
# Ignores third_party and out by default
#
# Use to pipe to future commands like git lg or vim
def sf [] {
  sk -c {fd -HI -E third_party -E out -E .git -E .cache .} --preview {bat --theme "Monokai Extended"  -f $in}
}

#
# List and parse all docker images
# with nice parsing/formatting for creation and filezise
#
# Ideas taken from nu_scripts:
#   https://github.com/nushell/nu_scripts/blob/main/modules/docker/mod.nu
def docker-images [] {
   let $images = docker images --format '{"id":"{{.ID}}", "repo": "{{.Repository}}", "tag":"{{.Tag}}", "size":"{{.Size}}" "created":"{{.CreatedAt}}"}' | lines 
   $images | each {$in | from json} | update created {$in | into datetime} | update size {$in | into filesize}
}

#
# List and parse all podman images
# with nice parsing/formatting for creation and filezise
#
# Ideas taken from nu_scripts:
#   https://github.com/nushell/nu_scripts/blob/main/modules/docker/mod.nu
def podman-images [] {
   let $images = podman images --format '{"id":"{{.ID}}", "repo": "{{.Repository}}", "tag":"{{.Tag}}", "size":"{{.Size}}" "created":"{{.CreatedAt}}"}' | lines 
   $images | each {$in | from json} | update created {$in | into datetime} | update size {$in | into filesize}
}

# Binary size difference between two paths
def bb --wrapped [
  input: path # the input file
  base: path # the baseline file
  ...args
] {
  # ~/devel/chip-scripts/bindiff.py --output csv ...$args $input $base | from csv
  ~/devel/connectedhomeip/scripts/tools/binary_elf_size_diff.py --output csv ...$args $input $base | from csv
}

# List the remote names from `git-branch -la`
# - Ordered by commit date
# - contains a nice explorable table (and filterable)
def git-remotes [] {
  let cols = ^git branch -la --sort=-committerdate --format='%(HEAD) %(refname)' 
  let cols = $cols | parse --regex '(?<HEAD> |\*) refs/(?<fullname>heads/(?<head_name>.*)|remotes/(?<remote>[^/]*)/(?<remote_name>.*))'
  let cols = $cols | update HEAD { $in == '*'} | rename current | insert name {$"($in.head_name)($in.remote_name)"} 
  $cols | reject fullname remote_name head_name
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

# PAHOLE wrapper with options for C++
def ph [
  --name: string = ''     # class name filter
  --holes: int = 0        # mimimum number of holes
  inputfile               # input file name
] {
  mut extra_args = [ --show_private_classes ]
  if $holes > 0 { $extra_args ++= [ --holes $holes ] }
  if $name != '' { $extra_args ++= [ --class_name $name ] }
  pahole ...$extra_args $inputfile | complete | get stdout
}

# Run PAHOLE on a file and show potential savings (just filters things
# that have size mand member sizes)
def pahole-quick [
  --name: string = ''     # class name filter
  inputfile # input file name
] {
  mut extra_args = [
    --show_private_classes
    --holes=1
  ]
  if $name != '' { $extra_args ++= [ --class_name $name ] }

  let output = pahole ...$extra_args $inputfile | complete | get stdout
  let filtered = $output | grep -E '^struct|^class|size:|sum members' | grep -B 2 'sum members' --no-group-separator
  let joined = $filtered | awk '/(?<type>struct|class).* {/ { C = $0 } /size: / {S = $0} /sum members/ {print C,S,$0}'
  let table = $joined | parse --regex '(struct|class) (?<name>[^ ]*).* size: (?<size>\d+).* sum members: (?<member_size>\d+).*'

  # fix types and add member size
  let table = $table | update size {|s| $s.size | into int} | update member_size {|s| $s.member_size | into int} | insert delta {|s| $s.size - $s.member_size}

  $table | sort-by delta | uniq
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
    --print-only    # print out what would be run
    ...more_args    # Arguments to pass to `rg` (i.e. ripgrep). Generally term and directory
] {
  # Basically NEVER want to see these:
  mut extra_args = [
     --no-binary
     --glob '!\.cache'
     --glob '!\.environment'
     --glob '!\.git'
     --glob '!\.ipynb_checkpoints'
     --glob '!\.mypy_cache'
     --glob '!\.pytest_cache'
     --glob '!\.ruff_cache'
  ]

  if not $no_ignore {
    $extra_args ++= [--glob '!third_party' --glob '!out']
  }

  if not $no_hidden {
    $extra_args ++= [--hidden]
  }

  if not $include_gen {
    $extra_args ++= [
       --glob '!zzz_generated'
       --glob '!src/darwin/Framework/CHIP/zap-generated'
       --glob '!src/controller/java/zap-generated'
       --glob '!src/controller/python/chip/clusters'
    ]
  }

  if $pipe {
     $extra_args ++= [--color never]
  } else {
     $extra_args ++= [--color always]
  }

  if $print_only {
    ^echo rg -n --hidden --no-ignore ...$extra_args ...$more_args
    return
  }

  # Got all RG default args, so run the command
  let results = rg -n --hidden --no-ignore ...$extra_args ...$more_args | lines | split column --number 3 ':' path line match | update line {ansi strip | try {into int} catch {-1}} | update path {ansi strip}

  let results = if $add_dir {
    $results | insert dir {$in.path | path dirname} | sort-by dir path
  } else {
    $results | sort-by path
  }

  $results
}
