package intellectorboard.plytree;

import intellectorboard.plytree.path.PlyTreePath;
import morestd.Counter;
import intellectorboard.primitives.ply.RawPly;
import intellectorboard.position.Position;

using Lambda;
using morestd.extensions.ArrayExtension;

abstract class PlyTreeNodeBase
{
    private final nodeIdCounter:Counter;

    public final id:Int;
    public final positionAfter:Position;
    public final depth:Int;
    public final parent:Null<PlyTreeNodeBase>;
    public final children:Array<PlyTreePlyNode> = [];

    // Those may or may not be siblings (they may be nth cousins). Always null for root node
    public var leftNeighbourAtDepth:Null<PlyTreePlyNode> = null;
    public var rightNeighbourAtDepth:Null<PlyTreePlyNode> = null;

    private function getLeftNeighbourForNewChild():Null<PlyTreePlyNode>
    {
        return children.getLast() ?? (leftNeighbourAtDepth != null? leftNeighbourAtDepth.getLeftNeighbourForNewChild() : null);
    }

    private function getRightNeighbourForNewChild():Null<PlyTreePlyNode>
    {
        return rightNeighbourAtDepth != null? rightNeighbourAtDepth.children[0] ?? rightNeighbourAtDepth.getRightNeighbourForNewChild(): null;
    }

    public function collectDescendants():Array<PlyTreeNodeBase>
    {
        return [this].concat(children.map(x -> x.collectDescendants()).flatten());
    }

    public function collectDescendantsWithPaths(thisPath:PlyTreePath):Array<{node:PlyTreeNodeBase, path:PlyTreePath}>
    {
        return [{node: this, path: thisPath}].concat(
            children.mapi((index, x) -> x.collectDescendantsWithPaths(thisPath.getChild(index))).flatten()
        );
    }

    public function collectNodesToTheRight():Array<PlyTreeNodeBase>
    {
        var resultingNodes:Array<PlyTreePlyNode> = [];

        for (node in new HorizontalNodeIterator(this, true))
            for (descendant in node.collectDescendants())
                resultingNodes.push(descendant);

        for (ancestor in new AncestorNodeIterator(this))
            for (node in new HorizontalNodeIterator(ancestor, true))
                resultingNodes.push(node);

        return resultingNodes;
    }

    public function addChild(ply:RawPly):PlyTreePlyNode
    {
        var node:PlyTreePlyNode = new PlyTreePlyNode(nodeIdCounter, ply, positionAfter, depth + 1, this, getLeftNeighbourForNewChild(), getRightNeighbourForNewChild());
        children.push(node);
        return node;
    }

    public function removeChild(child:PlyTreePlyNode)
    {
        children.remove(child);
    }

    public function new(nodeIdCounter:Counter, positionAfter:Position, depth:Int, parent:Null<PlyTreeNodeBase>)
    {
        this.nodeIdCounter = nodeIdCounter;

        this.id = nodeIdCounter.next();
        this.positionAfter = positionAfter;
        this.depth = depth;
        this.parent = parent;
    }
}
