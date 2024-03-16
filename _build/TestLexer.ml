{
  open Scanner  
}

let _ =
  let lexbuf = Lexing.from_channel stdin in
  while true do
    let token = Scanner.token lexbuf in
    if token = Scanner.EOF then exit 0
  done
