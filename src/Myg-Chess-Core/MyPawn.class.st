Class {
	#name : 'MyPawn',
	#superclass : 'MyPiece',
	#instVars : [
		'isFirstStep'
	],
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
	
	isFirstStep := true.
	
	
]

{ #category : 'accessing' }
MyPawn >> isFirstStep [
	
	^isFirstStep 
]

{ #category : 'accessing' }
MyPawn >> isFirstStep: aBoolean [
   isFirstStep := aBoolean.

]

{ #category : 'path commands' }
MyPawn >> moveTo: aSquare [

	super moveTo: aSquare.
	self isFirstStep ifTrue: [ self isFirstStep: false ].
	
]

{ #category : 'as yet unclassified' }
MyPawn >> possibleMovesStraightAhead [
	"return an array of squares"
		
	^(isFirstStep ifTrue: 
							[self isWhite ifTrue: [{square up}] ifFalse: [{square down}]] 
					ifFalse: 
							[self isWhite ifTrue: [{square up . square up}] ifFalse: [{square down . square down}]]).
]

{ #category : 'rendering' }
MyPawn >> renderPieceOn: aSquare [ 
	
	^ aSquare renderPawn: self
]

{ #category : 'rendering' }
MyPawn >> targetSquaresLegal: aBoolean [
	|  possibleMoves |
	
	possibleMoves := ( self possibleMovesStraightAhead ) 
			select: [ :s |
		  		s notNil and: [
			  			s hasPiece not or: [ s contents color ~= color ] ] ].
	
	^possibleMoves .
]
