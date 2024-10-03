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

**Mutation Score After Testing:** `97`  
Nous avons 97% des mutants qui ont été tués, avec 160 mutants crée, 156 mutants ont été tués et 4 ont survécu.

**What test you did not write and why:**  
4 mutants ont survécu, ces mutants sont du même type et tous liés à la fonction `possibleDiagonalMove`.   
Cette fonction construit un Array de squares des déplacements en diagonale possibles pour un pion.  
Les 4 mutants ont chacun changé le type de l'Array par ses sous-classes (`WeakArray`,`BlLayoutNodeChildren`,`WeakActionSequence`,`Cubic`).   
Je n'ai pas écrits de tests pour ces derniers car ceux ci sont des mutants équivalent (il change la syntaxe du code, mais ne modifie pas le comportement du programme).  


**An in-detail explanation of 3 mutants you killed and how you killed them :**    

1. Un premier mutant m'a montré que, le cas où l'on souhaitait avancé en diagonale et que les cases étaient occupées par des pions de la même équipe, n'était pas testé : (voir code `possibleDiagonalMove`).

    Pour contrer ce mutant nous avons ajouté le test `testCannotMoveInDiagonalIfAllyInTargetSquare`, qui simule une situation avec deux pions de même couleur :  
    - Nous avons avancé un pion (Pa) de 2 cases, et avons avancé son voisin (PB) d'une case.
    - Puis, nous avons essayé de déplacer PB sur la case ou se situait PA et nous avons vérifier que le déplacement n'avait pas réussi.   

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
- Premièrement, les nombres `2` et `7` correspondent aux lignes de l'échiquer où les pions ont le droit d'avancer de 2 cases au premier déplacement. On obtient cette information par le nom de la case (`square name (ex: e2)`).
- Ensuite, si la fonction `findString: '2' ou '7'` renvoie un indice > 0, on est sûr que l'indice serait `2` (par construction du nom des cases du board (`ex: size: 'e2' = 2`)).   

D'où nous avons cette fois-ci tué le mutant via le code source directement, en remplaçant le `> 0` par `= 2` : 
```smalltalk
isFirstStep
    ^(self isWhite 
        ifTrue: [ (square name findString: '2' ) = 2 ] 
        ifFalse: [ (square name findString: '7' ) = 2 ]).

```

3. Il existait un groupe de mutants autour de la fonction `renderPieceOn`, je n'avais pas effectué de tests dessus car elle s'occupait juste de l'affichage. 
Donc il y'avait plusieurs mutations qui remplaçaient la valeur de retour de la fonction.   

Nous avons donc écrit un test qui vérifiait les bonnes valeurs de retour de la fonction :
```smalltalk
"La fonction renderPieceOn fait simplement appel a cette fonction "
renderPawn: aPiece

	^ aPiece isWhite
		  ifFalse: [
			  color isBlack
				  ifFalse: [ 'O' ]
				  ifTrue: [ 'o' ] ]
		  ifTrue: [
			  color isBlack
				  ifFalse: [ 'P' ]
				  ifTrue: [ 'p' ] ]
```
Le test `testRenderPieceOn` vérifie les valeurs de retour suivantes en se mettant dans les conditions nécessaire.


**an in-detail explanation of 3 equivalent mutants, explaining why they are equivalent**  

Nous allons expliquer pourquoi 3 des 4 mutants expliqués plus haut sont équivalent : 

- Au niveau du `WeakArray` : il implémente la logique des weak pointer, c'est à dire que tant qu'il existe une référence (dite forte) à un des objets du tableau ailleurs dans le programme, 
l'objet n'est pas détruit (par le garbage collector ou destructeur en C++), Et nous on peut bien le voir, car les squares présents dans le tableau ont tous une référence dans le board donc tant que la partie n'est pas fini la fonction ne changera pas son comportement.

- Au niveau du `BlLayoutNodeChildren` : il est utilisée dans le contexte de l'interface utilisateur pour gérer les enfants d'un layout, mais appriori pour la gestion des élements, elle agit comme un conteneur basique d'objet, et donc dans notre cas ne crée pas d'effet de bord.

- La classe `Cubic` quant à elle représente des formes géométriques ou des courbes, utilisées pour des calculs graphiques ou des animations dans des environnements 3D. Elle hérite de Collection donc possède un conteneur pour stocker les données sauf que le code de `possibleDiagonalMove` ne fait appel à aucune des fonctionnalités de calculs géométriques de la classe. 
Donc elle joue le rôle d'un simple conteneur ici encore.



**Bonus 30% of the grade:** Analyse equivalent mutants and implement at least one strategy to minimize them. Your implementation and scripts to use it should be available in the repository. Explain your analysis and implementation in the report.


 

