open Ast

(* let _ =
  let lexbuf = Lexing.from_channel stdin in
  let command = Parser.command Scanner.token lexbuf in
  print_endline (string_of_command command) *)

let rec read_all_tokens lexbuf =
  match Scanner.token lexbuf with
  | EOF -> () (* End of input, stop the recursion *)
  | _ -> read_all_tokens lexbuf (* Read the next token *)

let _ =
  let lexbuf = Lexing.from_channel stdin in
  read_all_tokens lexbuf
