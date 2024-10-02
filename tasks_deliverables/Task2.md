# Task 2 Deliverables : Mutation testing

## Introduction

L'objectif de cette tâche est d'analyser des tests de mutation dans notre projet.

# Mutation Analysis 

J'ai choisi d'analyser la classe `MyPawn` au vue du _Kata n°1_, car j'ai eu à effectuer beaucoup de tests dans cette classe et je voulais vérifier la fiabilité de mes tests.  

### Analysis Commands

**Chargement des mutations :**  

```smalltalk
testCases :=  { MyPawnTest }.
classesToMutate := { MyPawn }.

analysis := MTAnalysis new
    testClasses: testCases;
    classesToMutate: classesToMutate.

analysis run.
```
**Calcul du mutation score :**    

```smalltalk
analysis generalResult mutationScore
```

**Regroupement des méthodes ayant le plus de mutants**  

```smalltalk
((analysis generalResult aliveMutants)
	groupedBy: [ :m |m mutant originalMethod ])
		associations sorted: [ :a :b | a value size > b value size ]
```
## Mutiation Score Analysis

**Initial Mutation Score:** `90`  
Nous avons 90% des mutants qui ont été tués, avec 160 mutants crée, 145 mutants ont été tués et 15 ont survécu.

**Mutation Score After Testing:** `90`  
Nous avons 90% des mutants qui ont été tués, avec 160 mutants crée, 145 mutants ont été tués et 15 ont survécu.

**What test you did not write and why:**  


### Alive Mutant Analysis
- Nous avons pu tuer tous les mutants et parmis eux voici ce qui étaient les plus complexes
- Nous n'avons pas pu tuer ces mutants parce que.

**An in-detail explanation of 3 mutants you killed and how you killed them :**    

1. La première mutation a montré que, le cas où l'on souhaitait avancé en diagonale et que les cases étaient occupées par des pions de la même équipe, n'était pas testé : (voir code `possibleDiagonalMove`).

    Pour contrer ce mutant nous avant ajouté le test `testCannotMoveInDiagonalIfAllyInTargetSquare`, qui simule une situation avec deux pions de même couleur (cas de test fait pour les deux couleurs) :  
    - Nous avons avancé un pion de 2 cases, et avons avancé son voisin d'une case.
    - Puis, nous avons essayé de nous déplacer sur la case ou se situait le pion voisin et nous avons vérifier que le déplacement n'avait pas marché en vérifiant la postion de nos 2 pions après le déplacement.   

    Réciproquement nous avons un cas de test pour ce cas : `testCannotMoveInDiagonalIfEmptyTargetSquare`.  

2. Une deuxième mutation se trouvait au niveau de ma fonction qui vérifiait si un pion était à son premier déplacement :
```smalltalk
MyPawn >> isFirstStep [
    ^(self isWhite 
        ifTrue: [ (square name findString: '2' ) > 0 ] 
        ifFalse: [ (square name findString: '7' ) > 0 ]).

]
```
le nombre `0`, correspondant à l'indice indiquant que la méthode n'avait pas trouvé la sous-chaine, avait été remplacé par un `1`, ce qui avait laissé les tests correcte car :
- Premièrement, les nombres `2` et `7` correspondent au ligne des cases du tableau ou les pions ont le droit de faire 2 déplacements, et l'on obtient cette information par le nom de la case (`square name (ex: e2)`).
- Ensuite, si la fonction `findString: '2' ou '7'` renvoie un > 0, on est sûr que l'indice serait `2` (par construction du nom des squares du board).   

D'où nous avons cette fois-ci tué le mutant via le code source directement : 
```smalltalk
isFirstStep
    ^(self isWhite 
        ifTrue: [ (square name findString: '2' ) = 2 ] 
        ifFalse: [ (square name findString: '7' ) = 2 ]).

```

**an in-detail explanation of 3 equivalent mutants, explaining why they are equivalent**  

Array, shared pointer explanation as the board is alive until the game end, there were always a reference so It act as a normal array. 

**Bonus 30% of the grade:** Analyse equivalent mutants and implement at least one strategy to minimize them. Your implementation and scripts to use it should be available in the repository. Explain your analysis and implementation in the report.


 

