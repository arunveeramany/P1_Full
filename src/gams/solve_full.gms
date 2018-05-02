$title solve_full
$ontext
solve the full model - base case and all contingencies simultaneously
$offtext

VoltMagViolPen = 1e3;
PowFlowMagViolPen = 1e5;
CurrFlowMagViolPen = 1e5;
PowBalanceViolPen = 1e5;
VoltMagBoundSoft = 0;
PowFlowMagBoundSoft = 0;
CurrFlowMagBoundSoft = 0;
PowBalanceLinSoft = 1;
PowBalanceQuadSoft = 0;
VoltMaintLinSoft = 1;
VoltMaintQuadSoft = 0;
VoltMaintViolPen = 1e3;

resLim = 3600; # STE default is 1000

option
  limrow = 0
  limcol = 0
  solprint = off
  nlp = ipopth # knitro, ipopt, ipopth, snopt
  mpec = knitro # knitro, nlpec: NLP reformulation of equilibrium constraints
;
fullComplementarityModel.optfile = 1;
fullModel.optfile = 1;

* nlpec options file - subsolver knitro
$onecho > nlpec.opt
* knitro, ipopt
subsolver knitro
subsolveropt 1
initmu 1e-2
*finalmu 0.0
*numsolves 1
aggregate full
$offecho

* nlpec options file 2 - subsolver ipopt
$onecho > nlpec.op2
* knitro, ipopt
subsolver ipopt
subsolveropt 1
initmu 1e-2
finalmu 0.0
numsolves 4
aggregate full
$offecho

* knitro options file
$onecho > knitro.opt
* 1: barrier/direct (uses more memory), 2: barrier/cg (slower, unreliable)
algorithm 1
feastol 1e-8
*opttol 1e-3
*ftol 1e-3
*ftol_iters 3
pivot 1e-12
maxcgit 10

*bar_feasible 3 # not good - just use default on all of these
*bar_penaltycons 2
*bar_penaltyrule
*bar_relaxcons 3 # default is 2 - relax inequalities

*bar_initpi_mpec 1e-3 # initial value of mpec smoothing parameter (?) - maybe want to drive this to 0
secret 1093 x 1e-3
$offecho

* knitro options file 2
$onecho > knitro.op2
*secret 1093 x 0.0
$offecho

* ipopt options file
$onecho > ipopt.opt
$offecho

* ipopth options file
$onecho > ipopth.opt
$offecho

CtgActive(k) = yes$Ctg(k);
#solve fullComplementarityModel using mpec minimizing objVar;
solve fullModel using nlp minimizing objVar;

$include solution_evaluation_base.gms
$include convert_solution_base.gms
$include write_solution_base.gms

$include solution_evaluation_ctg.gms
$include convert_solution_ctg.gms
$include write_solution_ctg.gms


