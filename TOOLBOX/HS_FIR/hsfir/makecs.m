function bitspec = makecs(bitspec, archspec, genopts)
%bitspec = makecs(bitspec, archspec, genopts)
%
%Creates carry-save reduction trees from partial products specifications
%and a given tree generator method.
%
%Arguments:
%  bitspec - structure:
%    branches{k}:
%      ppspec: partial product specification
%  archspec - structure:
%    cstree: specifies carry-save tree generator, valid choices:
%            'wallace', 'dadda', 'ra', 'opt'
%  genopts - generator options
%    verbose: verbosity level
%
%Returns:
%  bitspec - added fields:
%    branches{k}:
%      csspec: reduction tree specification

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

if nargin < 3
	genopts = [];
end
genopts = parseopts(genopts);

for b = 1:bitspec.numout
	if genopts.verbose >= 1
		disp(sprintf('Branch %d CSA generation (%s)', b-1, archspec.cstree));
	end

	ppspec = bitspec.branches{b}.ppspec;

	if strcmp(archspec.cstree, 'wallace')
		csspec = makecswallace(ppspec, archspec);
	elseif strcmp(archspec.cstree, 'dadda')
		csspec = makecsdadda(ppspec, archspec);
	elseif strcmp(archspec.cstree, 'ra')
		csspec = makecsra(ppspec, archspec);
	elseif strcmp(archspec.cstree, 'opt')
		csspec = makecsopt(ppspec, archspec);
	else
		error 'makecs: Invalid CS tree type'
	end

	if genopts.verbose >= 2
		for l = 1:size(csspec.bits, 1)-1
			disp(sprintf('  level %2d: %s (%2d FA, %2d HA, %2d regs)', l-1, ...
				sprintf(' %3d', csspec.bits(l, :)), ...
				sum(csspec.fa(l, :)), ...
				sum(csspec.ha(l, :)), ...
				sum(csspec.regs(l, :))));
		end
		for l = size(csspec.bits, 1)
			disp(sprintf('  level %2d: %s', l-1, sprintf(' %3d', csspec.bits(l, :))));
		end
	end

	bitspec.branches{b}.csspec = csspec;
end

