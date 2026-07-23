package intellectorboard.mappers.notation;

import intellectorboard.primitives.hex.HexCoords;
import intellectorboard.movement.rules.MoveDestinations;
import intellectorboard.movement.rules.PlyRules;
import intellectorboard.position.OccupiedHexesIterator;
import intellectorboard.primitives.piece.PieceColor;
import intellectorboard.plyapplication.PlyMaterializer;
import intellectorboard.plyapplication.MaterializedPly;
import intellectorboard.primitives.piece.PieceData;
import intellectorboard.position.Position;
import intellectorboard.primitives.ply.RawPly;
import intellectorboard.primitives.piece.PieceKind;

using StringTools;
using Lambda;

class PlyFormatter
{
    public static inline function pieceAbbreviation(piece:PieceKind, progressorNonEmpty:Bool = false):String
    {
        return switch piece
        {
            case Progressor: progressorNonEmpty? "P" : "";
            case Aggressor: "A";
            case Dominator: "D";
            case Liberator: "L";
            case Defensor: "F";
            case Intellector: "I";
        }
    }

    public static inline function pieceFromAbbreviation(abb:String):PieceKind
    {
        return switch abb
        {
            case "": Progressor;
            case "P": Progressor;
            case "A": Aggressor;
            case "D": Dominator;
            case "L": Liberator;
            case "F": Defensor;
            case "I": Intellector;
            default: null;
        }
    }

    public static inline function colorSymbol(color:PieceColor):String
    {
        return switch color {
            case White: '⬡';
            case Black: '⬢';
        }
    }

    private static function movingPieceConfusionExists(ply:RawPly, position:Position, movingPiece:PieceData):Bool
    {
        for (hex in new OccupiedHexesIterator(position))
        {
            if (hex.coords.equals(ply.from))
                continue;
            if (!hex.piece.equals(movingPiece))
                continue;
            if (!MoveDestinations.isMovementPossible(hex.coords, ply.to, position.pieces))
                continue;

            return true;
        }

        return false;
    }

    private static function formatNonCastlingPly(ply:RawPly, position:Position, materializedPly:MaterializedPly, movingPiece:PieceData):String
    {
        var str:String = pieceAbbreviation(movingPiece.type);

        if (movingPieceConfusionExists(ply, position, movingPiece))
        {
            var sign:String = materializedPly.isCapture()? "X" : "~";
            str += HexCoordsFormatter.toNotation(ply.from) + sign;
        }
        else if (materializedPly.isCapture())
            str += "X";

        str += HexCoordsFormatter.toNotation(ply.to);

        if (ply.morphInto != null)
            str += '=' + pieceAbbreviation(ply.morphInto, true);

        if (materializedPly.isFatum())
            str += "#";

        return str;
    }

    private static function formatCastling(from:HexCoords, to:HexCoords):String
    {
        return HexCoordsFormatter.toNotation(from, true) + ":" + HexCoordsFormatter.toNotation(to, true);
    }

    public static function toNotation(ply:RawPly, position:Position, ?indicateColor:Bool):String
    {
        var movingPiece:PieceData = position.getPiece(ply.from);
        var materializedPly:MaterializedPly = PlyMaterializer.materialize(ply, position.pieces);

        if (movingPiece == null)
            throw "Failed to format ply: departure hex is empty";

        var prefix:String = indicateColor? colorSymbol(position.turnColor) : "";
        var formattedPly:String = switch materializedPly
        {
            case Castling(from, to):
                return formatCastling(from, to);
            default:
                return formatNonCastlingPly(ply, position, materializedPly, movingPiece);
        }

        return prefix + formattedPly;
    }

    public static function fromNotation(plyStr:String, position:Position):RawPly
    {
        if (plyStr.contains(":"))  // Castling case
        {
            var splitted:String = plyStr.split(":");
            var from:String = HexCoordsFormatter.fromNotation(splitted[0]);
            var to:String = HexCoordsFormatter.fromNotation(splitted[1]);
            return RawPly.construct(from, to);
        }

        var movingPieceKind:PieceKind = pieceFromAbbreviation(plyStr.charAt(0));

        if (movingPiece == null)
            movingPieceKind = Progressor;
        else
            plyStr = plyStr.substr(1);

        var ply:RawPly = new RawPly();

        if (plyStr.contains("~") || (plyStr.contains("X") && plyStr.charAt(0) != "X"))  // Notation explicitly specifies departure hex
        {
            ply.from = HexCoordsFormatter.fromNotation(plyStr.substr(0, 2));
            plyStr = plyStr.substr(3);
            ply.to = HexCoordsFormatter.fromNotation(plyStr.substr(0, 2));
            plyStr = plyStr.substr(2);

            if (plyStr.charAt(0) == "=")
                ply.morphInto = Notation.pieceFromAbbreviation(plyStr.charAt(1));

            return ply;
        }

        if (plyStr.charAt(0) == "X")
            plyStr = plyStr.substr(1);

        ply.to = HexCoordsFormatter.fromNotation(plyStr.substr(0, 2));
        plyStr = plyStr.substr(2);

        if (plyStr.charAt(0) == "=")
            ply.morphInto = pieceFromAbbreviation(plyStr.charAt(1));

        for (hex in new OccupiedHexesIterator(position))
            if (hex.piece.equals(new PieceData(movingPieceKind, position.turnColor)))
            {
                ply.from = hex.coords;
                if (PlyRules.isPlyPossible(ply, position))
                    return ply;
            }

        return null;
    }

    public static function plySequenceToNotation(plys:Array<RawPly>, startingPosition:Position):Array<String>
    {
        var result:Array<String> = [];
        var position:Position = startingPosition.copy();

        for (ply in plys)
        {
            result.push(toNotation(ply, position));
            position.performRawPly(ply);
        }

        return result;
    }
}
