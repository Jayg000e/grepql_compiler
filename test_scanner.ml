let rec read_all_tokens lexbuf =
  match Scanner.token lexbuf with
  | Parse.EOF -> () (* End of input, stop the recursion *)
  | _ -> read_all_tokens lexbuf (* Read the next token *)

let _ =
  let lexbuf = Lexing.from_channel stdin in
  read_all_tokens lexbuf
