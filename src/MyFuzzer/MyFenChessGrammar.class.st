Class {
	#name : 'MyFenChessGrammar',
	#superclass : 'GncBaseGrammar',
	#instVars : [
		'ntSeparator',
		'ntFen',
		'ntRow',
		'ntWhitePieces',
		'ntBlackPieces',
		'ntWhitePiece',
		'ntBlackPiece',
		'ntRows',
		'ntTurn',
		'ntBlackOrWhitePiece',
		'ntMoreWhite',
		'ntMoreBlack',
		'ntRockRule'
	],
	#category : 'MyFuzzer',
	#package : 'MyFuzzer'
}

{ #category : 'initialization' }
MyFenChessGrammar >> defineGrammar [
  
	super defineGrammar.
	
	ntSeparator --> '/'.
	ntTurn --> 'w'| 'b'.
	ntWhitePiece --> 'R'|'N'|'B'|'Q'|'K'.
	ntBlackPiece --> 'r'|'n'|'b'|'q'|'k'.
	ntBlackOrWhitePiece --> ntBlackPiece | ntWhitePiece.
	
	ntRockRule --> 'KQkq'.
	ntMoreWhite  --> ntWhitePiece | ntBlackPiece | ntWhitePiece.
	ntMoreBlack  --> ntWhitePiece | ntBlackPiece | ntBlackPiece.
	
	ntWhitePieces --> ntMoreWhite, ntMoreWhite, ntMoreWhite, ntMoreWhite, ntMoreWhite, ntMoreWhite,           ntMoreWhite, ntMoreWhite.
	
	ntBlackPieces --> ntMoreBlack, ntMoreBlack, ntMoreBlack, ntMoreBlack, ntMoreBlack, ntMoreBlack,           ntMoreBlack, ntMoreBlack.
	
	ntRow --> '8' | '7', ntBlackOrWhitePiece | ($1 - $5), ntBlackOrWhitePiece,($1 - $2) |                      ntBlackOrWhitePiece,'7' | ntWhitePieces | ntBlackPieces.
				
	ntRows --> ntSeparator , ntRow .

	
	ntFen --> ntBlackPieces, ntRows,ntRows,ntRows,ntRows,ntRows,ntRows,
	ntSeparator,ntWhitePieces,' ',ntTurn,' ',ntRockRule,' ', '-', ' ', ($0 - $1),' ',($1 - $2) .
	
	
	^ ntFen
]
