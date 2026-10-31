package intellectorboard.plyapplication;

enum PerformPlyResult
{
    NormalPlyPerformed(ply:MaterializedPly);
    ProgressivePlyPerformed(ply:MaterializedPly);
    FatumReached;
    BreakthroughReached;
    /** The side to move has no plys left, which counts as their loss **/
    StalemateReached;
    FailedToPerform;
}
