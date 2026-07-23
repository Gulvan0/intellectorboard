package intellectorboard.position;

import intellectorboard.primitives.piece.PieceData;
import intellectorboard.primitives.hex.HexCoords;

class OccupiedHexData
{
    public final coords:HexCoords;
    public final scalarCoord:Int;
    public final piece:PieceData;

    public function new(coords:HexCoords, piece:PieceData)
    {
        this.coords = coords;
        this.scalarCoord = coords.toScalarCoord();
        this.piece = piece;
    }
}
