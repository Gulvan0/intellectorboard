package intellectorboard.position;

import intellectorboard.primitives.piece.PieceData;
import intellectorboard.primitives.piece.PieceKind;
import intellectorboard.primitives.hex.HexCoords;
import intellectorboard.primitives.piece.PieceColor;
import intellectorboard.primitives.hex.Hex;
import intellectorboard.mappers.PieceKindFormatter;

class Position
{
    public var pieces:PieceArrangement;
    public var turnColor:PieceColor;

    private static var DEFAULT_STARTING_POSITION_HASH:String = defaultStarting().getHash();

    public static function defaultStarting():Position
    {
        return new Position(PieceArrangement.defaultStarting(), White);
    }

    public static function empty():Position
    {
        return new Position(PieceArrangement.empty(), White);
    }

    public inline function getS(scalarCoord:Int):Hex
    {
        return get(HexCoords.fromScalarCoord(scalarCoord));
    }

    public inline function get(coords:HexCoords):Hex
    {
        return pieces.get(coords);
    }

    public inline function getPiece(coords:HexCoords):Null<PieceData>
    {
        return pieces.pieceAt(coords);
    }

    public inline function set(coords:HexCoords, hex:Hex)
    {
        pieces.set(coords, hex);
    }

    public inline function setPiece(coords:HexCoords, pieceKind:PieceKind, pieceColor:PieceColor)
    {
        pieces.set(coords, Occupied(new PieceData(pieceKind, pieceColor)));
    }

    public inline function swap(coords1:HexCoords, coords2:HexCoords)
    {
        var tmp:Hex = get(coords1);
        set(coords1, get(coords2));
        set(coords2, tmp);
    }

    public function copy(?newTurnColor:PieceColor):Position
    {
        return new Position(pieces.copy(), newTurnColor ?? turnColor);
    }

    /**
     * Whether it's a valid starting position. This holds if and only if both statements are true:
     * 1. There's exactly one Intellector piece for each of the players
     * 2. No Intellector has already reached the final rank
     * @return Bool
     */
    public function isValidStarting():Bool
    {
        var intellectorFound:Map<PieceColor, Bool> = [White => false, Black => false];

        for (hex in new OccupiedHexesIterator(this))
            switch hex.piece.type
            {
                case Intellector:
                    if (hex.coords.isFinal(hex.piece.color) || intellectorFound[hex.piece.color])
                        return false;
                    intellectorFound[hex.piece.color] = true;
                default:
            }

        return intellectorFound[White] && intellectorFound[Black];
    }

    public function countPieces():Int
    {
        return Lambda.count(new OccupiedHexesIterator(this));
    }

    public function isDefaultStarting():Bool
    {
        return getHash() == DEFAULT_STARTING_POSITION_HASH;
    }

    public function getHash():String
    {
        var hash:String = "";

        for (hexData in new OccupiedHexesIterator(this))
        {
            hash += hexData.scalarCoord;
            hash += PieceKindFormatter.toLetter(hexData.piece.type);
            if (hexData.piece.color == Black)
                hash += "!";
        }

        return hash;
    }

    public function intellectorCoords(color:PieceColor):Null<HexCoords>
    {
        for (hex in new OccupiedHexesIterator(this))
            if (hex.piece.type == Intellector && hex.piece.color == color)
                return hex.coords;
        return null;
    }

    public function new(pieces:PieceArrangement, turnColor:PieceColor)
    {
        this.pieces = pieces;
        this.turnColor = turnColor;
    }
}
