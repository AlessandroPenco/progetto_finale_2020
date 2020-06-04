(* Laboratorio 11 maggio 2020: specifica della semantica statica del linguaggio *)

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

type value = Season of season (* nuovo valore primitivo *)
           | Int of int | Bool of bool | Pair of value*value;;

type scope = (var_id * value) list;;
type dynamic_env = scope list;;

let empty_scope:scope = [];; 

let starting_env:dynamic_env = [empty_scope];; (* just the empty top-level scope *)

(* enter_scope : dynamic_env -> dynamic_env *)

let enter_scope : dynamic_env -> dynamic_env = fun env -> empty_scope::env;; (* enters a new nested scope *)

(* exit_scope : dynamic_env -> dynamic_env *)
(* removes the innermost scope, only needed for the dynamic semantics *)

let exit_scope = function 
    _::env -> env
  | [] -> failwith "assertion error";; (* should never happen *)

(* variable lookup *)

(* resolve : var_id -> dynamic_env -> scope *)
(* uses List.mem_assoc 
   examples:
   List.mem_assoc (Name "x") [(Name "x",Int 3);(Name "y",Bool false)]=true;;
   List.mem_assoc (Name "y") [(Name "x",Int 3);(Name "y",Bool false)]=true;;
   List.mem_assoc (Name "z") [(Name "x",Int 3);(Name "y",Bool false)]=false;;
*)

let rec resolve : var_id -> dynamic_env -> scope = fun id -> function
    scope::(env:dynamic_env) -> if(List.mem_assoc id scope) then scope else resolve id env
  | [] -> raise (UndeclaredVariable id);;

(* lookup : var_id -> dynamic_env -> value *)
(* uses List.assoc 
   examples:
   List.assoc (Name "x") [(Name "x",Int 3);(Name "y",Bool false)]=Int 3;;
   List.assoc (Name "y") [(Name "x",Int 3);(Name "y",Bool false)]=Bool false;;
   List.assoc (Name "z") [(Name "x",Int 3);(Name "y",Bool false)];; raises exception Not_found
*)

let lookup var_id env = List.assoc var_id (resolve var_id env);;

(* variable declaration *)

(* dec : var_id -> value -> dynamic_env -> dynamic_env *)

let dec : var_id -> value -> dynamic_env -> dynamic_env = fun id vl -> function
    scope::env -> if(List.mem_assoc id scope) then raise (AlreadyDeclaredVariable id) else ((id,vl)::scope)::env
  | [] -> failwith "assertion error";; (* should never happen *)

(* variable update, only needed for the dynamic semantics *)

(* update : var_id -> value -> dynamic_env -> dynamic_env *)

let rec update : var_id -> value -> dynamic_env -> dynamic_env = fun id vl -> function
    scope::env -> if(List.mem_assoc id scope) then ((id,vl)::scope)::env else scope::update id vl env
  | [] -> raise (UndeclaredVariable id);;

(* uses List.assoc 
   examples:
   List.assoc (Name "x") [(Name "x",Int 3);(Name "y",Bool false);(Name "x",Bool false)]=Int 3;;
   List.assoc (Name "y") [(Name "x",Int 3);(Name "y",Bool false);(Name "x",Bool false)]=Bool false;;
   List.assoc (Name "z") [(Name "x",Int 3);(Name "y",Bool false);(Name "x",Bool false)];; raises exception Not_found
*)

(* dynamic semantics *)

(* dynamic errors *)

exception ExpectingTypeError of string;; (* dynamic conversion error *) 
exception IndexOutOfBoundsError of int;; (* dynamic error for seasonof *) 

(* auxiliary functions *)

(* dynamic conversion to season type *)
(* season : value -> season *)

let season = function
    Season s -> s |
    _ -> raise (ExpectingTypeError "season")

(* dynamic conversion to int type *)
(* int : value -> int *)

let int = function
    Int i -> i |
    _ -> raise (ExpectingTypeError "int")

(* dynamic conversion to bool type *)
(* bool : value -> bool *)

let bool = function
    Bool b -> b |
    _ -> raise (ExpectingTypeError "bool")

(* pair : value -> value * value *)
(* dynamic conversion to product  type *)

let pair = function
    Pair (e1,e2) -> e1,e2 |
    _ -> raise (ExpectingTypeError "pair");;

