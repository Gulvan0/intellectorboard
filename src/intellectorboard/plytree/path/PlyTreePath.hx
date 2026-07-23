package intellectorboard.plytree.path;

using morestd.extensions.ArrayExtension;

abstract PlyTreePath(Array<PlyTreePathItem>) from Array<PlyTreePathItem>
{
    public static function fromString(path:String):PlyTreePath
    {
        return path.split(":").map(PlyTreePathItem.fromString);
    }

    public function toString():String
    {
        return this.map(x -> x.toString()).join(":");
    }

    public function copy():Array<PlyTreePathItem>
    {
        return this.map(x -> x.copy());
    }

    private function withLastItemReplaced(newLast:PlyTreePathItem):PlyTreePath
    {
        return copy().slice(0, -1).concat([newLast]);
    }

    public function getChild(index:Int):PlyTreePath
    {
        var lastItem:Null<PlyTreePathItem> = this.getLast();
        if (lastItem == null)
            return [{childIndex: index, repetitions: 1}];

        if (lastItem.childIndex == index)
            return withLastItemReplaced({childIndex: index, repetitions: lastItem.repetitions + 1});

        return copy().concat([{childIndex: index, repetitions: 1}]);
    }

    public function getParent():Null<PlyTreePath>
    {
        var lastItem:Null<PlyTreePathItem> = this.getLast();
        if (lastItem == null)
            return null;

        if (lastItem.repetitions > 1)
            return withLastItemReplaced({childIndex: lastItem.childIndex, repetitions: lastItem.repetitions - 1});

        var parent:Array<PlyTreePathItem> = copy().slice(0, -1);
        return parent.length > 0? parent : null;
    }

    public function getDependency():Null<PlyTreePath>
    {
        var lastItem:Null<PlyTreePathItem> = this.getLast();
        if (lastItem == null)
            return null;

        var parent:Null<PlyTreePath> = getParent();

        if (lastItem.childIndex == 0)
            return parent;

        if (parent == null)
            return [{childIndex: lastItem.childIndex - 1, repetitions: 1}];

        return parent.getChild(lastItem.childIndex - 1);
    }

    public function new(?items:Null<Array<PlyTreePathItem>>)
    {
        this = items ?? [];
    }
}
