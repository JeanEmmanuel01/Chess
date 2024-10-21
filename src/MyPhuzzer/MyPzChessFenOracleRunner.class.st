Class {
	#name : 'MyPzChessFenOracleRunner',
	#superclass : 'PzBlockRunner',
	#category : 'MyPhuzzer-Runners',
	#package : 'MyPhuzzer',
	#tag : 'Runners'
}

{ #category : 'running' }
MyPzChessFenOracleRunner >> basicRunOn: input [

	^ self block value: (MyFENParser parse:input). 
]

{ #category : 'running' }
MyPzChessFenOracleRunner >> checkChessFenString: input [

    | client jsonResponse parsedResponse isValid |
    
        client := ZnClient new.
        client 
            url: 'http://127.0.0.1:8000/validate_fen/'; 
            entity: (ZnEntity 
                        with: (self createFENBody: input) 
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
	| result oracleResponse|
	oracleResponse := self checkChessFenString: input.
	
	[result := self basicRunOn: input]
		on: Error
		do: [ :err | 
			(expectedException notNil and: [ expectedException handles: err ])
					ifTrue: [ 
						oracleResponse 
							ifTrue: [ ^ self failureWith: {input . err freeze . ' Oracle had validated Fen'} ] 
							ifFalse: [ ^ self expectedFailureWith: {input . err freeze . ' Oracle had not validated Fen too'} ]  ].
			^ oracleResponse 
					ifTrue: [ self failureWith: {input . err freeze . ' Oracle had validated Fen'} ] 
					ifFalse: [ self failureWith: {input . err freeze . ' Oracle had not validated Fen too'} ]  ].
	
	^ (oracleResponse) 
				ifTrue: [ ^ self successWith: {input . 'Oracle validated'} ] 
				ifFalse: [ self failureWith: {input . 'Oracle invalidated'} ] .
]
