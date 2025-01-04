function csspec = optcstree(ppspec, archspec, optspec, filtspec)
%csspec = optcstree(ppspec, archspec, optspec, filtspec)
%
%Creates a bit-optimized carry-save tree to sum partial products. The
%final implementation is found in the following way:
%  1. The number of stages is successively increased from the minimum
%     required to fit all partial products until a solution to the
%     optimization problem is found. During this stage, no constraints
%     are set on the output vector.
%  2. In order to reduce the VMA length, the number of constrained
%     output bits is then set to the output wordlength, and reduced
%     successively until a valid solution is found.
%Inputs:
%  ppspec - partial product specification
%  archspec - architecture specification, structure with fields:
%    maxheight: maximum number of adders in critical path
%  optspec - optimization specification, structure with fields:
%    optdir: directory to cache optimization results in
%    forceopt: 1 to force reoptimization
%    costs: structure with fields: facost, hacost, regcost, bitcost
%Outputs:
%  csspec - structure describing placement of adders in CS tree

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

firgenconf;

optspec_i = optspec;
optspec_i.numstages = ceil(size(ppspec.inbits, 1)/archspec.maxheight);
optspec_i.constrained = 0;

solfound = 0;
while solfound == 0 && optspec_i.numstages < OPT_MAXSTAGES
	[csspec, solfound] = optcstree_i(ppspec, archspec, optspec_i, filtspec);
	if solfound == 0
		optspec_i.numstages = optspec_i.numstages + 1;
	end
end

if optspec_i.numstages == OPT_MAXSTAGES
	disp(sprintf('Error during CS optimization: OPT_MAXSTAGES=%d reached', OPT_MAXSTAGES));
	csspec = [];
	return
end

optspec_i.constrained = ppspec.wout;
solfound = 0;
while solfound == 0
	[csspec, solfound] = optcstree_i(ppspec, archspec, optspec_i, filtspec);
	if solfound == 0
		optspec_i.constrained = optspec_i.constrained - 1;
	end
end

csspec.outdelay = 0;

