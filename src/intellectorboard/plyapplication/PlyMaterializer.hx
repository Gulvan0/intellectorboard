package intellectorboard.plyapplication;

import intellectorboard.primitives.piece.PieceData;
import intellectorboard.position.PieceArrangement;
import intellectorboard.primitives.ply.RawPly;

class PlyMaterializer
{
    public static function materialize(ply:RawPly, pieces:PieceArrangement):MaterializedPly
    {
        var movingPiece:PieceData = pieces.pieceAt(ply.from);
        var targetPiece:Null<PieceData> = pieces.pieceAt(ply.to);

        if (movingPiece == null)
            throw "Ply materialization failed: departure hex is empty";

        if (targetPiece != null)
            if (movingPiece.color == targetPiece.color)
                if (movingPiece.type == Intellector)
                    return Castling(ply.from, ply.to);
                else
                    return Castling(ply.to, ply.from);
            else if (ply.morphInto == null)
                return NormalCapture(ply.from, ply.to, movingPiece.type, targetPiece.type);
            else if (movingPiece.type == Progressor)
                return PromotionWithCapture(ply.from, ply.to, targetPiece.type, ply.morphInto);
            else
                return ChameleonCapture(ply.from, ply.to, movingPiece.type, targetPiece.type);
        else if (ply.morphInto != null)
            return Promotion(ply.from, ply.to, ply.morphInto);
        else
            return NormalMove(ply.from, ply.to, movingPiece.type);
    }
}
