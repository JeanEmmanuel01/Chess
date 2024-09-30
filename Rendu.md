# Projet : Myg Chess Game

### Autheur :
_**Nom :** Ehuy Jean Emmanuel  **Email** : jeanemmanuelkarld.ehuy.etu@univ-lille.fr_  

**Date : 15/09/2024**

# Introduction

Ce projet à pour but de réaliser l'amélioration d'un jeu d'échec en se basant sur des pratiques de génie logiciels notamment par de l'évolution de tests et la mise en place de refactoring.

# How to

## Chargement du projet : 

```smalltalk
Metacello new
	repository: 'github://JeanEmmanuel01/Chess:main';
	baseline: 'MygChess';
	onConflictUseLoaded;
	load.
```

## Lancement du jeu d'échec :

```smalltalk
board := MyChessGame freshGame.
board size: 800@600.
space := BlSpace new.
space root addChild: board.
space pulse.
space resizable: true.
space show.
```
## Installation de Mutalk :

```smalltalk
Deprecation activateTransformations: false.
Metacello new
  baseline: 'MuTalk';
  repository: 'github://pharo-contributions/mutalk:v2.5.0/src';
  load.
Metacello new
  baseline: 'AVLTesting';
  repository: 'github://avl-univ-lille/practice';
  load.
```


### Task Deliverables :

- Livrable 1 : 
  - documentation : [Task1.md](./tasks_deliverables/Task1.md)
  - Lien Git du livrable : TODO
- Livrable 2 :
  - documentation : [Task2.md](./tasks_deliverables/Task2.md)

