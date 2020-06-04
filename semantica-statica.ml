(* Laboratorio 4 maggio 2020: specifica della semantica statica del linguaggio *)

type var_id = Name of string;;

type season = Winter | Spring | Summer | Fall;; (* nuovo tipo di valori primitivi *)

(* AST of expressions *)
type exp = Lth of exp*exp | NumOf of exp | SeasonOf of exp | Season of season  (* espressioni nuove *)
         | Add of exp*exp | Mul of exp*exp | And of exp*exp | Eq of exp*exp | Pair of exp*exp | Fst of exp | Snd of exp | Sign of exp | Not of exp | Num of int | Bool of bool | Var of var_id;;


(* AST of statements and sequence of statements, mutually recursive *)
type
  stmt = For of var_id*exp*stmt_seq (* statement nuovo *)
       | Assign of var_id*exp | Dec of var_id*exp | Print of exp | If of exp*stmt_seq | IfElse of exp*stmt_seq*stmt_seq
and
  stmt_seq = SingleStmt of stmt | MoreStmt of stmt * stmt_seq;;

(* AST of programs *)
type prog = Prog of stmt_seq;;

(* environments *)

exception UndeclaredVariable of var_id;;

exception AlreadyDeclaredVariable of var_id;;

(* type constants and constructors *)

type static_type = Season (* nuovo tipo primitivo *) 
                 | Int | Bool | Prod of static_type*static_type;;

type scope = (var_id * static_type) list;;
type static_env = scope list;;

let empty_scope:scope = [];; 

let starting_env:static_env = [empty_scope];; (* just the empty top-level scope *)

(* enter_scope : static_env -> static_env *)

let enter_scope : static_env -> static_env = fun env -> empty_scope::env;; (* enters a new nested scope *)

(* variable lookup *)

(* resolve : var_id -> static_env -> scope *)
(* uses List.mem_assoc 
   examples:
   List.mem_assoc (Name "x") [(Name "x",Int);(Name "y",Bool)]=true;;
   List.mem_assoc (Name "y") [(Name "x",Int);(Name "y",Bool)]=true;;
   List.mem_assoc (Name "z") [(Name "x",Int);(Name "y",Bool)]=false;;
*)


let rec resolve : var_id -> static_env -> scope = fun id -> function
    scope::(env:static_env) -> if(List.mem_assoc id scope) then scope else resolve id env
  | [] -> raise (UndeclaredVariable id);;

(* lookup : var_id -> static_env -> static_type *)
(* uses List.assoc 
   examples:
   List.assoc (Name "x") [(Name "x",Int);(Name "y",Bool)]=Int;;
   List.assoc (Name "y") [(Name "x",Int);(Name "y",Bool)]=Bool;;
   List.assoc (Name "z") [(Name "x",Int);(Name "y",Bool)];; raises exception Not_found
*)

let lookup var_id env = List.assoc var_id (resolve var_id env);;

(* variable declaration *)

(* dec : var_id -> static_type -> static_env -> static_env *)

let dec : var_id -> static_type -> static_env -> static_env = fun id ty -> function
    scope::env -> if(List.mem_assoc id scope) then raise (AlreadyDeclaredVariable id) else ((id,ty)::scope)::env
  | [] -> failwith "assertion error";; (* should never happen *)


(* static semantics *)

(* static errors *)

exception ExpectingTypeError of static_type;;

exception ExpectingPairError of unit;;  

(* wfExp : wfExp : static_env -> exp -> static_type *)

let rec wfExp env=function 
  (* espressioni nuove *)
    Lth(exp1,exp2) -> let type1=wfExp env exp1 in if wfExp env exp2=type1 then Bool else raise (ExpectingTypeError type1)
  | NumOf exp -> if wfExp env exp = Season then Int else raise (ExpectingTypeError Season)
  | SeasonOf exp -> if wfExp env exp = Int then Season else raise (ExpectingTypeError Int)
  | Season _ -> Season
  (* espressioni linguaggio labo *)
  | Add(exp1,exp2) | Mul(exp1,exp2) -> if wfExp env exp1=Int && wfExp env exp2=Int then Int else raise (ExpectingTypeError Int)
  | And(exp1,exp2) -> if wfExp env exp1=Bool && wfExp env exp2=Bool then Bool else raise (ExpectingTypeError Bool)
  | Eq(exp1,exp2) -> let type1=wfExp env exp1 in if wfExp env exp2=type1 then Bool else raise (ExpectingTypeError type1)
  | Pair(exp1,exp2) -> let type1=wfExp env exp1 and type2=wfExp env exp2 in Prod(type1,type2)
  | Fst exp -> (match wfExp env exp with Prod(type1,_) -> type1 | _ -> raise (ExpectingPairError ()))
  | Snd exp -> (match wfExp env exp with Prod(_,type2) -> type2 | _ -> raise (ExpectingPairError()))
  | Sign exp -> if wfExp env exp=Int then Int else raise (ExpectingTypeError Int)
  | Not exp -> if wfExp env exp=Bool then Bool else raise (ExpectingTypeError Bool)
  | Num _ -> Int
  | Bool _ -> Bool
  | Var id -> lookup id env;;

