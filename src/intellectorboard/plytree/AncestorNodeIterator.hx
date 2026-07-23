package intellectorboard.plytree;

class AncestorNodeIterator
{
    private var node:PlyTreeNodeBase;

    public function hasNext():Bool
    {
        return node.parent != null;
    }

    public function next():PlyTreeNodeBase
    {
        node = node.parent;
        return node;
    }

    public function new(startingNode:PlyTreeNodeBase)
    {
        this.node = startingNode;
    }
}
