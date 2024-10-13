
# Fuzzing, oracles and property based testing

## Introduction

L'objectif de cette tâche est d'effectuer du _mutation fuzzing testing_ afin de découvrir des bugs dans notre projet.

## Explanation of the components used for our analysis

### My FEN Chess Grammar

Nous avons crée la classe `MyFenChessGrammar` représentant la grammaire du _FEN_.

```smalltalk
GncBaseGrammar << #MyFenChessGrammar
	slots: { #ntSeparator . #ntFen . #ntRow . #ntWhitePieces . #ntBlackPieces . #ntWhitePiece . #ntBlackPiece . #ntRows };
	package: 'MyFuzzer'
```

Cette classe possède dans sa méthode `defineGrammar` les règles définissant une chaine _FEN_ :

```smalltalk
defineGrammar
  "The superclass defines how to generate numbers"
	super defineGrammar.
	
  "Definition of board configuration"
	ntSeparator --> '/'.
	ntWhitePiece --> ('R'|'N'|'B'|'Q'|'K').
	ntBlackPiece --> ('r'|'n'|'b'|'q'|'k').
	ntRow --> ($1-$8) | ($1 - $8),ntRow | ntWhitePieces,ntRow | ntBlackPieces,ntRow .
	ntRows --> ntSeparator , ntRow .
	ntWhitePieces --> ntWhitePiece | ntWhitePiece, ntWhitePieces .
	ntBlackPieces --> ntBlackPiece | ntBlackPiece, ntBlackPieces .
	
	ntFen --> ntBlackPieces, ntRows , ntRows, ntRows, ntRows, ntRows, ntRows,ntSeparator,ntWhitePieces.
	
	^ ntFen
```
A travers ses règles :
- les règles `ntWhitePieces` et `ntBlackPieces` nous permettent de récursivement ajouter un à plusieurs pions en fonction de sa couleur sur le board.
- la règle `ntRows` nous permet de décider si, sur une ligne du chess board, on ajoute une pièce ou pas du tout, les entiers (`($1-$8)`) nous permettent de placer les cases vides. 
- la règle `ntFen` nous permet d'indiquer, pour chaque row du chess board, la répartition de piece.   
  On peut remarquer qu'on a diminué la probabilité d'avoir des pions noirs dans la zone blanche et inversement, car la plus part des mouvements dans une d'échec en cours sont dans ce schéma, et lorsqu'on arrive en fin de partie on peut donc voir les pions adverses en priorité dans son camp.

TODO.


### My FEN Chess Oracle

Pour concevoir l'oracle, j'ai crée un service vérifiant la validité du `FEN` en me basant sur le module `chess` de python : 

(TODO : décrire commment il fonctionne)
```python
from fastapi import FastAPI
from pydantic import BaseModel
import chess

app = FastAPI()

# Modèle de requête
class FENRequest(BaseModel):
    fen: str

@app.post("/validate_fen/")
async def validate_fen(fen_request: FENRequest):
    fen = fen_request.fen
    try:
        #Le FEN est pas valide
        board = chess.Board(fen)
        return {"fen": fen, "valid": True}
    except ValueError:
        #Le FEN n'est pas valide
        return {"fen": fen, "valid": False}
```

#### How To execute service

- ouvrer un terminal dans le dossier `Chess/service>`
- (optionnel) : installer les modules requis : `pip3 install -r requirements.txt`
- exécuter la commande `python3 -m uvicorn oracle:app --reload`

```sh
curl -X POST "http://127.0.0.1:8000/validate_fen/" -H "Content-Type: application/json" -d '{"fen": "2k5/8/8/8/8/4N1N1/K2B1NNN/8 w - - 0 1"}
```
or 

```smalltalk
	|client jsonResponse parsedResponse isValid input|
	input := '{"fen": "2k5/8/8/8/8/4N1N1/K2B1NNN/8 w - - 0 1"}'.
	client := ZnClient new.
	client 
    	url: 'http://127.0.0.1:8000/validate_fen/';
    	entity: (ZnEntity 
                	with: input
                	type: ZnMimeType applicationJson);
    	post.
	jsonResponse := client response entity contents.
	parsedResponse := NeoJSONReader fromString: jsonResponse.
	parsedResponse.
```

#### How to build the Oracle

Nous avons crée une classe `MyPzChessFenOracleRunner` représentant notre Oracle.

```smalltalk
PzBlockRunner << #MyPzChessFenOracleRunner
	slots: {};
	tag: 'Runners';
	package: 'MyPhuzzer'
```
Cette classe se charge de prendre en entrée une FEN string et l'envoie à notre service et celui ci vérifie la validité de la chaine.   
Si la chaine est valide notre oracle écrira un 'PASS' dans la console.

```smalltalk
basicRunOn: input
	^ self block value: (self checkChessFenString:input).

checkChessFenString: input
	^(ZnClient new
			post: 'http://127.0.0.1:8000/validate_fen/' 
			contents:input).
```
TODO

### Type of mutations implemented
on a vue 3 types de mutations : enlever/ajouter/supprimer un caractère 





```
|chessFenFuzzer corpusGoodChessFen corpus mutationFuzzer|

chessFenFuzzer := PzGrammarFuzzer on: MyFenChessGrammar new.


corpusGoodChessFen := Array 
with: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
with: 'rnbqkb1r/pppppppp/5n2/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 1 2'
with: 'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 1 2'
with: 'rnbqkbnr/1p1p1ppp/2p5/p7/P4pP1/3P4/1PP1P2P/RNBQKBNR w KQkq - 0 1'
with: 'rnbqkb1r/pppppppp/5n2/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 1 2'.

corpus := (1 to: 100) collect: [ :e | chessFenFuzzer fuzz ].
mutationFuzzer := PzMutationFuzzer new.
mutationFuzzer seed: corpus.

r := MyPzChessFenOracleRunner on: [:e | e].
mutationFuzzer run: r times: 100.

corpusGoodChessFen do: [:fen | r run: fen].


```


## Bug Analysis

Pour les différentes méthodes de tests implémenter, nous avons prenons comme Oracle le `MyPzChessFenOracleRunner`.

Si on trouve 1000 bugs -> est ce que c'est toujours le même bug ou 1000 
```smalltalk
MyFENParser parse: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.
```

### By Random Fuzzing

| Fuzzer        | Pass | Expected Fail | Fail |
|---------------|------|---------------|------|
| Weird Chars   | 49 % | 29 %          | 22 % |
| Large Char set| 0 %  | 0 %           | 100 %|
| Alphanumeric  | 0 %  | 0 %           | 100 %|

**Liste des (uniques) bugs:**
- weird char : < nom de l'erreur > bug
- ....


- Le random input peut dévoiler des bugs mais fails facilement.

### By Grammar Fuzzing

```smalltalk
|chessFenFuzzer r|

chessFenFuzzer := PzGrammarFuzzer on: MyFenChessGrammar new.
r := MyPzChessFenOracleRunner on: [ :e | MyFENParser parse: e ].
chessFenFuzzer run: r times: 100.
```

En analysant sur  ... inputs :

| Pass          | 81 % |
|---------------|------|
| Expected-Fail | 10 % |
| Fail          | 9 %  |

**Liste des (uniques) bugs:** (avec proportion)
- weird char : < nom de l'erreur > bug

**Conclusion:**
- En structurant nos inputs ...

### By Mutation Fuzzing



TO think :


*differential testing : si l'oracle valide alors, le parser du jeu d'echer devrait marcher*

what kind of mutations did you use and how did you implement them?