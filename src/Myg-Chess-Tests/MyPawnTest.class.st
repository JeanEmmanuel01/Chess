"
A MyPawnTest is a test class for testing the behavior of MyPawn
"
Class {
	#name : 'MyPawnTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyPawnTest >> setDiagonalSituation: pawnWhite a: pawnBlack b: board [

	board game move: pawnWhite to: (board at: 'd4').
	board game move: pawnBlack to: (board at: 'e5')
]

{ #category : 'running' }
MyPawnTest >> setUp [
	super setUp.
]

{ #category : 'tests' }
MyPawnTest >> testDiagonalMoveIfCanCapture [

	| board pawnWhite pawnBlack targetSquare|
	
	"Context"
	board := MyChessGame freshGame board.
	pawnWhite := (board at: 'd2') contents.
	pawnBlack := (board at: 'e7') contents.
	
	"Stimuli"
		self setDiagonalSituation: pawnWhite a: pawnBlack b: board.
		targetSquare := pawnWhite square up right. "Test white only"
		board game move: pawnWhite to: (targetSquare).
	
	"Check"
		self assert: targetSquare hasPiece equals: true.
		self assert: targetSquare contents equals: pawnWhite.
		
]

{ #category : 'tests' }
MyPawnTest >> testDiagonalPossibleMoveIfCanCapture [

	| board pawnWhite pawnBlack blackSquares whiteSquares |
	"Context""Stimuli""Possible moves Tests""Check"
	board := MyChessGame freshGame board.
	pawnWhite := (board at: 'd2') contents.
	pawnBlack := (board at: 'e7') contents.
	self setDiagonalSituation: pawnWhite a: pawnBlack b: board.
	whiteSquares := pawnWhite targetSquares.
	blackSquares := pawnBlack targetSquares.
	self
		assertCollection: whiteSquares , blackSquares
		includesAll:
		(#( #d5 #e5 #e4 #d4 ) collect: [ :name | board at: name ])
]

{ #category : 'tests' }
MyPawnTest >> testFirstMoveOnFirstSquare [
	| pawn board squareE3 |
	
	"Context"
	board := MyChessGame freshGame board.
	pawn := (board at: 'e2') contents.
	
	"Stimuli"
	squareE3 := board at: 'e3'.
	board game move: pawn to: squareE3.
	
	"Check"
	self assert: squareE3 hasPiece equals: true.
	self assert: squareE3 contents equals: pawn.
	
	
]

{ #category : 'tests' }
MyPawnTest >> testFirstMoveOnSecondSquare [
	| pawn board squareE4 |
	
	"Context"
	board := MyChessGame freshGame board.
	pawn := (board at: 'e2') contents.
	
	"Stimuli"
	squareE4 := board at: 'e4'.
	board game move: pawn to: squareE4.
	
	"Check"
	self assert: squareE4 hasPiece equals: true.
	self assert: squareE4 contents equals: pawn.
	
	
]

{ #category : 'tests' }
MyPawnTest >> testId [
	self assert: MyPawn new id equals: 'P'.
	

	
]

{ #category : 'tests' }
MyPawnTest >> testPossibleMovesIfFirstMove [
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

{ #category : 'tests' }
MyPawnTest >> testPossibleMovesIfNotFirstMove [
	| pawn squares board |
	
	"Context"
	board := MyChessGame freshGame board.
	pawn := (board at: 'e2') contents.
	
	"Stimuli"
	
	board game move: pawn to: (board at: 'e3').
	
	squares := pawn targetSquares.
	
	"Check"
	self
		assertCollection: squares
		includesAll: (#( e4 ) collect: [ :name | board at: name ])
]
