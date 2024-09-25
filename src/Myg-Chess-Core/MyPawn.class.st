Class {
	#name : 'MyPawn',
	#superclass : 'MyPiece',
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'accessing' }
MyPawn >> id [

	^ 'P'
]

{ #category : 'initialization' }
MyPawn >> initialize [

	super initialize.
	
	
]

{ #category : 'accessing' }
MyPawn >> isFirstStep [
    ^(self isWhite 
        ifTrue: [ (square name findString: '2' ) > 0 ] 
        ifFalse: [ (square name findString: '7' ) > 0 ]).

]

{ #category : 'path commands' }
MyPawn >> moveTo: aSquare [

	super moveTo: aSquare.
	self isFirstStep ifTrue: [ self isFirstStep: false ].
	
]

{ #category : 'as yet unclassified' }
MyPawn >> possibleDiagonalMove [
	"return an array of squares"
	| squareLeft squareRight |
	
	squareLeft := self isWhite ifTrue: [square up left] ifFalse: [square down right].
	squareRight := self isWhite ifTrue: [square up right] ifFalse: [square down left].
	
	^( 
		(Array with: squareLeft with:squareRight) 
				select:[ :s | s notNil and: [s hasPiece and: [ s contents color ~= color ]] ]  ).
]

{ #category : 'as yet unclassified' }
MyPawn >> possibleStraightAheadMoves [
	"return an array of squares"
		
	^(self isFirstStep ifTrue: 
							[self isWhite ifTrue: [{square up . square up up}] ifFalse: [{square down . square down down}]] 
					ifFalse: 
							[self isWhite ifTrue: [{square up}] ifFalse: [{square down}]]).
]

{ #category : 'rendering' }
MyPawn >> renderPieceOn: aSquare [ 
	
	^ aSquare renderPawn: self
]

{ #category : 'rendering' }
MyPawn >> targetSquaresLegal: aBoolean [
	|  possibleMoves |
	
	possibleMoves := ( self possibleStraightAheadMoves, self possibleDiagonalMove ) 
			select: [ :s |
		  		s notNil and: [
			  			s hasPiece not or: [ s contents color ~= color ] ] ].
	
	^possibleMoves .
]
