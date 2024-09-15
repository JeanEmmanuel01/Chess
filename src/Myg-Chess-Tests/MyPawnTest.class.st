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
	"Put here a common initialization logic for tests"
]

{ #category : 'tests' }
MyPawnTest >> testFirstMove [
	| pawn squares board |
	
	"Context"
	board := MyChessBoard empty.
	board at: 'e2' put: (pawn := MyPawn white).
	
	"Stimuli"
	 pawn renderPieceOn: (board at: 'e4').
	
	""
	
	"Stimuli"
	
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
