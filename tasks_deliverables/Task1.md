# Task 1 Deliverables

## Introduction

## Chosen Kata : Fix pawn moves!

L'objectif de ce kata est de réaliser les déplacements des pions (Pawns) du jeu d'échec, en concevant des tests et en fournissant une implémentation de ces derniers. 

## Kata features

1. Les pions peuvent avancer tout droit de 2 cases pour leur premier mouvement. 
2. Les pions avance d'une case à la fois (à l'exception du premier mouvement).
3. Les pions peuvent avancer d'une case en diagonale pour capturer une pièce ennemie.
4. “En passant” : Si un pion adverse avance de 2 cases (pour son premier mouvement) et attérie à côté (sur la même ligne) qu'un de nos pions, notre pion peut le capturer en avançant en diagonale juste derrière lui.  


## Functionalities to test : “A good test is a test that catches bugs”

**Idea :** Avant d'implémenter le refactoring, nous avons écrit des tests mettant en évidence les bugs liés aux mouvements des pions, en se basant sur “_The Right BICEP principle_”.

### _Checking the right result (Right)_

**Feature 1:** Nous allons vérifier qu'en avançant 1 ou 2 cases au premier mouvement d'un pion, on arrive sur la bonne case.

**Feature 2:** Nous allons vérifier qu'on n'avance que d'une case après le premier mouvement d'un pion.

**Feature 3:** Nous allons vérifier que si un pion peut capturer un pion adverse, alors il peut avancer en diagonal et le pion adverse est capturé (plus sur le plateau).


### _Checking boundary cases (B)_

check extreme cases (e.g. null, 0, empty, bigger than the collection…)

- Après chaque déplacement, l'attribut square ne doit pas être vide/null (au départ). 

**Feature 1:** Nous allons vérifier qu'on ne peut pas avancer de plus de 2 cases au premier mouvement. 

**Feature 2:** Nous allons vérifier qu'on ne peut pas avancer de plus de 1 case après le premier mouvement.

### _Checking inverse conditions (I)_

**Feature 3:** Nous allons vérifier que si un pion ne peut pas capturer un pion adverse, alors il peut pas avancer en diagonal et le pion n'est pas capturé (présent sur le plateau).

### _check error conditions (E)_
check complex cases (e.g. exceptions)



<!-- ---------- -->
TODO : 
(what are the functionalities to test for the refactoring ?)
(what tests did you write and why)
(what test you did not write and why)
<!-- ---------- -->

### How To : 

- Lancer la couverture de code
- Lancer les tests 

# Evaluation : TODO

Task 1 will be evaluated by the quality and thoroughness of your tests.

We will evaluate : 70% of the grade
- code coverage
- tests for positive cases
- negative cases
- border cases 
- default values. 

30% of the grade: 

In addition of writing your tests, apply the kata refactoring. This shows that your tests do actually work.