package intellectorboard.movement.rules;

import intellectorboard.primitives.piece.PieceKind;
import intellectorboard.primitives.piece.PieceColor;
import intellectorboard.primitives.piece.PieceData;
import intellectorboard.position.PieceArrangement;
import intellectorboard.primitives.hex.HexCoords;
import intellectorboard.primitives.hex.Hex;

using Lambda;

class MoveDestinations
{
    private static function getJumpDestinations(departure:HexCoords, pieceArrangement:PieceArrangement, direction:Direction, distance:Int, captureAllowed:Bool = true):Array<HexCoords>
    {
        var movingPiece:PieceData = pieceArrangement.get(departure).piece();
        var destination:HexCoords = HexCoordsNavigation.step(departure, direction, distance);
        if (!destination.isValid())
            return [];

        var destinationHex:Hex = pieceArrangement.get(destination);
        var condition:Bool = captureAllowed? destinationHex.color() != movingPiece.color : destinationHex.match(Empty);
        if (condition)
            return [destination];

        return [];
    }

    private static function getSlideDestinations(departure:HexCoords, pieceArrangement:PieceArrangement, direction:Direction):Array<HexCoords>
    {
        var movingPiece:PieceData = pieceArrangement.get(departure).piece();
        var possibleDestinations:Array<HexCoords> = [];

        var destination:HexCoords = departure;
        for (i in 0...9)
        {
            destination = HexCoordsNavigation.step(destination, direction);

            if (!destination.isValid())  // We've reached the end of the board
                break;

            var hexColor:Null<PieceColor> = pieceArrangement.get(destination).color();

            if (hexColor == movingPiece.color)  // Stop when own piece encountered; capturing it isn't possible either
                break;

            possibleDestinations.push(destination);

            if (hexColor != null)  // If there's an enemy piece, capture is possible, but going further is not
                break;
        }

        return possibleDestinations;
    }

    private static function getSwapDestinations(departure:HexCoords, pieceArrangement:PieceArrangement, direction:Direction, partner:PieceKind):Array<HexCoords>
    {
        var movingPiece:PieceData = pieceArrangement.get(departure).piece();
        var destination:HexCoords = HexCoordsNavigation.step(departure, direction);
        if (!destination.isValid())
            return [];

        var destinationHex:Hex = pieceArrangement.get(destination);
        var desiredHex:Hex = Occupied(new PieceData(partner, movingPiece.color));
        if (destinationHex.isEqualTo(desiredHex))
            return [destination];

        return [];
    }

    private static function getDestinationsForPatternAndDirection(departure:HexCoords, pieceArrangement:PieceArrangement, direction:Direction, pattern:MovementPattern):Array<HexCoords>
    {
        return switch pattern
        {
            case SimpleJump(distance): getJumpDestinations(departure, pieceArrangement, direction, distance);
            case NonCapturingJump(distance): getJumpDestinations(departure, pieceArrangement, direction, distance, false);
            case NormalSlide: getSlideDestinations(departure, pieceArrangement, direction);
            case Swap(partner): getSwapDestinations(departure, pieceArrangement, direction, partner);
        }
    }

    public static function getPossibleDestinations(departure:HexCoords, pieceArrangement:PieceArrangement, ?excludeDefensorCastling:Bool = false):Array<HexCoords>
    {
        var movingPiece:Null<PieceData> = pieceArrangement.get(departure).piece();
        if (movingPiece == null)
            return [];

        var possibleDestinations:Array<HexCoords> = [];

        for (pattern => directions in CoreRules.getAllowedMovements(movingPiece, excludeDefensorCastling))
            for (dir in directions)
                possibleDestinations = possibleDestinations.concat(getDestinationsForPatternAndDirection(departure, pieceArrangement, dir, pattern));

        return possibleDestinations;
    }

    public static function isMovementPossible(from:HexCoords, to:HexCoords, pieceArrangement:PieceArrangement):Bool
    {
        return getPossibleDestinations(from, pieceArrangement).exists(x -> x.equals(to));
    }
}
