# Task 1 Deliverables : Manual testing and refactoring

## Introduction

## Chosen Kata : Fix pawn moves!

L'objectif de ce kata est de réaliser les déplacements des pions (Pawns) du jeu d'échec, en concevant des tests et en fournissant une implémentation de ces derniers. 

## Kata features

1. Les pions peuvent avancer tout droit de 2 cases pour leur premier mouvement. 
2. Les pions avance d'une case à la fois (à l'exception du premier mouvement).
3. Les pions peuvent avancer d'une case en diagonale pour capturer une pièce ennemie.
4. “En passant” : Si un pion adverse avance de 2 cases (pour son premier mouvement) et attérie à côté (sur la même ligne) qu'un de nos pions, notre pion peut le capturer en avançant en diagonale juste derrière lui.  


## Functionalities to test : “A good test is a test that catches bugs”

**Idea :** Avant d'implémenter le refactoring, nous avons écrit des tests mettant en évidence les bugs liés aux mouvements des pions (TDD), en se basant sur “_The Right BICEP principle_”.

### _Checking the right result (Right)_

**Feature 1:** 

Nous allons vérifier que :
1. Nos déplacements possible sont au nombre de 2 cases (droit devant) ✅  
2. En avançant 1 ou 2 cases **au premier mouvement** d'un pion, on arrive sur la bonne case. ✅  

Il est bien de tester (2.) car l'ajout du flag vérifiant si on est au premier déplacement ou non d'un pion a pu impacter le cas de déplacement initial (avancement d'une case).  

**Feature 2:** Nous allons vérifier qu'on peut avancer d'une case après le premier mouvement d'un pion. ✅  

**Feature 3:** Nous allons vérifier que si un pion peut capturer un pion adverse, alors il peut avancer en diagonal. ✅  

**Feature 3:** Nous allons vérifier que si un pion peut capturer un pion adverse, alors le pion adverse est capturé (il n'est plus owner du square c'est le piont gagnant). ✅  

### _Checking boundary cases (B)_

- Nous allons vérifier qu'un pion ne peut pas sortir de la grille. ✅  

- Nous allons vérifier qu'un pion ne pas passer sur des cases ou il y a des pions (à l'exception d'un pion adverse en diagonal). ✅  


### _Checking inverse conditions (I)_

**Feature 1:** Nous allons vérifier que si un pion n'est pas à son premier déplacement, alors il ne peut pas faire plus de 1 déplacement.  ✅   

**Feature 2:** Nous allons vérifier que si un pion est à son premier déplacement, alors il ne peut pas faire plus de 2 déplacement. ✅    

**Feature 3:** Nous allons vérifier qu'un pion ne peut pas avancer en diagonal s'il ne peut pas capturer de pion adverse. ✅  


### _check error conditions (E)_

**Vérification des actions illégales :** 
- Vérifier qu'un pion ne peut pas reculer (mouvement en arrière est interdit)

- Vérifier que la capture "en passant" ne peut se produire que si le pion adverse a avancé de 2 cases lors de son dernier mouvement.

- Vérifier qu'il est impossible d'utiliser la capture "en passant" si l'adversaire n'a pas déplacé son pion immédiatement avant.
check complex cases (e.g. exceptions)


## Summury : 

### Look up on code coverage 
###

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