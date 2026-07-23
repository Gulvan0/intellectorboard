package intellectorboard.movement;

import intellectorboard.primitives.piece.PieceKind;

enum MovementPattern
{
    SimpleJump(distance:Int);
    NonCapturingJump(distance:Int);
    NormalSlide;
    Swap(partner:PieceKind);
}
