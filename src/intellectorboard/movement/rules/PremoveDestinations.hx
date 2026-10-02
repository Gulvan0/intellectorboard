package intellectorboard.movement.rules;

import intellectorboard.position.PieceArrangement;
import intellectorboard.primitives.piece.PieceData;
import intellectorboard.primitives.hex.HexCoords;
import intellectorboard.primitives.hex.Hex;

using Lambda;

class PremoveDestinations
{
    private static function getJumpDestinations(departure:HexCoords, direction:Direction, distance:Int):Array<HexCoords>
    {
        var destination:HexCoords = HexCoordsNavigation.step(departure, direction, distance);
        return destination.isValid()? [destination] : [];
    }

    private static function getSlideDestinations(departure:HexCoords, direction:Direction):Array<HexCoords>
    {
        var possibleDestinations:Array<HexCoords> = [];

        var destination:HexCoords = departure;
        for (i in 0...9)
        {
            destination = HexCoordsNavigation.step(destination, direction);
            if (!destination.isValid())
                break;

            possibleDestinations.push(destination);
        }

        return possibleDestinations;
    }

    private static function getDestinationsForPatternAndDirection(departure:HexCoords, direction:Direction, pattern:MovementPattern):Array<HexCoords>
    {
        return switch pattern
        {
            case SimpleJump(distance), NonCapturingJump(distance): getJumpDestinations(departure, direction, distance);
            case NormalSlide: getSlideDestinations(departure, direction);
            case Swap(_): getJumpDestinations(departure, direction, 1);
        }
    }

    public static function getPossiblePremoveDestinations(departure:HexCoords, pieceArrangement:PieceArrangement):Array<HexCoords>
    {
        var movingPiece:Null<PieceData> = pieceArrangement.get(departure).piece();
        if (movingPiece == null)
            return [];

        var possibleDestinations:Array<HexCoords> = [];

        for (pattern => directions in CoreRules.getAllowedMovements(movingPiece))
            for (dir in directions)
                possibleDestinations = possibleDestinations.concat(getDestinationsForPatternAndDirection(departure, dir, pattern));

        return possibleDestinations;
    }

    public static function isPremovePossible(from:HexCoords, to:HexCoords, pieceArrangement:PieceArrangement):Bool
    {
        return getPossiblePremoveDestinations(from, pieceArrangement).exists(x -> x.equals(to));
    }
}
