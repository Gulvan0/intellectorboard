package intellectorboard.mappers;

import intellectorboard.primitives.piece.PieceKind;

class PieceKindFormatter
{
    public static inline function toLetter(type:PieceKind)
    {
        return type.getName().charAt(1);
    }

    public static inline function fromLetter(letter:String):Null<PieceKind>
    {
        return switch letter {
            case "r": Progressor;
            case "g": Aggressor;
            case "o": Dominator;
            case "e": Defensor;
            case "i": Liberator;
            case "n": Intellector;
            default: null;
        }
    }
}
