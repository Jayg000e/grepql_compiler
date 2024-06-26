(* Semantically-checked Abstract Syntax Tree and functions for printing it *)

open Ast

type scondition = 
| SFileSizeCondition of int * sexpr
| SDateCondition of int * sexpr
| SRegxCondition of sexpr
and sexpr = typ * sx
and sx =
    SLiteral of int
  | SFliteral of string
  | SBoolLit of bool
  | SStringLit of string
  | SId of string
  | SBinop of sexpr * op * sexpr
  | SUnop of uop * sexpr
  | SAssign of string * sexpr
  | SCall of string * sexpr list
  | SInit of string
  | SCount of sexpr
  | SSave of sexpr * sexpr
  | SLoad of sexpr
  | SAppend of sexpr * sexpr
  | SCheck of sexpr
  | SQuery of sexpr * scondition option
  | SGrep of sexpr * sexpr
  | SNoexpr

type sstmt =
    SBlock of sstmt list
  | SExpr of sexpr
  | SReturn of sexpr
  | SIf of sexpr * sstmt * sstmt
  | SFor of sexpr * sexpr * sexpr * sstmt
  | SWhile of sexpr * sstmt

type sfunc_decl = {
    styp : typ;
    sfname : string;
    sformals : bind list;
    slocals : bind list;
    sbody : sstmt list;
  }

type sprogram = bind list * sfunc_decl list

(* Pretty-printing functions *)

let rec string_of_sexpr (t, e) =
  "(" ^ string_of_typ t ^ " : " ^ (match e with
    SLiteral(l) -> string_of_int l
  | SBoolLit(true) -> "true"
  | SBoolLit(false) -> "false"
  | SFliteral(l) -> l
  | SStringLit(s) -> "\"" ^ String.escaped s ^ "\""
  | SId(s) -> s
  | SInit(s) -> s
  | SBinop(e1, o, e2) ->
      string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
  | SUnop(o, e) -> string_of_uop o ^ string_of_sexpr e
  | SAssign(v, e) -> v ^ " = " ^ string_of_sexpr e
  | SCall(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_sexpr el) ^ ")"
  | SNoexpr -> ""			 
  | SCount(e) -> "COUNT " ^ string_of_sexpr e 
  | SSave(e1, e2) -> "SAVE " ^ string_of_sexpr e1 ^ " TO " ^ string_of_sexpr e2 
  | SLoad(e) -> "LOAD " ^ string_of_sexpr e
  | SAppend(e1, e2) -> string_of_sexpr e1 ^ "->" ^ string_of_sexpr e2
  | SCheck(e) -> "CHECK " ^ string_of_sexpr e 
  | SGrep(e1, e2) -> 
    "GREP " ^ string_of_sexpr e1 ^ " FROM " ^ string_of_sexpr e2
  | SQuery(e, None) -> "SELECT * FROM " ^ string_of_sexpr e
  | SQuery(e, Some(cond)) -> 
      "SELECT * FROM " ^ string_of_sexpr e ^ " WHERE " ^ string_of_scondition cond ^ ")"
      ) ^ ")"	
and string_of_scondition = function
  | SFileSizeCondition(op, e) -> "SIZE " ^ string_of_comparison_op op ^ " " ^ string_of_sexpr e
  | SDateCondition(op, e) -> "DATE " ^ string_of_comparison_op op ^ " " ^ string_of_sexpr e
  | SRegxCondition(e) -> "LIKE " ^ string_of_sexpr e


let rec string_of_sstmt = function
    SBlock(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_sstmt stmts) ^ "}\n"
  | SExpr(expr) -> string_of_sexpr expr ^ ";\n";
  | SReturn(expr) -> "return " ^ string_of_sexpr expr ^ ";\n";
  | SIf(e, s, SBlock([])) ->
      "if (" ^ string_of_sexpr e ^ ")\n" ^ string_of_sstmt s
  | SIf(e, s1, s2) ->  "if (" ^ string_of_sexpr e ^ ")\n" ^
      string_of_sstmt s1 ^ "else\n" ^ string_of_sstmt s2
  | SFor(e1, e2, e3, s) ->
      "for (" ^ string_of_sexpr e1  ^ " ; " ^ string_of_sexpr e2 ^ " ; " ^
      string_of_sexpr e3  ^ ") " ^ string_of_sstmt s
  | SWhile(e, s) -> "while (" ^ string_of_sexpr e ^ ") " ^ string_of_sstmt s

let string_of_sfdecl fdecl =
  string_of_typ fdecl.styp ^ " " ^
  fdecl.sfname ^ "(" ^ String.concat ", " (List.map snd fdecl.sformals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.slocals) ^
  String.concat "" (List.map string_of_sstmt fdecl.sbody) ^
  "}\n"

let string_of_sprogram (vars, funcs) =
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_sfdecl funcs)
