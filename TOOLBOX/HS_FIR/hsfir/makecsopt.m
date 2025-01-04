function csspec = makecsopt(ppspec, archspec)
%csspec = makecsopt(ppspec, archspec)
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
%
%Arguments:
%  ppspec - partial product specification
%  archspec - architecture specification, structure with fields:
%    maxheight: maximum number of adders in critical path
%    optspec: optimization specification, structure with fields:
%      optdir: directory to cache optimization results in
%      forceopt: 1 to force reoptimization
%      costs: structure with fields: facost, hacost, regcost, bitcost
%
%Returns:
%  csspec - structure describing placement of adders in CS tree

%Copyright 2008, 2010 Anton Blad
%
%This file is part of firgen.
%
%firgen is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%firgen is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with firgen.  If not, see <http://www.gnu.org/licenses/>

firgenconf;

optspec_i = archspec.optspec;
optspec_i.numstages = ceil(size(ppspec.bits, 1)/archspec.maxheight);
optspec_i.constrained = 0;

solfound = 0;
while solfound == 0 && optspec_i.numstages < OPT_MAXSTAGES
	[csspec, solfound] = optcstree(ppspec, archspec, optspec_i);
	if solfound == 0
		optspec_i.numstages = optspec_i.numstages + 1;
	end
end

if optspec_i.numstages == OPT_MAXSTAGES
	disp(sprintf('Error during CS optimization: OPT_MAXSTAGES=%d reached', OPT_MAXSTAGES));
	csspec = [];
	return
end

optspec_i.constrained = size(ppspec.bits, 2);
solfound = 0;
while solfound == 0
	[csspec, solfound] = optcstree(ppspec, archspec, optspec_i);
	if solfound == 0
		optspec_i.constrained = optspec_i.constrained - 1;
	end
end

csspec.outdelay = 0;

