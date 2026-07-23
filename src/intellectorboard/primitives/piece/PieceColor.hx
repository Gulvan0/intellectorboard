package intellectorboard.primitives.piece;

@:using(intellectorboard.primitives.piece.PieceColor.PieceColorExtension)
enum PieceColor
{
    White;
    Black;
}

class PieceColorExtension
{
    public static inline function opposite(color:PieceColor):PieceColor
    {
        return color == White? Black : White;
    }
}
