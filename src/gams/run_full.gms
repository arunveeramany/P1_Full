$title run_full
$ontext
Run the GAMS benchmark code, full model.
$offtext

$eolcom #
$include data_parameters.gms
$include algorithm_parameters.gms
$include solution_parameters.gms
$include variables.gms
$include equations.gms
$include models.gms
$include variable_bounds.gms
$include equation_definitions.gms
$include start_point.gms
$include solve_full.gms
$include display_solution.gms
$include write_summary.gms
