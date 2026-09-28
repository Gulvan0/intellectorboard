package intellectorboard.movement;

import intellectorboard.primitives.hex.HexCoords;
import intellectorboard.primitives.piece.PieceColor;

class HexCoordsNavigation
{
    public static function isLiberatorJumpAway(coords:HexCoords, departure:HexCoords):Bool
    {
        return isNStepsAway(coords, departure, DirectionGroups.allLateral(), 2);
    }

    public static function isLaterallyNear(coords:HexCoords, departure:HexCoords):Bool
    {
        return isNStepsAway(coords, departure, DirectionGroups.allLateral());
    }

    public static function isForwardStepAway(coords:HexCoords, departure:HexCoords, color:PieceColor):Bool
    {
        return isNStepsAway(coords, departure, DirectionGroups.forwardLateral(color));
    }

    public static function isNStepsAway(coords:HexCoords, departure:HexCoords, checkedDirections:Array<Direction>, ?n:Int = 1):Bool
    {
        for (dir in checkedDirections)
        {
            var neighbour:HexCoords = step(coords, dir, n);
            if (neighbour.isValid() && neighbour.equals(departure))
                return true;
        }

        return false;
    }

    public static function lateralSurroundings(coords:HexCoords):Array<HexCoords>
    {
        var result:Array<HexCoords> = [];

        for (dir in DirectionGroups.allLateral())
        {
            var neighbour:HexCoords = step(coords, dir);
            if (neighbour.isValid())
                result.push(neighbour);
        }

        return result;
    }

    public static function step(coords:HexCoords, dir:Direction, ?steps:Int = 1):HexCoords
    {
        switch dir
        {
            case Up:
                return new HexCoords(coords.i, coords.j - steps);
            case UpLeft:
                var jShift:Int = Math.floor(steps / 2);
                if (coords.i % 2 == 0)
                    jShift--;
                return new HexCoords(coords.i - steps, coords.j - jShift);
            case UpRight:
                var jShift:Int = Math.floor(steps / 2);
                if (coords.i % 2 == 0)
                    jShift--;
                return new HexCoords(coords.i + steps, coords.j - jShift);
            case Down:
                return new HexCoords(coords.i, coords.j + steps);
            case DownLeft:
                var jShift:Int = Math.floor(steps / 2);
                if (coords.i % 2 == 1)
                    jShift++;
                return new HexCoords(coords.i - steps, coords.j + jShift);
            case DownRight:
                var jShift:Int = Math.floor(steps / 2);
                if (coords.i % 2 == 1)
                    jShift++;
                return new HexCoords(coords.i + steps, coords.j + jShift);
            case AgrUpLeft:
                var jShift:Int = 3 * Math.floor(steps / 2);
                if (steps % 2 == 1)
                    if (coords.i % 2 == 0)
                        jShift += 2;
                    else
                        jShift += 1;
                return new HexCoords(coords.i - steps, coords.j - jShift);
            case AgrUpRight:
                var jShift:Int = 3 * Math.floor(steps / 2);
                if (steps % 2 == 1)
                    if (coords.i % 2 == 0)
                        jShift += 2;
                    else
                        jShift += 1;
                return new HexCoords(coords.i + steps, coords.j - jShift);
            case AgrDownLeft:
                var jShift:Int = 3 * Math.floor(steps / 2);
                if (steps % 2 == 1)
                    if (coords.i % 2 == 1)
                        jShift += 2;
                    else
                        jShift += 1;
                return new HexCoords(coords.i - steps, coords.j + jShift);
            case AgrDownRight:
                var jShift:Int = 3 * Math.floor(steps / 2);
                if (steps % 2 == 1)
                    if (coords.i % 2 == 1)
                        jShift += 2;
                    else
                        jShift += 1;
                return new HexCoords(coords.i + steps, coords.j + jShift);
            case AgrLeft:
                return new HexCoords(coords.i - 2 * steps, coords.j);
            case AgrRight:
                return new HexCoords(coords.i + 2 * steps, coords.j);
        }
    }
}
