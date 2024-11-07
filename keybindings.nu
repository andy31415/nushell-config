$env.config.keybindings ++= [
  {
    name: insert_file_name
    modifier: CONTROL
    keycode: char_f
    mode: [emacs vi_insert]
    event: [
      {
        send: executehostcommand,
        cmd: "sf | commandline edit -i $in"
      }
    ]
  }
  {
    name: insert_last_token
    modifier: alt
    keycode: char_.
    mode: [emacs, vi_insert]
    event: [
      { edit: InsertString, value: " !$" }
      { send: Enter }
    ]
  }
  {
    name: insert_last_token
    modifier: shift_control
    keycode: up
    mode: [emacs, vi_insert]
    event: [
      { edit: InsertString, value: " !$" }
      { send: Enter }
    ]
  }
  # Some extra keybindings from awesome-nu
  {
    name: fuzzy_history
    modifier: control
    keycode: char_h
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: executehostcommand
        cmd: "
            history
            | each { |it| $it.command }
            | uniq
            | reverse
            | input list --fuzzy $'Please choose a (ansi magenta)command from history(ansi reset):'
            | commandline edit -i $in"
    }
  }
]
