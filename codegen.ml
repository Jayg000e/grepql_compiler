(* Code generation: translate takes a semantically checked AST and
produces LLVM IR

LLVM tutorial: Make sure to read the OCaml version of the tutorial

http://llvm.org/docs/tutorial/index.html

Detailed documentation on the OCaml LLVM library:

http://llvm.moe/
http://llvm.moe/ocaml/

*)

module L = Llvm
module A = Ast
open Sast 

module StringMap = Map.Make(String)

(* translate : Sast.program -> Llvm.module *)
let translate (globals, functions) =
  let context    = L.global_context () in
  
  (* Create the LLVM compilation module into which
     we will generate code *)
  let the_module = L.create_module context "MicroC" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and i8_t       = L.i8_type     context
  and i1_t       = L.i1_type     context
  and float_t    = L.double_type context
  and void_t     = L.void_type   context in
  let i8_ptr_t   = L.pointer_type i8_t in
  let i8_ptr_ptr_t   = L.pointer_type i8_ptr_t in

  (* Defining the struct in LLVM to match the C structure, including the enum as i32 *)
  let strings_t = L.struct_type context  [| i8_ptr_ptr_t; i32_t; i32_t|] in
  let strings_ptr_t = L.pointer_type strings_t in 

  (* Return the LLVM type for a MicroC type *)
  let ltype_of_typ = function
      A.Int   -> i32_t
    | A.Bool  -> i1_t
    | A.Float -> float_t
    | A.Void  -> void_t
    | A.String -> i8_ptr_t
    | A.Strings -> strings_ptr_t
  in

  (* Create a map of global variables after creating each *)
  let global_vars : L.llvalue StringMap.t =
    let global_var m (t, n) = 
      let init = match t with
          A.Float -> L.const_float (ltype_of_typ t) 0.0
        | A.String -> L.const_null (ltype_of_typ t)
        | _ -> L.const_int (ltype_of_typ t) 0
      in StringMap.add n (L.define_global n init the_module) m in
    List.fold_left global_var StringMap.empty globals in

  let printf_t : L.lltype = 
      L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue = 
      L.declare_function "printf" printf_t the_module in
  
  let concat_t : L.lltype = 
      L.function_type i8_ptr_t [|i8_ptr_t; i8_ptr_t|] in
  let concat_func : L.llvalue = 
      L.declare_function "concat" concat_t the_module in

  let newStrings_t : L.lltype = 
      L.function_type strings_ptr_t [||] in
  let newStrings_func : L.llvalue = 
      L.declare_function "newStrings" newStrings_t the_module in
  
  let append_t : L.lltype =
      L.function_type i32_t [| strings_ptr_t; i8_ptr_t|] in
  let append_func : L.llvalue =
      L.declare_function "append" append_t the_module in
  
  let size_t : L.lltype =
      L.function_type i32_t [| strings_ptr_t |] in
  let size_func : L.llvalue =
      L.declare_function "size" size_t the_module in

  let show_t : L.lltype =
      L.function_type i32_t [| strings_ptr_t |] in
  let show_func : L.llvalue =
      L.declare_function "show" show_t the_module in

  let query_t : L.lltype =
      L.function_type strings_ptr_t [| i8_ptr_t; i32_t; i32_t; i32_t; i8_ptr_t; i8_ptr_t|] in
  let query_func : L.llvalue =
      L.declare_function "query" query_t the_module in

  let grep_t : L.lltype =
        L.function_type strings_ptr_t [| i8_ptr_t; i8_ptr_t|] in
  let grep_func : L.llvalue =
      L.declare_function "searchPath" grep_t the_module in
  
  let union_t : L.lltype =
        L.function_type strings_ptr_t [| strings_ptr_t; strings_ptr_t|] in
  let union_func : L.llvalue =
      L.declare_function "unionStrings" union_t the_module in
  
  let intersect_t : L.lltype =
        L.function_type strings_ptr_t [| strings_ptr_t; strings_ptr_t|] in
  let intersect_func : L.llvalue =
      L.declare_function "intersectStrings" intersect_t the_module in
  
  let save_t : L.lltype =
        L.function_type i32_t [| strings_ptr_t; i8_ptr_t|] in
  let save_func : L.llvalue =
        L.declare_function "writeStrings" save_t the_module in

  let load_t : L.lltype =
    L.function_type strings_ptr_t [|i8_ptr_t|] in
  let load_func : L.llvalue =
        L.declare_function "readStrings" load_t the_module in

  (* Define each function (arguments and return type) so we can 
     call it even before we've created its body *)
  let function_decls : (L.llvalue * sfunc_decl) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and formal_types = 
	Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sformals)
      in let ftype = L.function_type (ltype_of_typ fdecl.styp) formal_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in
  
  (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.sfname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in

    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder
    and float_format_str = L.build_global_stringptr "%g\n" "fmt" builder 
    and string_format_str = L.build_global_stringptr "%s\n" "fmt" builder
  
  in

    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
      let add_formal m (t, n) p = 
        L.set_value_name n p;
	let local = L.build_alloca (ltype_of_typ t) n builder in
        ignore (L.build_store p local builder);
	StringMap.add n local m 

      (* Allocate space for any locally declared variables and add the
       * resulting registers to our map *)
      and add_local m (t, n) =
	let local_var = L.build_alloca (ltype_of_typ t) n builder
	in StringMap.add n local_var m 
      in

      let formals = List.fold_left2 add_formal StringMap.empty fdecl.sformals
          (Array.to_list (L.params the_function)) in
      List.fold_left add_local formals fdecl.slocals 
    in

    (* Return the value for a variable or formal argument.
       Check local names first, then global names *)
    let lookup n = try StringMap.find n local_vars
                   with Not_found -> StringMap.find n global_vars
    in

    (* Construct code for an expression; return its value *)
    let rec expr builder ((_, e) : sexpr) = match e with
	SLiteral i  -> L.const_int i32_t i
      | SBoolLit b  -> L.const_int i1_t (if b then 1 else 0)
      | SFliteral l -> L.const_float_of_string float_t l
      | SStringLit s -> L.build_global_stringptr s "tmp" builder
      | SNoexpr     -> L.const_int i32_t 0
      | SId s       -> L.build_load (lookup s) s builder
      | SAssign (s, e) -> let e' = expr builder e in
                          ignore(L.build_store e' (lookup s) builder); e'
      | SInit(s) -> let e' = L.build_call newStrings_func [||] "newStrings" builder in
                ignore(L.build_store e' (lookup s) builder); e'
      | SBinop ((A.Float,_ ) as e1, op, e2) ->
	  let e1' = expr builder e1
	  and e2' = expr builder e2 in
	  (match op with 
	    A.Add     -> L.build_fadd
	  | A.Sub     -> L.build_fsub
	  | A.Mult    -> L.build_fmul
	  | A.Div     -> L.build_fdiv 
	  | A.Equal   -> L.build_fcmp L.Fcmp.Oeq
	  | A.Neq     -> L.build_fcmp L.Fcmp.One
	  | A.Less    -> L.build_fcmp L.Fcmp.Olt
	  | A.Leq     -> L.build_fcmp L.Fcmp.Ole
	  | A.Greater -> L.build_fcmp L.Fcmp.Ogt
	  | A.Geq     -> L.build_fcmp L.Fcmp.Oge
	  | A.And | A.Or | A.Union | A.Intersect ->
	      raise (Failure "internal error: semant should have rejected and/or/union/intersect on float")
	  ) e1' e2' "tmp" builder
      | SBinop (e1, op, e2) ->
	  let e1' = expr builder e1
	  and e2' = expr builder e2 in
	  (match op with
	    A.Add     -> L.build_add e1' e2' "tmp" builder
	  | A.Sub     -> L.build_sub e1' e2' "tmp" builder
	  | A.Mult    -> L.build_mul e1' e2' "tmp" builder
    | A.Div     -> L.build_sdiv e1' e2' "tmp" builder
	  | A.And     -> L.build_and e1' e2' "tmp" builder
	  | A.Or      -> L.build_or e1' e2' "tmp" builder
	  | A.Equal   -> L.build_icmp L.Icmp.Eq e1' e2' "tmp" builder
	  | A.Neq     -> L.build_icmp L.Icmp.Ne e1' e2' "tmp" builder
	  | A.Less    -> L.build_icmp L.Icmp.Slt e1' e2' "tmp" builder
	  | A.Leq     -> L.build_icmp L.Icmp.Sle e1' e2' "tmp" builder
	  | A.Greater -> L.build_icmp L.Icmp.Sgt e1' e2' "tmp" builder
	  | A.Geq     -> L.build_icmp L.Icmp.Sge e1' e2' "tmp" builder
    | A.Union   -> L.build_call union_func [| e1'; e2' |] "tmp" builder
    | A.Intersect  -> L.build_call intersect_func [| e1'; e2'|] "tmp" builder
	  ) 
      | SUnop(op, ((t, _) as e)) ->
          let e' = expr builder e in
	  (match op with
	    A.Neg when t = A.Float -> L.build_fneg 
	  | A.Neg                  -> L.build_neg
          | A.Not                  -> L.build_not) e' "tmp" builder
      | SCall ("print", [e]) | SCall ("printb", [e]) ->
	  L.build_call printf_func [| int_format_str ; (expr builder e) |]
	    "printf" builder
      | SCall ("concat", [e1; e2]) ->
    L.build_call concat_func [| (expr builder e1); (expr builder e2)|] "concat" builder
    | SCall ("newStrings", []) ->
      L.build_call newStrings_func [||] "newStrings" builder
    | SCall ("show", [e]) ->
        L.build_call show_func [| (expr builder e)|] "show" builder
    | SCall ("append", [e1;e2]) ->
          L.build_call append_func [| (expr builder e1);(expr builder e2)|] "append" builder
    | SCall ("size", [e]) ->
          L.build_call size_func [| (expr builder e)|] "size" builder
    
      | SCall ("printf", [e]) -> 
	  L.build_call printf_func [| float_format_str ; (expr builder e) |]
	    "printf" builder
      | SCall ("prints", [e]) ->
        L.build_call printf_func [| string_format_str ; (expr builder e) |]
          "printf" builder
      | SCall (f, args) ->
         let (fdef, fdecl) = StringMap.find f function_decls in
	 let llargs = List.rev (List.map (expr builder) (List.rev args)) in
	 let result = (match fdecl.styp with 
                        A.Void -> ""
                      | _ -> f ^ "_result") in
         L.build_call fdef (Array.of_list llargs) result builder
      | SCount(e) -> L.build_call size_func [|expr builder e|] "size" builder
      | SSave (e1, e2) -> L.build_call save_func [|(expr builder e1); (expr builder e2)|] "save" builder
      | SLoad (e) -> L.build_call load_func [|expr builder e|] "load" builder
      | SAppend (e1, e2) -> L.build_call append_func [|(expr builder e2); (expr builder e1)|] "append" builder
      | SCheck (e) -> 
        L.build_call show_func [|expr builder e|] "check" builder
      | SGrep (e1, e2) -> 
        L.build_call grep_func [| (expr builder e1); (expr builder e2)|] "grep" builder
      | SQuery (e, scond) -> 
        match scond with 
          None -> 
            let e_val = expr builder e in 
            let condition_type_val = L.const_int i32_t 0 in 
            let op_type_val = L.const_int i32_t 0 in 
            let size_condition_val = L.const_int i32_t 0 in 
            let date_condition_val = L.const_pointer_null i8_ptr_t in 
            let reg_condition_val = L.const_pointer_null i8_ptr_t in 
            L.build_call query_func [| e_val; condition_type_val; op_type_val; size_condition_val; date_condition_val; reg_condition_val|] "query" builder
        | Some(SFileSizeCondition(op, e')) ->
            let e_val = expr builder e in 
            let condition_type_val = L.const_int i32_t 1 in 
            let op_type_val = L.const_int i32_t op in 
            let size_condition_val = (expr builder e') in 
            let date_condition_val = L.const_pointer_null i8_ptr_t in 
            let reg_condition_val = L.const_pointer_null i8_ptr_t in 
            L.build_call query_func [| e_val; condition_type_val; op_type_val; size_condition_val; date_condition_val; reg_condition_val|] "query" builder
        | Some(SDateCondition(op, e')) ->
          let e_val = expr builder e in 
          let condition_type_val = L.const_int i32_t 2 in 
          let op_type_val = L.const_int i32_t op in 
          let size_condition_val = L.const_int i32_t 0 in 
          let date_condition_val = (expr builder e') in 
          let reg_condition_val = L.const_pointer_null i8_ptr_t in 
          L.build_call query_func [| e_val; condition_type_val; op_type_val; size_condition_val; date_condition_val; reg_condition_val|] "query" builder
        | Some(SRegxCondition(e')) ->
            let e_val = expr builder e in 
            let condition_type_val = L.const_int i32_t 0 in 
            let op_type_val = L.const_int i32_t 0 in 
            let size_condition_val = L.const_int i32_t 0 in 
            let date_condition_val =  L.const_pointer_null i8_ptr_t in 
            let reg_condition_val = (expr builder e') in 
            L.build_call query_func [| e_val; condition_type_val; op_type_val; size_condition_val; date_condition_val; reg_condition_val|] "query" builder
    in
    
    (* LLVM insists each basic block end with exactly one "terminator" 
       instruction that transfers control.  This function runs "instr builder"
       if the current block does not already have a terminator.  Used,
       e.g., to handle the "fall off the end of the function" case. *)
    let add_terminal builder instr =
      match L.block_terminator (L.insertion_block builder) with
	Some _ -> ()
      | None -> ignore (instr builder) in
	
    (* Build the code for the given statement; return the builder for
       the statement's successor (i.e., the next instruction will be built
       after the one generated by this call) *)

    let rec stmt builder = function
	SBlock sl -> List.fold_left stmt builder sl
      | SExpr e -> ignore(expr builder e); builder 
      | SReturn e -> ignore(match fdecl.styp with
                              (* Special "return nothing" instr *)
                              A.Void -> L.build_ret_void builder 
                              (* Build return statement *)
                            | _ -> L.build_ret (expr builder e) builder );
                     builder
      | SIf (predicate, then_stmt, else_stmt) ->
         let bool_val = expr builder predicate in
	 let merge_bb = L.append_block context "merge" the_function in
         let build_br_merge = L.build_br merge_bb in (* partial function *)

	 let then_bb = L.append_block context "then" the_function in
	 add_terminal (stmt (L.builder_at_end context then_bb) then_stmt)
	   build_br_merge;

	 let else_bb = L.append_block context "else" the_function in
	 add_terminal (stmt (L.builder_at_end context else_bb) else_stmt)
	   build_br_merge;

	 ignore(L.build_cond_br bool_val then_bb else_bb builder);
	 L.builder_at_end context merge_bb

      | SWhile (predicate, body) ->
	  let pred_bb = L.append_block context "while" the_function in
	  ignore(L.build_br pred_bb builder);

	  let body_bb = L.append_block context "while_body" the_function in
	  add_terminal (stmt (L.builder_at_end context body_bb) body)
	    (L.build_br pred_bb);

	  let pred_builder = L.builder_at_end context pred_bb in
	  let bool_val = expr pred_builder predicate in

	  let merge_bb = L.append_block context "merge" the_function in
	  ignore(L.build_cond_br bool_val body_bb merge_bb pred_builder);
	  L.builder_at_end context merge_bb

      (* Implement for loops as while loops *)
      | SFor (e1, e2, e3, body) -> stmt builder
	    ( SBlock [SExpr e1 ; SWhile (e2, SBlock [body ; SExpr e3]) ] )
    in

    (* Build the code for each statement in the function *)
    let builder = stmt builder (SBlock fdecl.sbody) in

    (* Add a return if the last block falls off the end *)
    add_terminal builder (match fdecl.styp with
        A.Void -> L.build_ret_void
      | A.Float -> L.build_ret (L.const_float float_t 0.0)
      | t -> L.build_ret (L.const_int (ltype_of_typ t) 0))
  in

  List.iter build_function_body functions;
  the_module