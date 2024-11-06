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
]
