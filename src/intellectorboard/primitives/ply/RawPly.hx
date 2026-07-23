package intellectorboard.primitives.ply;

import intellectorboard.primitives.piece.PieceKind;
import intellectorboard.primitives.hex.HexCoords;

class RawPly
{
    public var from:HexCoords;
    public var to:HexCoords;
    public var morphInto:Null<PieceKind>;

    public static function construct(from:HexCoords, to:HexCoords, ?morphInto:Null<PieceKind>)
    {
        var ply:RawPly = new RawPly();
        ply.from = from;
        ply.to = to;
        ply.morphInto = morphInto;
        return ply;
    }

    public function modifiedHexes():Array<HexCoords>
    {
        return [from.copy(), to.copy()];
    }

    public function copy():RawPly
    {
        return construct(this.from, this.to, this.morphInto);
    }

    public function equals(p:RawPly):Bool
    {
        return this.from == p.from && this.to == p.to && this.morphInto == p.morphInto;
    }

    public function new()
    {

    }
}
