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
MyPawnTest >> testCannotExceedOneMoveIfAfterFirstMove [

	| board whitePawn blackPawn targetWhiteSquare targetBlackSquare startWhiteSquare startBlackSquare|
	
	"Context"
	board := MyChessGame freshGame board .
													
	whitePawn := (board at: 'e2') contents. 
	blackPawn := (board at: 'h7') contents. 
	
	"Stimuli"
		"White pawn"
		"first move :" board game move: whitePawn to: (whitePawn square up).
		startWhiteSquare := whitePawn square.
		targetWhiteSquare := whitePawn square up up.
		"trying exceed one square :" board game move: whitePawn to: targetWhiteSquare.
		
		"Black pawn : first move"
		"first move :" board game move: blackPawn to: (blackPawn square down).
		startBlackSquare := blackPawn square.
		targetBlackSquare := blackPawn square down down.
		"trying exceed one square :" board game move: blackPawn to: targetBlackSquare.
		
				
	"Check"
	self assert: (whitePawn square ~= targetWhiteSquare and: [whitePawn square = startWhiteSquare]).
	self assert: (blackPawn square ~= targetBlackSquare and: [blackPawn square = startBlackSquare]).
]

{ #category : 'tests' }
MyPawnTest >> testCannotExceedPawnStraightAhead [

	| board whitePawn blackPawn|
	
	"Context"
	board := MyChessGame freshGame board .
													
	whitePawn := (board at: 'b2') contents. 
	blackPawn := (board at: 'b7') contents. 
	
	"Stimuli"
		board game move: whitePawn to: (whitePawn square up up).
		board game move: blackPawn to: (blackPawn square down down).
				
	"Check"
	self assert: whitePawn targetSquares isEmpty.
	self assert: blackPawn targetSquares isEmpty.	
]

{ #category : 'tests' }
MyPawnTest >> testCannotExceedTheGrid [

	| board whitePawn blackPawn|
	
	"Context"
	board := MyChessGame freshGame board .
													
	whitePawn := (board at: 'b2') contents. 
	blackPawn := (board at: 'h7') contents. 
	
	"Stimuli : we move to limit of Grid"
		"White pawn"
		(1 to: 4 do: 
					[:i | board game move: whitePawn to: (whitePawn square up) ]).
		board game move: whitePawn to: (whitePawn square up left).
		board game move: whitePawn to: (whitePawn square up right).
		
		"Black pawn"
		(1 to: 4 do: 
					[:i | board game move: blackPawn to: (blackPawn square down) ]).
		board game move: blackPawn to: (blackPawn square down left).
		board game move: blackPawn to: (blackPawn square down right).
				
	"Check"
	self assert: whitePawn targetSquares isEmpty.
	self assert: blackPawn targetSquares isEmpty.	
]

{ #category : 'tests' }
MyPawnTest >> testCannotExceedTwoMovesIfFirstMove [

	| board whitePawn blackPawn targetWhiteSquare targetBlackSquare startWhiteSquare startBlackSquare|
	
	"Context"
	board := MyChessGame freshGame board .
													
	whitePawn := (board at: 'e2') contents. 
	blackPawn := (board at: 'h7') contents. 
	
	"Stimuli"
		"White pawn"
		
		startWhiteSquare := whitePawn square.
		targetWhiteSquare := whitePawn square up up up.
		"trying exceed two squares :" 
		board game move: whitePawn to: targetWhiteSquare.
		
		"Black pawn"
		startBlackSquare := blackPawn square.
		targetBlackSquare := blackPawn square down down down.
		"trying exceed two squares :
		" board game move: blackPawn to: targetBlackSquare.
		
				
	"Check"
	self assert: (whitePawn square ~= targetWhiteSquare and: [whitePawn square = startWhiteSquare]).
	self assert: (blackPawn square ~= targetBlackSquare and: [blackPawn square = startBlackSquare]).
]

{ #category : 'tests' }
MyPawnTest >> testCannotMoveInDiagonalIfAllyInTargetSquare [

	| board whitePawn blackPawn targetWhiteSquare targetBlackSquare startWhiteSquare startBlackSquare|
	
	"Context"
	board := MyChessGame freshGame board .
													
	whitePawn := (board at: 'e2') contents. 
	blackPawn := (board at: 'd7') contents. 
	
	"Stimuli"
		"White pawn"
		startWhiteSquare := whitePawn square.
		targetWhiteSquare := whitePawn square up left.
		
		"move white ally on targetSquare"
		board game move: ((board at: 'd2') contents) to: targetWhiteSquare.
		
		"trying move in diagonal :" 
		board game move: whitePawn to: targetWhiteSquare.
		
		"Black pawn"
		startBlackSquare := blackPawn square.
		targetBlackSquare := blackPawn square down right.
		
		"move black ally on targetSquare"
		board game move: ((board at: 'e7') contents) to: targetBlackSquare.
		
		"trying move in diagonal :"
		board game move: blackPawn to: targetBlackSquare.
		
				
	"Check"
	self assert: (whitePawn square ~= targetWhiteSquare and: [whitePawn square = startWhiteSquare and: [targetWhiteSquare contents color = whitePawn color]]).
	self assert: (blackPawn square ~= targetBlackSquare and: [blackPawn square = startBlackSquare and: [targetBlackSquare contents color = blackPawn color]]).
]

{ #category : 'tests' }
MyPawnTest >> testCannotMoveInDiagonalIfEmptyTargetSquare [

	| board whitePawn blackPawn targetWhiteSquare targetBlackSquare startWhiteSquare startBlackSquare|
	
	"Context"
	board := MyChessGame freshGame board .
													
	whitePawn := (board at: 'e2') contents. 
	blackPawn := (board at: 'd7') contents. 
	
	"Stimuli"
		"White pawn"
		
		startWhiteSquare := whitePawn square.
		targetWhiteSquare := whitePawn square up left.
		"trying move in diagonal :" 
		board game move: whitePawn to: targetWhiteSquare.
		
		"Black pawn"
		startBlackSquare := blackPawn square.
		targetBlackSquare := blackPawn square down right.
		"trying move in diagonal :"
		board game move: blackPawn to: targetBlackSquare.
		
				
	"Check"
	self assert: (whitePawn square ~= targetWhiteSquare and: [whitePawn square = startWhiteSquare and: [targetWhiteSquare hasPiece not]]).
	self assert: (blackPawn square ~= targetBlackSquare and: [blackPawn square = startBlackSquare and: [targetBlackSquare hasPiece not]]).
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
MyPawnTest >> testPossibleDiagonalMoveIfCanCapture [

	| board pawnWhite pawnBlack blackSquares whiteSquares |
	
	"Context"
	board := MyChessGame freshGame board.
	pawnWhite := (board at: 'd2') contents.
	pawnBlack := (board at: 'e7') contents.
	
	"Stimuli"
	self setDiagonalSituation: pawnWhite a: pawnBlack b: board.
	whiteSquares := pawnWhite targetSquares.
	blackSquares := pawnBlack targetSquares.
	
	"Check"
	self
		assertCollection: whiteSquares , blackSquares
		includesAll:
		(#( #d5 #e5 #e4 #d4 ) collect: [ :name | board at: name ])
]

{ #category : 'tests' }
MyPawnTest >> testPossibleDiagonalMoveReturnsArray [

	| board pawnWhite pawnBlack blackSquares whiteSquares |
	"Context"
	board := MyChessGame freshGame board.
	pawnWhite := (board at: 'd2') contents.
	pawnBlack := (board at: 'e7') contents.
	
	"Stimuli"
	self setDiagonalSituation: pawnWhite a: pawnBlack b: board.
	whiteSquares := pawnWhite possibleDiagonalMove.
	blackSquares := pawnBlack possibleDiagonalMove.
	
	self assert: whiteSquares class equals: Array.
	self assert: blackSquares class equals: Array.
	
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

{ #category : 'tests' }
MyPawnTest >> testRenderPieceOn [
	| board whitePawn blackPawn whiteRender blackRender |
	
	board := MyChessGame freshGame board.
	whitePawn := (board at: 'e2') contents. 
	blackPawn := (board at: 'h7') contents.
	
	whiteRender := whitePawn renderPieceOn: (board at: 'e2').
	blackRender := blackPawn renderPieceOn: (board at: 'h7').
	
	"White pawn on a white square must return 'P', black pawn on a white square 'O'"
	self assert: (whitePawn isWhite and: [whitePawn square color isBlack not and: [whiteRender = 'P']]).
	self assert: (blackPawn isWhite not and: [blackPawn square color isBlack not and: [blackRender = 'O']]).
	
	board game move: whitePawn to: (board at: 'e3').
	board game move: blackPawn to: (board at: 'h6').

	whiteRender := whitePawn renderPieceOn: (board at: 'e3').
	blackRender := blackPawn renderPieceOn: (board at: 'h6').
	
	"A white pawn on a black square must return 'p', a black pawn on a black square 'o'"
	self assert: (whitePawn isWhite and: [whitePawn square color isBlack and: [whiteRender = 'p']]).
	self assert: (blackPawn isWhite not and: [blackPawn square color isBlack and: [blackRender = 'o']]).

]
