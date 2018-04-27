$title greedy_base.gms
$ontext
solve base case in greedy heuristic
$offtext

option solprint = on;

# step 1 subproblem solve with hard constraints first
VoltMagBoundSoft = 0;
PowFlowMagBoundSoft = 0;
CurrFlowMagBoundSoft = 0;
PowBalanceLinSoft = 0;
PowBalanceQuadSoft = 0;
solve subModelBase using nlp minimizing objVar;
MaxInfeas = subModelBase.maxinfes;

# solve with soft constraints if hard constraints are infeasible
if(MaxInfeas > 1e-3,
  VoltMagBoundSoft = 0;
  PowFlowMagBoundSoft = 0;
  CurrFlowMagBoundSoft = 0;
  PowBalanceLinSoft = 0;
  PowBalanceQuadSoft = 1;
  solve subModelBase using nlp minimizing objVar;
  MaxInfeas = subModelBase.maxinfes;
);

# something is wrong if still infeasible
if(MaxInfeas > 1e-3,
  abort 'infeasibility still - base case';
);

$include solution_evaluation_base.gms
$include convert_solution_base.gms
$include write_solution_base.gms
