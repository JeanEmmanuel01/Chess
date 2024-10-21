Class {
	#name : 'MySwapCharactersMutation',
	#superclass : 'Object',
	#category : 'MyPhuzzer-Core',
	#package : 'MyPhuzzer',
	#tag : 'Core'
}

{ #category : 'mutating' }
MySwapCharactersMutation >> mutate: aString [

| index1 index2 tmp |

index1 := aString size atRandom.
index2 := aString size atRandom.

(index1 = index2) ifTrue: [^aString].
	
(index1 < index2)
    ifFalse: [ tmp := index1. index1 := index2. index2 := tmp.].

^ (aString copyFrom: 1 to: index1 - 1), (aString at: index2) asString, 
    	(aString copyFrom: index1 + 1 to: index2 - 1), (aString at: index1) asString, 
    		(aString copyFrom: index2 + 1 to: aString size)
]
