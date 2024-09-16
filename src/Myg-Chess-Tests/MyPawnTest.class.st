"
A MyPawnTest is a test class for testing the behavior of MyPawn
"
Class {
	#name : 'MyPawnTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'running' }
MyPawnTest >> setUp [
	super setUp.
]

{ #category : 'tests' }
MyPawnTest >> testFirstMoveOnSecond [

	| pawn board squareE4 |
	"Context"
	"board := MyChessBoard empty ."
	board := MyChessBoard empty .
	board at: 'e2' put: (pawn := MyPawn white).
	
	"Stimuli"
	squareE4 := board at: 'e4'.
	board game move: pawn to: squareE4.

	"Check"
	self assert: squareE4 hasPiece equals: true.
	self assert: squareE4 piece equals: pawn
]

{ #category : 'tests' }
MyPawnTest >> testFirstMoveOnSecondSquare [
	| pawn board squareE4 |
	
	"Context"
	board := MyChessBoard empty game:MyChessGame freshGame.
	pawn := board at: 'e2' contents.
	
	
	"Stimuli"
	squareE4 := board at: 'e4'.
	board game move: pawn to: squareE4.
	
	"Check"
	self assert: squareE4 hasPiece equals: true.
	self assert: squareE4 piece equals: pawn.
	
	
]

{ #category : 'tests' }
MyPawnTest >> testId [
	self assert: MyPawn new id equals: 'P'.
	

	
]

{ #category : 'tests' }
MyPawnTest >> testPossibleMoves [
	| pawn squares board |
	
	"Context"
	board := MyChessBoard empty.
	board at: 'e2' put: (pawn := MyPawn white).
	
	"Stimuli"
	squares := pawn targetSquares.
	
	"Check"
	self
		assertCollection: squares
		includesAll: (#( e3 e4 ) collect: [ :name | board at: name ])
]
