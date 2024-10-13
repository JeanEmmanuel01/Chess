from fastapi import FastAPI
from pydantic import BaseModel
import chess

app = FastAPI()

# Modèle de requête
class FENRequest(BaseModel):
    fen: str

@app.post("/validate_fen/")
async def validate_fen(fen_request: FENRequest):
    fen = fen_request.fen
    try:
        #Le FEN est pas valide
        board = chess.Board(fen)
        return {"fen": fen, "valid": True}
    except ValueError:
        #Le FEN n'est pas valide
        return {"fen": fen, "valid": False}

