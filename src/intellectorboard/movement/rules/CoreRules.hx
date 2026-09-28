package intellectorboard.movement.rules;

import intellectorboard.primitives.hex.HexCoords;
import intellectorboard.position.PieceArrangement;
import intellectorboard.primitives.piece.PieceData;
import intellectorboard.primitives.piece.PieceKind;

class CoreRules
{
    public static final POSSIBLE_PROMOTION_OPTIONS:Array<PieceKind> = [Liberator, Aggressor, Defensor, Dominator];
    public static final AFFECTED_BY_AURA_PIECES:Array<PieceKind> = [Liberator, Aggressor, Defensor, Dominator];

    public static function getAllowedMovements(piece:PieceData, ?excludeDefensorCastling:Bool = false):Map<MovementPattern, Array<Direction>>
    {
        return switch piece.type
        {
            case Progressor: [SimpleJump(1) => DirectionGroups.forwardLateral(piece.color)];
            case Aggressor: [NormalSlide => DirectionGroups.allRadial()];
            case Dominator: [NormalSlide => DirectionGroups.allLateral()];
            case Liberator: [NonCapturingJump(1) => DirectionGroups.allLateral(), SimpleJump(2) => DirectionGroups.allLateral()];
            case Defensor: excludeDefensorCastling? [SimpleJump(1) => DirectionGroups.allLateral()] : [SimpleJump(1) => DirectionGroups.allLateral(), Swap(Intellector) => DirectionGroups.allLateral()];
            case Intellector: [NonCapturingJump(1) => DirectionGroups.allLateral(), Swap(Defensor) => DirectionGroups.allLateral()];
        }
    }

    public static function isHexAffectedByAura(pieces:PieceArrangement, coords:HexCoords):Bool
    {
        var piece:PieceData = pieces.pieceAt(coords);
        if (piece == null || !AFFECTED_BY_AURA_PIECES.contains(piece.type))
            return false;

        for (nearbyCoords in HexCoordsNavigation.lateralSurroundings(coords))
        {
            var nearbyPiece:Null<PieceData> = pieces.pieceAt(nearbyCoords);
            if (nearbyPiece != null && nearbyPiece.equals(new PieceData(Intellector, piece.color)))
                return true;
        }

        return false;
    }

    /**
        Whether `movingPiece` reaching `destination` is a Progressor promotion. Ignores what's on
        `destination` - capturing the enemy Intellector there is Fatum, handled separately by
        `PlyPerformer`/`MaterializedPly.isFatum`.
    **/
    public static function isPromotionEligible(movingPiece:PieceData, destination:HexCoords):Bool
    {
        return movingPiece.type == Progressor && destination.isFinal(movingPiece.color);
    }

    /**
        Whether `movingPiece` capturing `capturedPiece` near a friendly Intellector may
        "chameleon" into the captured piece's kind. `capturedPiece` nullable = no capture, not an
        already-ruled-out precondition.
    **/
    public static function isChameleonEligible(movingPiece:PieceData, from:HexCoords, capturedPiece:Null<PieceData>, pieces:PieceArrangement):Bool
    {
        return capturedPiece != null
            && capturedPiece.color != movingPiece.color
            && capturedPiece.type != Intellector
            && capturedPiece.type != movingPiece.type
            && isHexAffectedByAura(pieces, from);
    }
}
