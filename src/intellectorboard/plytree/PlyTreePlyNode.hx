package intellectorboard.plytree;

import morestd.Counter;
import intellectorboard.plytree.PlyTreeNodeBase;
import intellectorboard.plyapplication.PlyPerformer;
import intellectorboard.position.Position;
import intellectorboard.primitives.ply.RawPly;

class PlyTreePlyNode extends PlyTreeNodeBase
{
    public final ply:RawPly;

    private function new(nodeIdCounter:Counter, ply:RawPly, positionBefore:Position, depth:Int, parent:Null<PlyTreeNodeBase>, leftNeighbour:Null<PlyTreePlyNode>, rightNeighbour:Null<PlyTreePlyNode>)
    {
        super(nodeIdCounter, PlyPerformer.performRawPly(positionBefore, ply), depth, parent);

        this.ply = ply;
        this.leftNeighbourAtDepth = leftNeighbour;
        this.rightNeighbourAtDepth = rightNeighbour;

        if (this.leftNeighbourAtDepth != null)
            this.leftNeighbourAtDepth.rightNeighbourAtDepth = this;
        if (this.rightNeighbourAtDepth != null)
            this.rightNeighbourAtDepth.leftNeighbourAtDepth = this;
    }
}
