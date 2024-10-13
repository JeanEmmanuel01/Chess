Class {
	#name : 'MyPzChessFenOracleRunner',
	#superclass : 'PzBlockRunner',
	#category : 'MyPhuzzer-Runners',
	#package : 'MyPhuzzer',
	#tag : 'Runners'
}

{ #category : 'running' }
MyPzChessFenOracleRunner >> basicRunOn: input [

|result|

result := (self checkChessFenString: (self createFENBody: input)).

	^ self block value: result.
]

{ #category : 'running' }
MyPzChessFenOracleRunner >> checkChessFenString: input [

    | client jsonResponse parsedResponse isValid |
    
        client := ZnClient new.
        client 
            url: 'http://127.0.0.1:8000/validate_fen/'; 
            entity: (ZnEntity 
                        with: input 
                        type: ZnMimeType applicationJson).
        client post.

        client isSuccess ifTrue: [ 
            jsonResponse := client response entity contents.
            parsedResponse := NeoJSONReader fromString: jsonResponse.
            isValid := parsedResponse at: 'valid' ifAbsent: [ false ].
            ^ isValid.
        ].

        ^ false.  

]

{ #category : 'running' }
MyPzChessFenOracleRunner >> createFENBody: input [
    ^ ('{"fen": "', input, '"}').
]

{ #category : 'running' }
MyPzChessFenOracleRunner >> value: input [
	| result |
	
	[ result := self basicRunOn: input ]
		on: Error
		do: [ :err | 
			(expectedException notNil and: [ expectedException handles: err ])
					ifTrue: [ ^ self expectedFailureWith: {input . err freeze} ].
			^ self failureWith: {input . err freeze} ].
	
	^ result 
				ifTrue: [ ^ self successWith: {input . 'Oracle validated' . 'isValid' . result} ] 
				ifFalse: [ self failureWith: {input . 'Oracle invalidated'} ] .
]
