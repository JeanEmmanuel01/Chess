"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestMyPhuzzer',
	#superclass : 'PackageManifest',
	#category : 'MyPhuzzer-Manifest',
	#package : 'MyPhuzzer',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestMyPhuzzer class >> ruleCodeCruftLeftInMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#MyPzChessFenOracleRunner #value: #false)) #'2024-10-11T14:09:41.482406+02:00') )
]
