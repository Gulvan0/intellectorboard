package intellectorboard.movement;

class DirectionGroups
{
    public static function allLateral():Array<Direction>
    {
        return [Up, UpLeft, UpRight, Down, DownLeft, DownRight];
    }

    public static function allRadial():Array<Direction>
    {
        return [AgrUpLeft, AgrUpRight, AgrDownLeft, AgrDownRight, AgrLeft, AgrRight];
    }

    public static function forwardLateral(color:PieceColor):Array<Direction>
    {
        return color == White? [Up, UpLeft, UpRight] : [Down, DownLeft, DownRight];
    }
}