(* implementation of fst and snd operators *)
(* fst : 'a * 'b -> 'a *)

let fst (v1,_) = v1;;

(* snd : 'a * 'b -> 'b *)

let snd (_,v2) = v2;;

(* auxiliary printing functions *)

(* conversion to string *)

(* to_string : value -> string *)

let rec to_string = function
    Season Winter -> "Winter"
  | Season Spring -> "Spring"
  | Season Summer -> "Summer"
  | Season Fall -> "Fall"
  | Int i -> string_of_int(i) 
  | Bool b -> string_of_bool(b) 
  | Pair(v1,v2) -> "<<" ^ to_string v1 ^ "," ^ to_string v2 ^ ">>";;

(* print : value -> unit *)

let rec print vl = print_string (to_string vl);;

(* println : value -> unit *)

let println vl = print_string (to_string vl ^ "\n");;

(* funzioni su valori season *)

(* seasonof : int -> season *)

let seasonof = function
    0 -> Winter
  | 1 -> Spring
  | 2 -> Summer
  | 3 -> Fall
  | n -> raise (IndexOutOfBoundsError n);;

let numof = function
    Winter -> 0
  | Spring -> 1
  | Summer -> 2
  | Fall -> 3;;

(* lth : value -> value -> bool *)

let rec lth v1 v2 = match v1 with
    Season s -> s < season v2
  | Int i -> i < int v2
  | Bool b -> b < bool v2
  | Pair (fs1,sn1) -> let fs2,sn2=pair v2 in lth fs1  fs2 && lth sn1 sn2;;

(* evExp : dynamic_env -> exp -> value *)

let rec evExp env=function 
  (* espressioni nuove *)
    Lth(exp1,exp2) -> Bool(lth (evExp env exp1) (evExp env exp2))
  | NumOf exp -> Int(numof (season(evExp env exp)))
  | SeasonOf exp -> Season(seasonof (int(evExp env exp)))
  | Season s -> Season s 
  (* espressioni linguaggio labo *)
  | Add(exp1,exp2) -> Int(int(evExp env exp1)+int(evExp env exp2))
  | Mul(exp1,exp2) -> Int(int(evExp env exp1)*int(evExp env exp2))
  | And(exp1,exp2) -> Bool(bool(evExp env exp1)&&bool(evExp env exp2))
  | Eq(exp1,exp2) -> Bool(evExp env exp1=evExp env exp2)
  | Pair(exp1,exp2) -> Pair(evExp env exp1,evExp env exp2)
  | Fst exp -> fst (pair (evExp env exp))
  | Snd exp -> snd (pair (evExp env exp))
  | Sign exp -> Int(-int(evExp env exp))
  | Not exp -> Bool(not (bool(evExp env exp)))
  | Num i -> Int i
  | Bool b -> Bool b
  | Var id -> lookup id env;;

(* mutually recursive
   evStmt : dynamic_env -> stmt -> dynamic_env
   evStmtSeq : dynamic_env -> stmt_seq -> dynamic_env
*)

let rec evStmt env=function
  (* statement nuovo *)
    For(id,exp,stmt_seq) as for_stmt ->
      let v=int(lookup id env) and max=int(evExp env exp)  in (* valuta il valore v di id per l'iterazione corrente e il valore massimo max ammesso per id *)
        if v>max then env (* termina l'iterazione e restituisce l'ambiente corrente *)
        else (* esegue il prossimo ciclo *)
          let env2=enter_scope env in (* crea un nuovo scope annidato inizialmente vuoto *)
          let env3=evStmtSeq env2 stmt_seq in (* esegue la sequenza di statement nel blocco *)
          let env4=exit_scope(env3) in (* esce dallo scope annidato *)
          let env5=update id (Int(v+1)) env4 in (* aggiorna il valore della variabile id del for incrementandolo di 1 *)
            evStmt env5 for_stmt (* valuta ricorsivamente lo statement for *)
  (* statement linguaggio labo *)
  | Assign(id,exp) -> update id (evExp env exp) env
  | Dec(id,exp) -> dec id (evExp env exp) env
  | Print exp -> let _=println (evExp env exp) in env
  | If(exp,stmt_seq) ->
      if bool(evExp env exp) then  
        let env2=enter_scope env in exit_scope(evStmtSeq env2 stmt_seq) (* note the difference with the static semantics *)
      else env
  | IfElse(exp,stmt_seq1,stmt_seq2) ->
      let env2=enter_scope env in
        if bool(evExp env exp) then  
          exit_scope(evStmtSeq env2 stmt_seq1) (* note the difference with the static semantics *)
        else 
          exit_scope(evStmtSeq env2 stmt_seq2) (* note the difference with the static semantics *)

and 

  evStmtSeq env=function 
    SingleStmt stmt -> evStmt env stmt
  | MoreStmt(stmt,stmt_seq) -> evStmtSeq (evStmt env stmt) stmt_seq;;

(* evProg : prog -> unit *)

let evProg = function Prog stmt_seq -> let _=evStmtSeq starting_env stmt_seq in ();;

(* some simple tests with the dynamic semantics *)

let stmt1=Dec(Name "x",Num 0);;

let stmt2=Assign(Name "x",Add(Var(Name "x"),Num 1));;

let stmt3=Print(Var(Name "x"));;

let prog1=Prog(MoreStmt(stmt1,(MoreStmt(stmt2,SingleStmt stmt3))));;

evProg prog1;;

let stmt1=Dec(Name "x",Pair(Num 0,Bool false));;

let stmt2=Print(Var(Name "x"));;

let stmt3=Print(Add(Fst(Var(Name "x")),Num 1));;

let stmt4=Print(And(Snd(Var(Name "x")),Bool true));;

let stmt5=Assign(Name "x",Pair(Num 1,Bool true));;

let prog2=Prog(MoreStmt(stmt1,(MoreStmt(stmt2,MoreStmt(stmt3,MoreStmt(stmt4,SingleStmt stmt5))))));;

evProg prog2;;

let stmt1=Dec(Name "x",Num 0);;

let stmt2=If(Eq(Var(Name "x"),Num 0),MoreStmt(Assign(Name "x",Num 2),MoreStmt(Dec(Name "x",Bool false),SingleStmt(Print(And(Var(Name "x"),Bool true))))));;

let stmt3=Assign(Name "x",Add(Var(Name "x"),Num 1));;

let stmt4=Print(Var(Name "x"));;

let prog3=Prog(MoreStmt(stmt1,(MoreStmt(stmt2,(MoreStmt(stmt3,SingleStmt stmt4))))));;

evProg prog3;;


(*  these examples do not pass typechecking, but execute correctly *)

let stmt1=Dec(Name "x",Num 0);;

let stmt2=Assign(Name "x",Add(Num 1,Var(Name "x")));;

let stmt3=Assign(Name "x",Eq(Num 2,Var(Name "x")));;

let stmt4=Print(Var(Name "x"));;

let prog4=Prog(MoreStmt(stmt1,MoreStmt(stmt2,(MoreStmt(stmt3,SingleStmt stmt4)))));;

evProg prog4;;

let stmt1=Dec(Name "x",Pair(Num 0,Bool false));;

let stmt2=Print(Eq(Var(Name "x"),Pair(Bool false,Num 0)));;

let prog5=Prog(MoreStmt(stmt1,SingleStmt stmt2));;

evProg prog5;;

let printx=Print(Var(Name "x"));;

let stmt1=Dec(Name "x",Sign(Num 1));;

let stmt2=For(Name "x",Mul(Sign(Num 2),Var(Name "x")),SingleStmt printx);;

let stmt3=printx;;

let prog6=Prog(MoreStmt(stmt1,(MoreStmt(stmt2,SingleStmt stmt3))));;

evProg prog6;;

let stmt1=Dec(Name "s",Num 0);;

let stmt2=For(Name "s",Num 3,SingleStmt(Print(SeasonOf(Var(Name "s")))));;

let prog6=Prog(MoreStmt(stmt1,SingleStmt stmt2));;

evProg prog6;;

let p1:exp=Pair(Pair(Num 0,Var(Name "w")),Bool false);;

let p2:exp=Pair(Pair(Num 1,Season Spring),Bool true);;

let p3:exp=Pair(Pair(Num 0,Season Spring),Bool true);;

let p4:exp=Pair(Pair(Num 1,Var(Name "w")),Bool true);;

let p5:exp=Pair(Pair(Num 1,Season Spring),Bool false);;

let stmt1=Dec(Name "w",Season Winter);;

let stmt2=Print(Lth(p1,p2));;

let stmt3=Print(Not(Lth(p1,p3)));;

let stmt4=Print(Not(Lth(p1,p4)));;

let stmt5=Print(Not(Lth(p1,p5)));;

let prog7=Prog(MoreStmt(stmt1,(MoreStmt(stmt2,MoreStmt(stmt3,MoreStmt(stmt4,SingleStmt stmt5))))));;

evProg prog7;;

let stmt1=Print(NumOf(Season Winter));;

let stmt2=Print(NumOf(Season Spring));;

let stmt3=Print(NumOf(Season Summer));;

let stmt4=Print(NumOf(Season Fall));;

let prog8=Prog(MoreStmt(stmt1,MoreStmt(stmt2,(MoreStmt(stmt3,SingleStmt stmt4)))));;

evProg prog8;;
