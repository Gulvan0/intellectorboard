package intellectorboard.primitives.hex;

import intellectorboard.primitives.piece.PieceColor;

class HexCoords
{
    public final i:Int;
    public final j:Int;

    public static inline final MAX_SCALAR_COORD:Int = 58;

    public static function areEqual(coords1:Null<HexCoords>, coords2:Null<HexCoords>):Bool
    {
        if (coords1 == null)
            return coords2 == null;
        else if (coords2 == null)
            return false;
        else
            return coords1.equals(coords2);
    }

    public function toRelative(color:PieceColor):HexCoords
    {
        return color == White? copy() : invert();
    }

    public function invert():HexCoords
    {
        return new HexCoords(8 - i, 6 - j - i % 2);
    }

    public function copy():HexCoords
    {
        return new HexCoords(i, j);
    }

    public function isFinal(color:PieceColor):Bool
    {
        if (color == White)
            return j == 0 && i % 2 == 0;
        else
            return j == 6 && i % 2 == 0;
    }

    public function isDark():Bool
    {
        if (j % 3 == 2)
            return false;
        else if (j % 3 == 0)
            return i % 2 == 0;
        else
            return i % 2 == 1;
    }

    public function equals(other:HexCoords):Bool
    {
        return other.i == i && other.j == j;
    }

    public function isValid():Bool
    {
        if (i % 2 == 0)
            return i >= 0 && i <= 8 && j >= 0 && j <= 6;
        else
            return i >= 0 && i <= 8 && j >= 0 && j <= 5;
    }

    public function toScalarCoord():Int
    {
        if (i % 2 == 0)
            return 9 * j + Std.int(i / 2);
        else
            return 9 * j + Std.int(i / 2) + 5;
    }

    public static function fromScalarCoord(t:Int):HexCoords
    {
        var det:Int = t % 9;
        if (det < 5)
            return new HexCoords(det * 2, Std.int(t / 9));
        else
            return new HexCoords(det * 2 - 9, Std.int(t / 9));
    }

    public function new(i:Int, j:Int)
    {
        this.i = i;
        this.j = j;
    }
}
