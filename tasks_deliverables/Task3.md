
# Fuzzing, oracles and property based testing

## Introduction

L'objectif de cette tâche est d'effectuer du _mutation fuzzing testing_ afin de découvrir des bugs dans notre projet.

## Explanation of the components used for our analysis

### My FEN Chess Grammar

Nous avons crée la classe `MyFenChessGrammar` représentant la grammaire du _FEN_.

```smalltalk
GncBaseGrammar << #MyFenChessGrammar
	slots: {
			 #ntSeparator . #ntFen . #ntRow . #ntWhitePieces . #ntBlackPieces . #ntWhitePiece . #ntBlackPiece . #ntRows . #ntTurn . #ntBlackOrWhitePiece . #ntMoreWhite . #ntMoreBlack . #ntRockRule };
	package: 'MyFuzzer'
```

Cette classe possède dans sa méthode `defineGrammar` les règles définissant une chaine _FEN_ :

```smalltalk
defineGrammar
  
	super defineGrammar.
	
	ntSeparator --> '/'.
	ntTurn --> 'w'| 'b'.
	ntWhitePiece --> 'R'|'N'|'B'|'Q'|'K'.
	ntBlackPiece --> 'r'|'n'|'b'|'q'|'k'.
	ntBlackOrWhitePiece --> ntBlackPiece | ntWhitePiece.
	ntRockRule --> 'KQkq'.

	ntMoreWhite  --> ntWhitePiece | ntBlackPiece | ntWhitePiece.
	ntMoreBlack  --> ntWhitePiece | ntBlackPiece | ntBlackPiece.
	
	ntWhitePieces --> ntMoreWhite, ntMoreWhite, ntMoreWhite, ntMoreWhite, ntMoreWhite, ntMoreWhite,           ntMoreWhite, ntMoreWhite.
	
	ntBlackPieces --> ntMoreBlack, ntMoreBlack, ntMoreBlack, ntMoreBlack, ntMoreBlack, ntMoreBlack,           ntMoreBlack, ntMoreBlack.
	
	ntRow --> '8' | '7', ntBlackOrWhitePiece | ($1 - $5), ntBlackOrWhitePiece,($1 - $2) |                      ntBlackOrWhitePiece,'7' | ntWhitePieces | ntBlackPieces.
				
	ntRows --> ntSeparator , ntRow .

	
	ntFen --> ntBlackPieces, ntRows,ntRows,ntRows,ntRows,ntRows,ntRows,
	ntSeparator,ntWhitePieces,' ',ntTurn,' ',ntRockRule,' ', '-', ' ', ($0 - $1),' ',($1 - $2) .
	
	
	^ ntFen
```
Cet ensemble de règle nous a permis d'obtenir des FEN valides et non valides. 
- En effet en me basant sur une chaine valide pour construire ma grammaire, j'ai fixé le caractère non valide au niveau de la règle `ntRow`, afin de controler un peu mieux ma proportion de valide/non valide (_il y a seulement un cas dans le ntRow qui peut rendre notre chaine non valide et possiblement la position des pions dans l'échiquer au départ_).
- Aussi j'ai essayé de mimer un peu plus la réalité avec les règles `ntMoreWhite`/`ntMoreBlack` qui contribue au fait d'avoir plus de chance d'avoir des pièces blanches dans la zone des blancs (pareil pour les noirs), mais de permettre  d'avoir également des couleurs adverses dans son camp (généralement en fin de partie).



### My FEN Chess Oracle

Pour concevoir l'oracle, j'ai crée un service vérifiant la validité du `FEN` en me basant sur le module `chess` de python qui permet de manipuler et de valider des positions d'échecs. 

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
    | client jsonResponse parsedResponse isValid |
    
        client := ZnClient new.
        client 
            url: 'http://127.0.0.1:8000/validate_fen/'; 
            entity: (ZnEntity 
                        with: input 
                        type: ZnMimeType applicationJson).
        client post.
    ...

