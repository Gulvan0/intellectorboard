package intellectorboard.plyapplication;

import intellectorboard.primitives.ply.RawPly;
import intellectorboard.primitives.piece.PieceColor;
import intellectorboard.position.Position;
import intellectorboard.movement.rules.PlyRules;
import morestd.MathTools;

class PlyPerformer
{
    public static function performPly(position:Position, ply:MaterializedPly):PerformPlyResult
    {
        if (!PlyRules.isPlyPossible(ply.toRaw(), position))
            return FailedToPerform;

        var isFatum:Bool = ply.isFatum();
        var isBreakthrough:Bool = isFatum? false : ply.isBreakthrough(position);
        var isProgressive:Bool = isBreakthrough? false : ply.isProgressive();

        switch ply
        {
            case NormalMove(from, to, movingPiece):
                position.set(from, Empty);
                position.setPiece(to, movingPiece, turnColor);
            case NormalCapture(from, to, capturingPiece, _):
                position.set(from, Empty);
                position.setPiece(to, capturingPiece, turnColor);
            case ChameleonCapture(from, to, _, capturedPiece):
                position.set(from, Empty);
                position.setPiece(to, capturedPiece, turnColor);
            case Promotion(from, to, promotedTo), PromotionWithCapture(from, to, _, promotedTo):
                position.set(from, Empty);
                position.setPiece(to, promotedTo, turnColor);
            case Castling(from, to):
                position.swap(from, to);
        }

        position.turnColor = position.turnColor.opposite();

        if (isFatum)
            return FatumReached;
        else if (isBreakthrough)
            return BreakthroughReached;
        else if (isProgressive)
            return ProgressivePlyPerformed(ply);
        else
            return NormalPlyPerformed(ply);
    }

    public static function revertPly(position:Position, ply:MaterializedPly)
    {
        var capturedPieceColor:PieceColor = position.turnColor;

        position.turnColor = position.turnColor.opposite();

        switch ply
        {
            case NormalMove(from, to, _):
                position.set(from, position.get(to));
                position.set(to, Empty);
            case NormalCapture(from, to, _, capturedPiece):
                position.set(from, position.get(to));
                position.setPiece(to, capturedPiece, capturedPieceColor);
            case ChameleonCapture(from, to, capturingPiece, capturedPiece):
                position.setPiece(from, capturingPiece, turnColor);
                position.setPiece(to, capturedPiece, capturedPieceColor);
            case Promotion(from, to, _):
                position.setPiece(from, Progressor, turnColor);
                position.set(to, Empty);
            case PromotionWithCapture(from, to, capturedPiece, _):
                position.setPiece(from, Progressor, turnColor);
                position.setPiece(to, capturedPiece, capturedPieceColor);
            case Castling(from, to):
                position.swap(from, to);
        }
    }

    public static function performRawPly(position:Position, ply:RawPly):PerformPlyResult
    {
        return performPly(position, PlyMaterializer.materialize(ply, position.pieces));
    }

    public static function performRandomPly(position:Position)
    {
        var allPlys:Array<RawPly> = PlyRules.possiblePlys(position);
        var randomPly:Array<RawPly> = MathTools.randomElement(allPlys);
        performRawPly(position, randomPly);
    }

    public static function positionAfterPly(position:Position, ply:MaterializedPly):Situation
    {
        var newPosition:Position = position.copy();
        performPly(newPosition, ply);
        return newPosition;
    }

    public static function positionAfterRawPly(position:Position, ply:RawPly):Situation
    {
        return positionAfterPly(position, PlyMaterializer.materialize(ply, position.pieces));
    }

    public static function randomPlay(position:Position, plyCount:Int, ?startingPosition:Null<Position>):Situation
    {
        var newPosition:Position = startingPosition ?? Position.defaultStarting();
        for (_ in 0...plyCount)
            performRandomPly(newPosition);
        return newPosition;
    }
}
