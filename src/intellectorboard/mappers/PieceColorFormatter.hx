package intellectorboard.mappers;

import intellectorboard.primitives.piece.PieceColor;

class PieceColorFormatter
{
    public static inline function toLetter(color:PieceColor)
    {
        return color == White? "w" : "b";
    }

    public static inline function fromLetter(letter:String):Null<PieceColor>
    {
        return switch letter {
            case "w": White;
            case "b": Black;
            default: null;
        }
    }
}
