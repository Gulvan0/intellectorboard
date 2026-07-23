package intellectorboard.primitives.hex;

class HexCoordsIterator
{
    private var scalarCoord:Int = 0;

    public function new()
    {

    }

    public function hasNext():Bool
    {
        return scalarCoord <= HexCoords.MAX_SCALAR_COORD;
    }

    public function next():HexCoords
    {
        return HexCoords.fromScalarCoord(scalarCoord++);
    }
}
