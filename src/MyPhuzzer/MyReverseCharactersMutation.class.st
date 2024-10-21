Class {
	#name : 'MyReverseCharactersMutation',
	#superclass : 'Object',
	#category : 'MyPhuzzer-Core',
	#package : 'MyPhuzzer',
	#tag : 'Core'
}

{ #category : 'mutating' }
MyReverseCharactersMutation >> mutate: aString [

| index1 index2 tmp reversedSubstring |
index1 := aString size atRandom.
index2 := aString size atRandom.

(index1 = index2) ifTrue: [^aString].
(index1 < index2) ifFalse: [ tmp := index1. index1 := index2. index2 := tmp. ].

reversedSubstring := (aString copyFrom: index1 to: index2) reversed.

^ (aString copyFrom: 1 to: index1 - 1), reversedSubstring, (aString copyFrom: index2 + 1 to: aString size)

]
