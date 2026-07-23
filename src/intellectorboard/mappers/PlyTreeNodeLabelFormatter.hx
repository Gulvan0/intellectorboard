package intellectorboard.mappers;

import intellectorboard.plytree.PlyTreePlyNode;
import intellectorboard.plytree.PlyTreeNodeBase;
import intellectorboard.mappers.notation.PlyFormatter;

class PlyTreeNodeLabelFormatter
{
    public static function formatNode(node:PlyTreeNodeBase, indicateColor:Bool, rootLabel:String):String
    {
        if (!Std.isOfType(node, PlyTreePlyNode))
            return rootLabel;

        var plyNotation:String = PlyFormatter.toNotation(cast(node, PlyTreePlyNode).ply, node.parent.positionAfter, indicateColor);
        return '${node.depth}. $plyNotation';
    }
}