```


## Bug Analysis

Pour les différentes méthodes de tests implémenter, nous prenons comme Oracle le `MyPzChessFenOracleRunner`.  
Nous allons appliquer plusieurs méthodes de tests afin de découvir des bugs sur le `MyFENParser`.   

### By Random Fuzzing

Une première approche est d'envoyer des inputs non structuré au parser puis observer comment il réagit :

```smalltalk
|f|
f := PzRandomFuzzer new.
r := MyPzChessFenOracleRunner on: [ :e | e].
r expectedException: AssertionFailure.
results := f run: r times: 100.

results count: [:e| ((e at: 1) findString: 'PASS-FAIL') > 0].
results inspect 
```

| Fuzzer        | Pass | Expected Fail | Fail |
|---------------|------|---------------|------|
| Weird Chars   | 0 % | 3 %          | 97 %|

Avec cette stratégie, nous pouvons remarquer que la plupart des tests ne sont pas passés, néanmoins nous avons pu observer quelques bugs.

**Liste des (uniques) bugs:**
- 97% des cas en erreur étaient liés à un unique bug : un `KeyNotFoundException` qui est une erreur générique de la Collection `Dictionnaire`. 
- Nous avons considéré l'exception `AssertionFailure` comme expected car c'est une exception provenanant du parser lui même.

### By Grammar Fuzzing

Une seconde approche est de générer des inputs suivant la structure d'une FEN au parser et ainsi voir  comment il réagit avec des données plus probables.

```smalltalk
|chessFenFuzzer r results|
chessFenFuzzer := PzGrammarFuzzer on: MyFenChessGrammar new.
r := MyPzChessFenOracleRunner on: [ :e | e ].
r expectedException: AssertionFailure.
results := chessFenFuzzer run: r times: 100.

