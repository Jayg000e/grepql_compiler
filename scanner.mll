{
  open Parse
  let print_token_verbose token =
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
      | UNION -> "UNION"
      | INTERSECT -> "INTERSECT"
      | EQ -> "EQ"
      | NEQ -> "NEQ"
      | LT -> "LT"
      | LEQ -> "LEQ"
      | GT -> "GT"
      | GEQ -> "GEQ"
      | AND -> "AND"
      | OR -> "OR"
      | NOT -> "NOT"
      | SELECT -> "SELECT"
      | GREP -> "GREP"
      | FROM -> "FROM"
      | WHERE -> "WHERE"
      | DATE -> "DATE"
      | SIZE -> "SIZE"
      | GREATER -> "GREATER"
      | LESS -> "LESS"
      | EQUAL -> "EQUAL"
      | LIKE -> "LIKE"
      | THAN -> "THAN"
      | IF -> "IF"
      | ELSE -> "ELSE"
      | FOR -> "FOR"
      | WHILE -> "WHILE"
      | RETURN -> "RETURN"
      | INT -> "INT"
      | BOOL -> "BOOL"
      | FLOAT -> "FLOAT"
      | VOID -> "VOID"
      | STRINGS -> "STRINGS"
      | STRING -> "STRING"
      | BLIT(b) -> "BLIT(" ^ string_of_bool b ^ ")"
      | LITERAL(l) -> "LITERAL(" ^ string_of_int l ^ ")"
      | FLIT(l) -> "FLIT(" ^ l ^ ")"
      | ID(id) -> "ID(" ^ id ^ ")"
      | STRLIT(s) -> "STRLIT(" ^ s ^ ")"
      | EOF -> "EOF"
    );
    token 
  let print_token_quiet token = token 
  (* Use print_token_verbose when testing scanner. Make sure it is quiet before running make compiler*)
  let print_token = print_token_quiet
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
| '$'      { print_token UNION }
| '@'      { print_token INTERSECT}
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
| "SELECT" { print_token SELECT}
| "GREP" { print_token GREP}
| "FROM"   { print_token FROM}
| "WHERE" { print_token WHERE}
| "DATE"   { print_token DATE}
| "SIZE"    { print_token SIZE}
| "GREATER"   { print_token GREATER}
| "LESS"   { print_token LESS}
| "EQUAL"   { print_token EQUAL}
| "LIKE"   { print_token LIKE}
| "THAN"    {print_token THAN}
| "if"     { print_token IF }
| "else"   { print_token ELSE }
| "for"    { print_token FOR }
| "while"  { print_token WHILE }
| "return" { print_token RETURN }
| "int"    { print_token INT }
| "bool"   { print_token BOOL }
| "float"  { print_token FLOAT }
| "void"   { print_token VOID }
| "strings" { print_token STRINGS }
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
