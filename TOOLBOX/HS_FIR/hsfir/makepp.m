function bitspec = makepp(bitspec, archspec, genopts)
%bitspec = makepp(bitspec, archspec[, genopts])
%
%Creates the partial product specification and input map from a given
%carry-save reduction tree structure and parameters.
%
%Arguments:
%  bitspec - algorithm-dependent structure
%  archspec - algorithm- and architecture-dependent structure
%  genopts - generator options
%    verbose: verbosity level
%
%Returns:
%  bitspec - added fields:
%    branches{k}:
%      ppmap:
%        bits: map from inputs to partial products (arch-dependent)
%        architecture-dependent fields
%      ppspec:
%        bits: matrix of generated partial products
%        cterm: vector of needed correction term
%        strucdelay: structural delay
%    shared: shared adders map (if archspec.addersharing=1)

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

% Create the partial products
for b = 1:bitspec.numout
	if genopts.verbose >= 1
		disp(sprintf('Branch %d partial product generation', b-1));
	end
	bitspec.branches{b} = makeppmap(bitspec, bitspec.branches{b}, archspec, genopts);
end

if archspec.addersharing == 1
	if strcmp(archspec.type, 'DFs')
		error 'Can not share adders for DFs filter'
	end
	bitspec = shareadders(bitspec, archspec, genopts.verbose);
end

for b = 1:bitspec.numout
	if genopts.verbose >= 1
		disp(sprintf('Branch %d partial product specification', b-1));
	end
	bitspec.branches{b} = makeppspec(bitspec.branches{b}, genopts);
end