(* mutually recursive
   wfStmt : static_env -> stmt -> static_env
   wfStmtSeq : static_env -> stmt_seq -> static_env
*)

let rec wfStmt env=function
    For(var_id,exp,stmt_seq) -> if lookup var_id env=Int && wfExp env exp=Int then let env2=enter_scope env in let _= wfStmtSeq env2 stmt_seq in env else raise (ExpectingTypeError Int)
  | Assign(var_id,exp) -> let type1=lookup var_id env in 
        if wfExp env exp=type1 then env else raise (ExpectingTypeError type1)
  | Dec(id,exp) -> dec id (wfExp env exp) env
  | Print exp -> let _=wfExp env exp in env
  | If(exp,stmt_seq) ->
      if wfExp env exp=Bool then 
        let env2=enter_scope env in 
        let _=wfStmtSeq env2 stmt_seq in env 
      else raise (ExpectingTypeError Bool)
  | IfElse(exp,stmt_seq1,stmt_seq2) -> 
      if wfExp env exp=Bool then 
        let env2=enter_scope env in 
        let _=wfStmtSeq env2 stmt_seq1 and _=wfStmtSeq env2 stmt_seq2 in env 
      else raise (ExpectingTypeError Bool)

and 

  wfStmtSeq env=function 
    SingleStmt stmt -> wfStmt env stmt
  | MoreStmt(stmt,stmt_seq) -> wfStmtSeq (wfStmt env stmt) stmt_seq;;

(* wfProg : prog -> unit *)

let wfProg = function Prog stmt_seq -> let _=wfStmtSeq starting_env stmt_seq in ();;

(* some simple tests with the static semantics *)

let stmt1=Dec(Name "x",Num 0);;

let stmt2=Assign(Name "x",Add(Var(Name "x"),Num 1));;

let stmt3=Print(Var(Name "x"));;

let prog1=Prog(MoreStmt(stmt1,(MoreStmt(stmt2,SingleStmt stmt3))));;

wfProg prog1;;

let stmt1=Dec(Name "x",Pair(Num 0,Bool false));;

let stmt2=Print(Add(Fst(Var(Name "x")),Num 1));;

let stmt3=Print(And(Snd(Var(Name "x")),Bool true));;

let stmt4 = Assign(Name "x",Pair(Num 1,Bool true));;

let prog2=Prog(MoreStmt(stmt1,(MoreStmt(stmt2,MoreStmt(stmt3,SingleStmt stmt4)))));;

wfProg prog2;;

let stmt1=Dec(Name "x",Num 0);;

let stmt2=If(Eq(Var(Name "x"),Num 0),MoreStmt(Dec(Name "x",Bool false),SingleStmt(Print(And(Var(Name "x"),Bool true)))));;

let stmt3=Assign(Name "x",Num 2);;

let prog3=Prog(MoreStmt(stmt1,(MoreStmt(stmt2,SingleStmt stmt3))));;

wfProg prog3;;

let stmt1=Dec(Name "x",Num 0);;

let stmt2=For(Name "x",Num 9,SingleStmt(Print(Var(Name "x"))));;

let prog4=Prog(MoreStmt(stmt1,(SingleStmt stmt2)));;

wfProg prog4;;

let stmt1=Dec(Name "s",Num 0);;

let stmt2=For(Name "s",Num 3,SingleStmt(Print(SeasonOf(Var(Name "s")))));;

let prog5=Prog(MoreStmt(stmt1,(SingleStmt stmt2)));;

wfProg prog5;;

