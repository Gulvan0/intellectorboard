package intellectorboard.plyapplication;

import intellectorboard.primitives.piece.PieceKind;
import intellectorboard.primitives.hex.HexCoords;
import intellectorboard.primitives.ply.RawPly;
import intellectorboard.position.Position;

@:using(intellectorboard.plyapplication.MaterializedPly.MaterializedPlyExtension)
enum MaterializedPly
{
    NormalMove(from:HexCoords, to:HexCoords, movingPiece:PieceKind);
    NormalCapture(from:HexCoords, to:HexCoords, capturingPiece:PieceKind, capturedPiece:PieceKind);
    ChameleonCapture(from:HexCoords, to:HexCoords, capturingPiece:PieceKind, capturedPiece:PieceKind);
    Promotion(from:HexCoords, to:HexCoords, promotedTo:PieceKind);
    PromotionWithCapture(from:HexCoords, to:HexCoords, capturedPiece:PieceKind, promotedTo:PieceKind);
    Castling(oldIntellectorCoords:HexCoords, newIntellectorCoords:HexCoords);
}

class MaterializedPlyExtension
{
    public static function isEqualTo(ply1:MaterializedPly, ply2:MaterializedPly):Bool
    {
        return switch [ply1, ply2]
        {
            case [NormalMove(from, to, movingPiece), NormalMove(from2, to2, movingPiece2)]:
                from.equals(from2) && to.equals(to2) && movingPiece == movingPiece2;
            case [NormalCapture(from, to, capturingPiece, capturedPiece), NormalCapture(from2, to2, capturingPiece2, capturedPiece2)]:
                from.equals(from2) && to.equals(to2) && capturingPiece == capturingPiece2 && capturedPiece == capturedPiece2;
            case [ChameleonCapture(from, to, capturingPiece, capturedPiece), ChameleonCapture(from2, to2, capturingPiece2, capturedPiece2)]:
                from.equals(from2) && to.equals(to2) && capturingPiece == capturingPiece2 && capturedPiece == capturedPiece2;
            case [Promotion(from, to, promotedTo), Promotion(from2, to2, promotedTo2)]:
                from.equals(from2) && to.equals(to2) && promotedTo == promotedTo2;
            case [PromotionWithCapture(from, to, capturedPiece, promotedTo), PromotionWithCapture(from2, to2, capturedPiece2, promotedTo2)]:
                from.equals(from2) && to.equals(to2) && promotedTo == promotedTo2 && capturedPiece == capturedPiece2;
            case [Castling(from, to), Castling(from2, to2)]:
                from.equals(from2) && to.equals(to2);
            default:
                false;
        }
    }

    public static function affectedCoords(ply:MaterializedPly):Array<HexCoords>
    {
        switch ply
        {
            case NormalMove(from, to, _), NormalCapture(from, to, _, _), ChameleonCapture(from, to, _, _), Promotion(from, to, _), PromotionWithCapture(from, to, _, _), Castling(from, to):
                return [from, to];
        }
    }

    public static function isFatum(ply:MaterializedPly):Bool
    {
        return switch ply
        {
            case NormalCapture(_, _, _, capturedPiece), ChameleonCapture(_, _, _, capturedPiece), PromotionWithCapture(_, _, capturedPiece, _):
                capturedPiece == Intellector;
            default:
                false;
        }
    }

    public static function isBreakthrough(ply:MaterializedPly, position:Position):Bool
    {
        return switch ply
        {
            case NormalMove(from, to, movingPiece):
                movingPiece == Intellector && to.isFinal(position.turnColor);
            case Castling(from, to):
                to.isFinal(position.turnColor);
            default:
                false;
        }
    }

    public static function isProgressive(ply:MaterializedPly):Bool
    {
        return switch ply
        {
            case NormalMove(_, _, movingPiece):
                movingPiece == Progressor;
            case NormalCapture(_, _, _, _), ChameleonCapture(_, _, _, _), Promotion(_, _, _), PromotionWithCapture(_, _, _, _):
                true;
            case Castling(_, _):
                false;
        }
    }

    public static function isCapture(ply:MaterializedPly):Bool
    {
        return ply.match(NormalCapture(_, _, _, _) | ChameleonCapture(_, _, _, _) | PromotionWithCapture(_, _, _, _));
    }

    public static function toRaw(ply:MaterializedPly):RawPly
    {
        return switch ply
        {
            case NormalMove(from, to, _), NormalCapture(from, to, _, _), Castling(from, to):
                RawPly.construct(from, to);
            case ChameleonCapture(from, to, _, morphInto), Promotion(from, to, morphInto), PromotionWithCapture(from, to, _, morphInto):
                RawPly.construct(from, to, morphInto);
        }
    }
}
