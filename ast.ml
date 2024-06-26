(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or | Union | Intersect

type uop = Neg | Not

type typ = Int | Bool | Float | Void | String | Strings

type bind = typ * string

type condition =
  | FileSizeCondition of int * expr
  | DateCondition of int * expr
  | RegxCondition of expr
and expr =
    Literal of int
  | Fliteral of string
  | BoolLit of bool
  | StringLit of string
  | Id of string
  | Binop of expr * op * expr
  | Unop of uop * expr
  | Assign of string * expr
  | Call of string * expr list
  | Query of expr * condition option
  | Grep of expr * expr
  | Check of expr
  | Save of expr * expr
  | Load of expr
  | Append of expr * expr
  | Count of expr
  | Init of string
  | Noexpr

type stmt =
    Block of stmt list
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | For of expr * expr * expr * stmt
  | While of expr * stmt

type func_decl = {
    mutable typ : typ;
    fname : string;
    formals : bind list;
    locals : bind list;
    body : stmt list;
  }

type program = bind list * func_decl list

(* Pretty-printing functions *)

let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> ">="
  | And -> "&&"
  | Or -> "||"
  | Union -> "$"
  | Intersect -> "@"

let string_of_uop = function
    Neg -> "-"
  | Not -> "!"

let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | Fliteral(l) -> l
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | StringLit(s) -> "\"" ^ String.escaped s ^ "\""
  | Id(s) -> s
  | Binop(e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Unop(o, e) -> string_of_uop o ^ string_of_expr e
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Query(e, cond_opt) -> 
    "SELECT * FROM " ^ string_of_expr e ^ (match cond_opt with 
                                            | None -> "" 
                                            | Some(cond) -> " WHERE " ^ string_of_condition cond)
  | Grep(e1, e2) -> 
    "GREP " ^ string_of_expr e1 ^ " FROM " ^ string_of_expr e2
  | Save(e1, e2) -> 
    "SAVE " ^ string_of_expr e1 ^ " TO " ^ string_of_expr e2
  | Load(e) -> 
    "LOAD " ^ string_of_expr e 
  | Init(s) -> "INIT " ^ s
  | Count(e) -> "COUNT " ^ string_of_expr e 
  | Check(e) -> "CHECK " ^ string_of_expr e
  | Append(e1, e2) -> string_of_expr e1 ^ "->" ^ string_of_expr e2
  | Noexpr -> ""

and string_of_condition = function
| FileSizeCondition(op, e) -> "SIZE " ^ string_of_comparison_op op ^ " " ^ string_of_expr e
| DateCondition(op, e) -> "DATE " ^ string_of_comparison_op op ^ " " ^ string_of_expr e
| RegxCondition(e) -> "LIKE " ^ string_of_expr e

and string_of_comparison_op = function
    0 -> "LESS THAN"
  | 1 -> "GREATER THAN"
  | 2 -> "EQUAL"
  | _ -> "UNKNOWN COMPARISON"

let rec string_of_stmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n";
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | If(e, s, Block([])) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
  | If(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | For(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ string_of_stmt s
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

let string_of_typ = function
    Int -> "int"
  | Bool -> "bool"
  | Float -> "float"
  | Void -> "void"
  | Strings -> "strings"
  | String -> "string"

let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  string_of_typ fdecl.typ ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_program (vars, funcs) =
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
