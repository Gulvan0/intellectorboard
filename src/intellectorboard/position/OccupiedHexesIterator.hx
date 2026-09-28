package intellectorboard.position;

import intellectorboard.primitives.hex.HexCoordsIterator;

class OccupiedHexesIterator
{
    private var position:Position;
    private var hexCoordsIterator:HexCoordsIterator = new HexCoordsIterator();
    private var currentHex:Null<OccupiedHexData> = null;

    public function new(position:Position)
    {
        this.position = position;
    }

    private function retrieveNextHex():Null<OccupiedHexData>
    {
        for (coords in hexCoordsIterator)
            switch position.get(coords)
            {
                case Occupied(piece):
                    return new OccupiedHexData(coords, piece);
                default:
            }
        return null;
    }

    public function hasNext():Bool
    {
        currentHex ??= retrieveNextHex();
        return currentHex != null;
    }

    public function next():OccupiedHexData
    {
        var returnedHex:OccupiedHexData = currentHex ?? retrieveNextHex();
        currentHex = null;
        return returnedHex;
    }

    public function iterator():Iterator<OccupiedHexData>
    {
        return this;
    }
}
