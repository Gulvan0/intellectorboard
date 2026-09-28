package intellectorboard.movement.rules;

import intellectorboard.position.OccupiedHexesIterator;
import intellectorboard.primitives.piece.PieceData;
import intellectorboard.primitives.ply.RawPly;
import intellectorboard.position.Position;
import intellectorboard.primitives.hex.Hex;

class PlyRules
{
    public static function isPlyPossible(ply:RawPly, position:Position):Bool
    {
        var movingPiece:Null<PieceData> = position.pieces.get(ply.from).piece();

        if (movingPiece == null || movingPiece.color != position.turnColor)
            return false;  // You have to move your piece

        if (!MoveDestinations.isMovementPossible(ply.from, ply.to, position.pieces))
            return false;  // This piece doesn't move like that

        if (ply.morphInto == null)
            return true;  // The remaining checks concern the validity of the selected morph

        if (movingPiece.type == Progressor && ply.to.isFinal(movingPiece.color))  // 1. Progressor promotion case
            return CoreRules.POSSIBLE_PROMOTION_OPTIONS.contains(ply.morphInto);

        if (CoreRules.isHexAffectedByAura(position.pieces, ply.from))  // 2. Aura case
            return position.pieces.pieceAt(ply.to).equals(new PieceData(ply.morphInto, movingPiece.color.opposite()));

        return false;  // No other ways to morph exist
    }

    public static function possiblePlys(position:Position):Array<RawPly>
    {
        var plys:Array<RawPly> = [];

        for (hex in new OccupiedHexesIterator(position))
        {
            if (hex.piece.color != position.turnColor)
                continue;

            for (destination in MoveDestinations.getPossibleDestinations(hex.coords, position.pieces, true))
            {
                if (hex.piece.type == Progressor && destination.isFinal(hex.piece.color))
                {
                    for (newType in CoreRules.POSSIBLE_PROMOTION_OPTIONS)
                        plys.push(RawPly.construct(hex.coords, destination, newType));
                    continue;
                }

                plys.push(RawPly.construct(hex.coords, destination, null));

                var capturedPiece:Null<PieceData> = position.get(destination).piece();
                if (
                    CoreRules.isHexAffectedByAura(position.pieces, hex.coords)
                    && capturedPiece?.color != hex.piece.color
                    && capturedPiece?.type != Intellector
                    && capturedPiece?.type != hex.piece.type
                )
                    plys.push(RawPly.construct(hex.coords, destination, capturedPiece.type));
            }
        }

        return plys;
    }
}
