% Configuration for FIR generation

% Optimization options
OPT_DISPCMD = 0;
OPT_GLPSOL = '/proj/es/optimization/bin/glpsol';
OPT_SCIP = '/proj/es/optimization/bin/scip';
OPT_PARSESOL = './parsesol.sh';
OPT_MAXSTAGES = 20;
OPT_MAXTIME = 1800;
OPT_MAXMEM = 1000;

% Simulation script generation options
SIM_INIT = 'vlib work';
SIM_COMPILE = 'vcom';
SIM_SIMULATE = 'vsim';

% Synthesis script generation options
SYNTH_CMD = 'dc_shell-t -f dc.cmd';