results count: [:e| ((e at: 1) findString: 'PASS') > 0].
```
* Le cas `PASS-FAIL` représente le cas où le parser à levé une exception attendu et l'oracle n'a pas validé la FEN non plus. 

En analysant sur `100` inputs provenant de **notre grammaire** :

| Expected-Fail | 0 % |
|---------------|------|
| FAIL         | 100 % |
| PASS          | 0 %  |

- En regardant plus en détail, 66% des failures représentaient les cas ou le parser avait levé une exception non attendu (erreur générique) et que l'oracle n'as pas validé la FEN également => Il y a un manque d'exception controlé.
- Les 34% de failure restants sont les cas où l'oracle à validé la FEN et que le parser à levé une exception, on pourrait se demander si notre parser serait trop rigide sur les placements ou plutôt est ce que notre oracle serait moins stricte sur les configurations de chessBoard?
 

**Liste des (uniques) bugs:**
- Comme bug, nous avons une erreur générique `sizeMisMactchException` de la collection `OrderedCollection`.

- **_Constat:_** J'ai pu constater que l'oracle refusait bien en cas de mauvais nombre de pion pour une partie ou si les pions n'existait pas etc., par contre j'ai remarqué qu'il acceptait par exemple une configuration avec 2 roi dans une équipe ou une configuration où il y avait plus de blanc que de noir.   
Donc je pense qu'il vérifie bien l'initialisation du board, mais pas les règles spécifique comme celle ci.

#### Analyse sur des FENs valide 

**NB :** “Je me suis aussi dit que peut être que ma grammaire ne donnait pas assez de good FEN, et je voulais cibler les bugs liés au cas où on envoyait des FENs valide au parser et qu'il plantait”.

Nous avons donc crée un fuzzer qui stocke un ensemble de good fen et dont la méthode `fuzz` renvoie l'une d'entre elle de manière aléatoire.

```smalltalk
PzFuzzer << #MyPzGoodFENFuzzer
	slots: { #fens };
	tag: 'Core';
	package: 'MyPhuzzer'
```

En analysant sur `100` inputs **valide pour l'oracle** :

```smalltalk
|f results|

f := MyPzGoodFENFuzzer new.
r := MyPzChessFenOracleRunner on: [ :e | e].
r expectedException: AssertionFailure.
results := f run: r times: 100.
results count: [:e| ((e at: 1) findString: 'PASS') > 0].
```
| Expected-Fail | 0 % |
|---------------|------|
| PASS          | 10 %  |
| FAIL         | 90 % |


- C'est intéressant de voir que, pour des FENs normalement valide, notre Parser renvoie l'erreur générique `sizeMisMactchException` 90% du temps (les cas FAIL), il semblerait que dès qu'on lui passe une FEN avec des lignes avec des cases pas entièrement vide il plante.


### By Mutation Fuzzing

Une nouvelle approche pour rechercher des bugs sur notre parser, est de procéder par `Mutation Fuzzing`.  
Dans cette approche on envoi à notre parser des inputs structurée (suivant la `MyFenChessGrammar`) mais en ajoutant une petite variation à ces inputs.


#### Implemented Mutations

Comme mutation, j'ai implémenté une se chargeant d'échanger de place deux caractères aléatoirement, et comme seconde mutation, une qui renverse tous les caractères d'une chaine entre deux positions i,j.

##### MySwapCharactersMutation

```smalltalk
MySwapCharactersMutation>>mutate: aString

| index1 index2 tmp |
index1 := aString size atRandom.
index2 := aString size atRandom.

(index1 = index2) ifTrue: [^aString].
(index1 < index2)
    ifFalse: [ tmp := index1. index1 := index2. index2 := tmp.].

^ (aString copyFrom: 1 to: index1 - 1), (aString at: index2) asString, 
    	(aString copyFrom: index1 + 1 to: index2 - 1), (aString at: index1) asString, 
    		(aString copyFrom: index2 + 1 to: aString size)
```

```smalltalk
"Pour tester dans le playground"
MySwapCharactersMutation new mutate: 'marie'.
```

##### MyReverseCharactersMutation

```smalltalk
MyReverseCharactersMutation>>mutate: aString

| index1 index2 tmp reversedSubstring |
index1 := aString size atRandom.
index2 := aString size atRandom.

(index1 = index2) ifTrue: [^aString].
(index1 < index2) ifFalse: [ tmp := index1. index1 := index2. index2 := tmp. ].

reversedSubstring := (aString copyFrom: index1 to: index2) reversed.

^ (aString copyFrom: 1 to: index1 - 1), reversedSubstring, (aString copyFrom: index2 + 1 to: aString size)

```

```smalltalk
"Pour tester dans le playground"
MyReverseCharactersMutation new mutate: 'marie'.
```
#### Analysis

En analysant sur `100` inputs provenant de notre **grammaire** :

```smalltalk
|chessFuzzer corpus mutationFuzzer r results|

chessFuzzer := PzGrammarFuzzer on: MyFenChessGrammar new.
corpus := (1 to: 100) collect: [ :e | chessFuzzer fuzz ].

mutationFuzzer := PzMutationFuzzer new.
mutationFuzzer mutations: { MySwapCharactersMutation new}. "Or MyReverseCharactersMutation Or Both"
mutationFuzzer seed: corpus.

r := MyPzChessFenOracleRunner on: [ :e | e ].
r expectedException: AssertionFailure.
results := mutationFuzzer run: r times: 100.

results count: [:e| ((e at: 1) findString: 'PASS-FAIL') > 0].
```

| type of mutation | Pass | Expected Fail | Fail |
|---------------|------|---------------|------|
| MySwapCharactersMutation   | 0 % | 60 %    | 40 % |
| MyReverseCharactersMutation | 0 %  | 80 %           | 20 %|
| MixingBoth | 0 %  | 75 %           | 25 %|

- On peut remarquer un grand taux d'expected failures dans cette approche. On pourrait en déduire que le parser fasse à ce type de mutation abérente réagit quand même bien. 


**Liste des (uniques) bugs:**  
- On retrouve les bugs qu'on avait trouvé avant : l'erreur générique `KeyNotFoundException` et `sizeMisMactchException`.  




