package intellectorboard.plytree;

import morestd.Counter;
import intellectorboard.position.Position;

class PlyTreeRoot extends PlyTreeNodeBase
{
    public function new(nodeIdCounter:Counter, startingPosition:Position)
    {
        super(nodeIdCounter, startingPosition, 0, null);
    }
}
