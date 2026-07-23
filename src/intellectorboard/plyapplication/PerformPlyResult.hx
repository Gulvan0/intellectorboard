package intellectorboard.plyapplication;

enum PerformPlyResult
{
    NormalPlyPerformed(ply:MaterializedPly);
    ProgressivePlyPerformed(ply:MaterializedPly);
    FatumReached;
    BreakthroughReached;
    FailedToPerform;
}
