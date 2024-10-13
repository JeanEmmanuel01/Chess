Class {
	#name : 'MyDateGrammar',
	#superclass : 'GncBaseGrammar',
	#instVars : [
		'ntDate',
		'ntDay',
		'ntSeparator',
		'ntMonth',
		'ntYear'
	],
	#category : 'MyFuzzer',
	#package : 'MyFuzzer'
}

{ #category : 'initialization' }
MyDateGrammar >> defineGrammar [
  "The superclass defines how to generate numbers"
	super defineGrammar.

	ntDate --> ntDay , ntSeparator , ntMonth , ntSeparator , ntYear.
	ntSeparator --> '-'.
	ntDay --> ntNumber.
	ntMonth --> ntNumber.
	ntYear --> ntNumber.
	^ ntDate
]
