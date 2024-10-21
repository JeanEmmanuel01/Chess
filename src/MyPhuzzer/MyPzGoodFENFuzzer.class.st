Class {
	#name : 'MyPzGoodFENFuzzer',
	#superclass : 'PzFuzzer',
	#instVars : [
		'fens'
	],
	#category : 'MyPhuzzer-Core',
	#package : 'MyPhuzzer',
	#tag : 'Core'
}

{ #category : 'initialization' }
MyPzGoodFENFuzzer >> fuzz [ 

^ fens at: (random nextInteger: fens size )
]

{ #category : 'initialization' }
MyPzGoodFENFuzzer >> initialize [ 	
	super initialize.
	fens := { 
		'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' .
		'r1bqkbnr/pppppppp/n7/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' .
		'rnbqkbnr/pppppppp/8/4p3/8/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2' .
		'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1' .
		'rnbqkbnr/ppp1pppp/8/3p4/8/5N2/PPPPPPPP/RNBQKB1R b KQkq - 1 2' .
		'rnbqkbnr/ppp2ppp/4p3/3p4/8/2N5/PPPPPPPP/R1BQKBNR b KQkq - 0 3' .
		'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 1 1' .
		'rnbqkb1r/pppppppp/5n2/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 2 3' .
		'rnbqkbnr/pppp1ppp/8/4p3/8/8/PPPPPPPP/RNBQKBNR w KQkq e6 0 2' .
		'rnb1kbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1' .

		'rnbqkb1r/pppppppp/8/4N3/8/8/PPPPPPPP/RNBQKB1R b KQkq - 0 3' .
		'rnbqkb1r/pppppppp/5n2/8/3P4/5N2/PPP1PPPP/RNBQKB1R b KQkq - 0 5' .
		'r1bqkbnr/pppppppp/2n5/8/8/5N2/PPPPPPPP/RNBQKB1R w KQkq - 2 3' .
		'rnbqkb1r/pppppppp/8/8/8/5N2/PPPPPPPP/RNBQKB1R w KQkq - 0 2' .
		'rnbqkbnr/pppppppp/8/3P4/8/8/PPP1PPPP/RNBQKBNR b KQkq - 0 2' .
		'rnbqkbnr/pppp1ppp/8/4p3/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 0 3' .
		'rnbqkbnr/pppppppp/8/8/3P4/8/PP1PPPPP/RNBQKBNR b KQkq - 0 2' .
		'rnbqkbnr/pppp1ppp/4p3/8/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 0 4' .
		'rnbqkbnr/pppppppp/8/3P4/8/8/PPP1PPPP/RNBQKBNR b KQkq - 0 2' .
		'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1'
	}.

]
