package intellectorboard.plytree;

import intellectorboard.plytree.path.PlyTreePath;
import intellectorboard.position.Position;
import morestd.Counter;

class PlyTree
{
    public final root:PlyTreeRoot;

    public function collectPlyNodes():Array<{node:PlyTreePlyNode, path:PlyTreePath}>
    {
        return cast this.root.collectDescendantsWithPaths(new PlyTreePath()).slice(1);  // Exclude root
    }

    public function new(startingPosition:Position)
    {
        this.root = new PlyTreeRoot(new Counter(), startingPosition);
    }
}
