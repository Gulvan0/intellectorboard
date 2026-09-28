package intellectorboard.position;

import intellectorboard.primitives.piece.PieceData;
import intellectorboard.primitives.piece.PieceKind;
import intellectorboard.primitives.piece.PieceColor;
import haxe.ds.Vector;
import intellectorboard.primitives.hex.Hex;
import intellectorboard.primitives.hex.HexCoords;

abstract PieceArrangement(Vector<Vector<Hex>>) from Vector<Vector<Hex>>
{
    public static function defaultStarting():PieceArrangement
    {
        var pieces:PieceArrangement = new PieceArrangement();

        pieces.set(new HexCoords(0, 0), Occupied(new PieceData(Dominator, Black)));
        pieces.set(new HexCoords(1, 0), Occupied(new PieceData(Liberator, Black)));
        pieces.set(new HexCoords(2, 0), Occupied(new PieceData(Aggressor, Black)));
        pieces.set(new HexCoords(3, 0), Occupied(new PieceData(Defensor, Black)));
        pieces.set(new HexCoords(4, 0), Occupied(new PieceData(Intellector, Black)));
        pieces.set(new HexCoords(5, 0), Occupied(new PieceData(Defensor, Black)));
        pieces.set(new HexCoords(6, 0), Occupied(new PieceData(Aggressor, Black)));
        pieces.set(new HexCoords(7, 0), Occupied(new PieceData(Liberator, Black)));
        pieces.set(new HexCoords(8, 0), Occupied(new PieceData(Dominator, Black)));
        pieces.set(new HexCoords(0, 1), Occupied(new PieceData(Progressor, Black)));
        pieces.set(new HexCoords(2, 1), Occupied(new PieceData(Progressor, Black)));
        pieces.set(new HexCoords(4, 1), Occupied(new PieceData(Progressor, Black)));
        pieces.set(new HexCoords(6, 1), Occupied(new PieceData(Progressor, Black)));
        pieces.set(new HexCoords(8, 1), Occupied(new PieceData(Progressor, Black)));

        pieces.set(new HexCoords(0, 5), Occupied(new PieceData(Progressor, White)));
        pieces.set(new HexCoords(2, 5), Occupied(new PieceData(Progressor, White)));
        pieces.set(new HexCoords(4, 5), Occupied(new PieceData(Progressor, White)));
        pieces.set(new HexCoords(6, 5), Occupied(new PieceData(Progressor, White)));
        pieces.set(new HexCoords(8, 5), Occupied(new PieceData(Progressor, White)));
        pieces.set(new HexCoords(0, 6), Occupied(new PieceData(Dominator, White)));
        pieces.set(new HexCoords(1, 5), Occupied(new PieceData(Liberator, White)));
        pieces.set(new HexCoords(2, 6), Occupied(new PieceData(Aggressor, White)));
        pieces.set(new HexCoords(3, 5), Occupied(new PieceData(Defensor, White)));
        pieces.set(new HexCoords(4, 6), Occupied(new PieceData(Intellector, White)));
        pieces.set(new HexCoords(5, 5), Occupied(new PieceData(Defensor, White)));
        pieces.set(new HexCoords(6, 6), Occupied(new PieceData(Aggressor, White)));
        pieces.set(new HexCoords(7, 5), Occupied(new PieceData(Liberator, White)));
        pieces.set(new HexCoords(8, 6), Occupied(new PieceData(Dominator, White)));

        return pieces;
    }

    public static function empty():PieceArrangement
    {
        return new PieceArrangement();
    }

    public function isEmpty(coords:HexCoords):Bool
    {
        return get(coords) == Empty;
    }

    public function is(coords:HexCoords, type:PieceKind, color:PieceColor):Bool
    {
        return type != null && color != null && typeAt(coords) == type && colorAt(coords) == color;
    }

    public function pieceAt(coords:HexCoords):Null<PieceData>
    {
        return switch get(coords)
        {
            case Empty: null;
            case Occupied(piece): piece;
        }
    }

    public function typeAt(coords:HexCoords):Null<PieceKind>
    {
        return pieceAt(coords)?.type;
    }

    public function colorAt(coords:HexCoords):Null<PieceColor>
    {
        return pieceAt(coords)?.color;
    }

    public function get(coords:HexCoords):Hex
    {
        return this[coords.i][coords.j];
    }

    public function set(coords:HexCoords, value:Hex)
    {
        this[coords.i][coords.j] = value;
    }

    public function copy():PieceArrangement
    {
        var newArrangement:Vector<Vector<Hex>> = new Vector(9);

        for (i in 0...9)
            newArrangement[i] = this[i].copy();

        return newArrangement;
    }

    private function new()
    {
        this = new Vector(9);
        for (i in 0...9)
        {
            this[i] = new Vector(i % 2 == 0? 7 : 6);
            this[i].fill(Empty);
        }
    }
}
