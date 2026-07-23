package intellectorboard.mappers.notation;

import intellectorboard.primitives.hex.HexCoords;

class HexCoordsFormatter
{
    public static function toNotation(pos:HexCoords, caps:Bool = false):String
    {
        return getColumnLetter(pos.i, caps) + getRowNumber(pos.i, pos.j);
    }

    public static function fromNotation(s:String):HexCoords
    {
        s = s.toLowerCase();
        var i:Int = s.charCodeAt(0) - 'a'.code;
        var j:Int = 7 - Std.parseInt(s.charAt(1)) - i % 2;
        return new HexCoords(i, j);
    }

    public static function getColumnLetter(i:Int, caps:Bool = false):String
    {
        var startChar:String = caps? 'A' : 'a';
        return String.fromCharCode(startChar.code + i);
    }

    public static function getRowNumber(i:Int, j:Int):String
    {
        var rowNum:Int = 7 - j - i % 2;
        return '$rowNum';
    }
}
