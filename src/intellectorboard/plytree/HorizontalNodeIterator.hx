package intellectorboard.plytree;

class HorizontalNodeIterator
{
    private var node:PlyTreeNodeBase;
    private var nextRetriever:PlyTreeNodeBase->Null<PlyTreePlyNode>;

    public function hasNext():Bool
    {
        return nextRetriever(node) != null;
    }

    public function next():PlyTreePlyNode
    {
        node = nextRetriever(node);
        return node;
    }

    public function new(startingNode:PlyTreeNodeBase, right:Bool)
    {
        this.node = startingNode;
        this.nextRetriever = right? x -> x.rightNeighbourAtDepth : x -> x.leftNeighbourAtDepth;
    }
}
