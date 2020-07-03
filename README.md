# Progetto finale LPO a.a. 2019-'20

## Contenuto del repository

* `lab11_05_11` : Directory contenente i file dai quali si è partiti per svolgere il progetto
* `progetto_LPO_2020` : Directory contenente il progetto
* `semantica-statica.ml` : semantica statica del linguaggio esteso, definita in OCaml
* `semantica-dinamica.ml` : semantica dinamica del linguaggio esteso, definita in OCaml
* `specifica.pdf`: specifica del linguaggio esteso, con commenti ed esempi
* `tests/success`: test che vengono eseguiti senza errori (senza opzione `-ntc`)
* `tests/failure/syntax`: test che non passano i controlli di sintassi 
* `tests/failure/static-semantics/`: test che non passano i controlli di semantica statica (senza opzione `-ntc`)
* `tests/failure/dynamic-semantics/`: test che non passano i controlli di semantica dinamica (senza opzione `-ntc`)
* `tests/failure/ntc/`: test che non passano i controlli di semantica dinamica (con opzione `-ntc`)

## Membri del gruppo

* Alessandro Penco - 4697398
* Alessio Drago - 4663991
* Gagandeep Singh - 4658821

## Esecuzione del progetto

Si è usato come modello di partenza la soluzione al laboratorio 11-05-20 al quale sono stati aggiunti i seguenti file:
* `progetto_LPO_2020/parser/ast/ForStmt.java`
* `progetto_LPO_2020/parser/ast/Lower.java`
* `progetto_LPO_2020/parser/ast/NumOf.java`
* `progetto_LPO_2020/parser/ast/SeasonLiteral.java`
* `progetto_LPO_2020/parser/ast/SeasonOf.java`
* `progetto_LPO_2020/visitors/evaluation/SeasonValue.java`

Inoltre sono stati modificati i seguenti sorgenti:
* `progetto_LPO_2020/parser/BufferedParser.java`
* `progetto_LPO_2020/parser/BufferedTokenizer.java`
* `progetto_LPO_2020/parser/TokenType.java`
* `progetto_LPO_2020/parser/Tokenizer.java`
* `progetto_LPO_2020/visitors/Visitors.java`
* `progetto_LPO_2020/visitors/evaluation/BoolValue.java`
* `progetto_LPO_2020/visitors/evaluation/IntValue.java`
* `progetto_LPO_2020/visitors/evaluation/PariValue.java`
* `progetto_LPO_2020/visitors/evaluation/Value.java`
* `progetto_LPO_2020/visitors/evaluation/Eval.java`
* `progetto_LPO_2020/visitors/typechecking/PrimtType.java`
* `progetto_LPO_2020/visitors/typechecking/TypeCheck.java`
