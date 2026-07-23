package intellectorboard.primitives.hex;

import intellectorboard.primitives.piece.PieceData;
import intellectorboard.primitives.piece.PieceColor;
import intellectorboard.primitives.piece.PieceKind;
import intellectorboard.primitives.hex.Hex;

@:using(intellectorboard.primitives.hex.Hex.HexExtension)
enum Hex
{
    Empty;
    Occupied(piece:PieceData);
}

class HexExtension
{
    public static function type(hex:Hex):Null<PieceKind>
    {
        return switch hex
        {
            case Empty: null;
            case Occupied(piece): piece.type;
        }
    }

    public static function color(hex:Hex):Null<PieceColor>
    {
        return switch hex
        {
            case Empty: null;
            case Occupied(piece): piece.color;
        }
    }

    public static function piece(hex:Hex):Null<PieceData>
    {
        return switch hex
        {
            case Empty: null;
            case Occupied(piece): piece;
        }
    }

    public static function isEmpty(hex:Hex):Bool
    {
        return hex.match(Empty);
    }

    public static function isEqualTo(hex:Hex, otherHex:Hex):Bool
    {
        return switch hex
        {
            case Empty: otherHex.isEmpty();
            case Occupied(piece): piece.color == otherHex.color() && piece.type == otherHex.type();
        }
    }
}
