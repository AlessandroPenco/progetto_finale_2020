# Progetto finale LPO a.a. 2019-'20

## Contenuto del repository

* `semantica-statica.ml` : semantica statica del linguaggio esteso, definita in OCaml
* `semantica-dinamica.ml` : semantica dinamica del linguaggio esteso, definita in OCaml
* `specifica.pdf`: specifica del linguaggio esteso, con commenti ed esempi
* `tests/success`: test che vengono eseguiti senza errori (senza opzione `-ntc`)
* `tests/failure/syntax`: test che non passano i controlli di sintassi 
* `tests/failure/static-semantics/`: test che non passano i controlli di semantica statica (senza opzione `-ntc`)
* `tests/failure/dynamic-semantics/`: test che non passano i controlli di semantica dinamica (senza opzione `-ntc`)
* `tests/failure/ntc/`: test che non passano i controlli di semantica dinamica (con opzione `-ntc`)

## Modalità di consegna

È sufficiente avere attivato il link di GitHub classroom e rendere disponibili sul repository tutti i sorgenti necessari
per la compilazione del progetto. Ricordatevi di fare il commit e push finali e poi comunicatemi il link
del repository tramite la [consegna su AulaWeb](https://2019.aulaweb.unige.it/mod/assign/view.php?id=20793). 
Per favore, indicatemi un **unico** repository anche se il gruppo è costitutio da più persone.

**Importante**: per la consegna è necessario che il progetto passi **tutti i 29 test** contenuti nel folder `tests`.
Tutti i componenti del gruppo devono contribuire equamente allo sviluppo del progetto, lo scopo del colloquio finale **individuale**
è quello di verificare che ognuno abbia ben compreso il funzionamento del progetto.