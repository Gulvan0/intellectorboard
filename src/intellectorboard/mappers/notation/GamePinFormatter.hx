package intellectorboard.mappers.notation;

import intellectorboard.mappers.notation.PlyFormatter;
import intellectorboard.primitives.ply.RawPly;
import intellectorboard.position.Position;
import morestd.EnumeratingIterator;

class GamePinFormatter
{
    public static function format(startingPosition:Position, plySequence:Array<RawPly>, ?whitePlayer:String = "Anonymous", ?blackPlayer:String = "Anonymous", ?timeControl:String, ?datetime:Date, outcome:String):String
    {
        var pin:String = "";
        pin += '#Players: $whitePlayer vs $blackPlayer;\n';
        if (timeControl != null)
            pin += '#TimeControl: $timeControl;\n';
        if (datetime != null)
            pin += '#DateTime: ${datetime.toString()};\n';

        if (!startingPosition.isDefaultStarting())
        {
            var startingSIP:Sip = Sip.fromPosition(startingPosition);
            pin += '#CustomStartPosSIP: $startingSIP;\n';
        }

        var formattedPlys:Array<String> = PlyFormatter.plySequenceToNotation(plySequence, startingPosition);
        for (plyNum => plyStr in new EnumeratingIterator(formattedPlys, 1))
            pin += '$plyNum. $plyStr;\n';

        pin += outcome;

        return pin;
    }
}
