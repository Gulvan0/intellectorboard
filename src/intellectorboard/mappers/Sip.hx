package intellectorboard.mappers;

import intellectorboard.position.OccupiedHexesIterator;
import intellectorboard.primitives.piece.PieceKind;
import intellectorboard.primitives.piece.PieceColor;
import intellectorboard.primitives.piece.PieceData;
import intellectorboard.primitives.hex.HexCoords;
import intellectorboard.position.PieceArrangement;
import intellectorboard.position.Position;
import morestd.StringIterator;

@:forward
abstract Sip(String) from String to String
{
    public function new(sip:String)
    {
        this = sip;
    }

    private static function scalarCoordFromCharCode(charCode:Int, sipVersion:Int):Int
    {
        if (sipVersion == 1)
            return charCode - 64;

        if (charCode >= 97)
            return 26 + charCode - 97;
        else if (charCode >= 65)
            return charCode - 65;
        else
            return 52 + charCode - 48;
    }

    private static function parse(whitePart:String, blackPart:String, version:Int):Null<Position>
    {
        var pieces:PieceArrangement = PieceArrangement.empty();
        var turnColor:PieceColor = PieceColorFormatter.fromLetter(whitePart.charAt(0));

        for (color => part in [White => whitePart, Black => blackPart])
            for (pieceChunk in new StringIterator(part, color == White? 1 : 0, 2))
            {
                var scalarCoord:Int = scalarCoordFromCharCode(pieceChunk.charCodeAt(0), version);
                var coords:HexCoords = HexCoords.fromScalarCoord(scalarCoord);
                if (!coords.isValid())
                    return null;

                var pieceKind:Null<PieceKind> = PieceKindFormatter.fromLetter(pieceChunk.charAt(1));
                if (pieceKind == null)
                    return null;

                pieces.set(coords, Occupied(new PieceData(pieceKind, pieceColor)));
            }

        return new Position(pieces, turnColor);
    }

    public function toPosition():Null<Position>
    {
        var parts:Array<String> = this.split("!");

        var version:Int = 1;
        if (parts.length == 3)
            version = Std.parseInt(parts.shift());
        else if (parts.length != 2)
            return null;

        return parse(parts[0], parts[1], version);
    }

    public static function fromPosition(position:Position):Sip
    {
        var arrangementStrings:Map<PieceColor, String> = [White => '', Black => ''];

        for (hex in new OccupiedHexesIterator(position))
        {
            var startingAsciiIndex:Int = switch Math.floor(hex.scalarCoord / 26) {
                case 0: 65;  // capital letters
                case 1: 97;  // small letters
                default: 48;  // digits
            }
            var coordChar:String = String.fromCharCode(startingAsciiIndex + hex.scalarCoord % 26);
            var pieceChar:String = PieceKindFormatter.toLetter(hex.piece.type);
            playerPiecesStr[hexData.piece.color] += coordChar + pieceChar;
        }

        return "2!" + PieceColorFormatter.toLetter(situation.turnColor) + arrangementStrings[White] + "!" + arrangementStrings[Black];
    }
}
