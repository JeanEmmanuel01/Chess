# Task 2 Deliverables : Mutation testing

## Introduction

Nous allons nous concentrer sur la classe MyPawn car ...

```smalltalk
testCases :=  { MyPawnTest }.
classesToMutate := { MyPawn }.

analysis := MTAnalysis new
    testClasses: testCases;
    classesToMutate: classesToMutate.

analysis run.
```

# Mutation Analysis 

```smalltalk
analysis generalResult mutationScore
```
## Initial Mutiation Score 

**Mutation Score:** `90`  
Nous avons 90% des mutants qui ont été tués, avec 160 mutants crée, 145 mutants ont été tués et 15 ont survécu.

### Alive Mutant Analysis
- Nous avons pu tuer tous les mutants et parmis eux voici ce qui étaient les plus complexes
- Nous n'avons pas pu tuer ces mutants parce que.

# Pour moi
nous allons analyser les 15 mutations survivantes : 
1. La première mutation indique que je n'ai pas testé le cas où l'on souhaitait avancé en diagonale mais les cases étaient occupées par des pions de la même équipe : 
![alt text](image.png)

En regroupant les méthodes qui avaient le plus de mutants, ...

```smalltalk
((analysis generalResult aliveMutants)
	groupedBy: [ :m |m mutant originalMethod ])
		associations sorted: [ :a :b | a value size > b value size ]
```

## Mutiation Score after adding test
