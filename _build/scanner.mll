{
  open Microcparse

  let print_token token =
    print_endline (match token with
      | LPAREN -> "LPAREN"
      | RPAREN -> "RPAREN"
      | LBRACE -> "LBRACE"
      | RBRACE -> "RBRACE"
      | SEMI -> "SEMI"
      | COMMA -> "COMMA"
      | PLUS -> "PLUS"
      | MINUS -> "MINUS"
      | TIMES -> "TIMES"
      | DIVIDE -> "DIVIDE"
      | ASSIGN -> "ASSIGN"
      | EQ -> "EQ"
      | NEQ -> "NEQ"
      | LT -> "LT"
      | LEQ -> "LEQ"
      | GT -> "GT"
      | GEQ -> "GEQ"
      | AND -> "AND"
      | OR -> "OR"
      | NOT -> "NOT"
      | IF -> "IF"
      | ELSE -> "ELSE"
      | FOR -> "FOR"
      | WHILE -> "WHILE"
      | RETURN -> "RETURN"
      | INT -> "INT"
      | BOOL -> "BOOL"
      | FLOAT -> "FLOAT"
      | VOID -> "VOID"
      | STRING -> "STRING"
      | BLIT(b) -> "BLIT(" ^ string_of_bool b ^ ")"
      | LITERAL(l) -> "LITERAL(" ^ string_of_int l ^ ")"
      | FLIT(l) -> "FLIT(" ^ l ^ ")"
      | ID(id) -> "ID(" ^ id ^ ")"
      | STRLIT(s) -> "STRLIT(" ^ s ^ ")"
      | EOF -> "EOF"
      | _ -> "Other"
    );
    token
}

let digit = ['0' - '9']
let digits = digit+
let string_char = [^ '\"']

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
| '('      { print_token LPAREN }
| ')'      { print_token RPAREN }
| '{'      { print_token LBRACE }
| '}'      { print_token RBRACE }
| ';'      { print_token SEMI }
| ','      { print_token COMMA }
| '+'      { print_token PLUS }
| '-'      { print_token MINUS }
| '*'      { print_token TIMES }
| '/'      { print_token DIVIDE }
| '='      { print_token ASSIGN }
| "=="     { print_token EQ }
| "!="     { print_token NEQ }
| '<'      { print_token LT }
| "<="     { print_token LEQ }
| '>'      { print_token GT }
| ">="     { print_token GEQ }
| "&&"     { print_token AND }
| "||"     { print_token OR }
| "!"      { print_token NOT }
| "if"     { print_token IF }
| "else"   { print_token ELSE }
| "for"    { print_token FOR }
| "while"  { print_token WHILE }
| "return" { print_token RETURN }
| "int"    { print_token INT }
| "bool"   { print_token BOOL }
| "float"  { print_token FLOAT }
| "void"   { print_token VOID }
| "string" { print_token STRING }
| "true"   { print_token (BLIT(true))  }
| "false"  { print_token (BLIT(false)) }
| digits as lxm { print_token (LITERAL(int_of_string lxm)) }
| digits '.'  digit* ( ['e' 'E'] ['+' '-']? digits )? as lxm { print_token (FLIT(lxm)) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']*     as lxm { print_token (ID(lxm)) }
| "\"" (string_char* as str) "\"" { print_token (STRLIT(str)) }  (* Handle string literals without escape sequences *)
| eof { print_token EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }