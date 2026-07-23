package intellectorboard.plytree.path;

@:structInit
class PlyTreePathItem
{
    public final childIndex:Int;
    public final repetitions:Int;

    public static function fromString(item:String):PlyTreePathItem
    {
        var parts:Array<String> = item.split("x");
        var childIndex:Int = parts[0] != ""? Std.parseInt(parts[0]) : 0;
        return {childIndex: childIndex, repetitions: parts[1] ?? 1};
    }

    public function toString():String
    {
        var childIndexStr:String = childIndex > 0? Std.string(childIndex) : "";
        var repetitionPostfix:String = repetitions > 1? "x" + Std.string(repetitions) : "";
        return childIndexStr + repetitionPostfix;
    }

    public function copy():PlyTreePathItem
    {
        return {childIndex: childIndex, repetitions: repetitions};
    }
}
