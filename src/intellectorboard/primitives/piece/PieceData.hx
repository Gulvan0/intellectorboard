package intellectorboard.primitives.piece;

class PieceData
{
    public final type:PieceKind;
    public final color:PieceColor;

    public function equals(other:PieceData):Bool
    {
        return this.type == other.type && this.color == other.color;
    }

    public function new(type:PieceKind, color:PieceColor)
    {
        if (type == null || color == null)
            throw "type/color can't be null";
        this.type = type;
        this.color = color;
    }
}
