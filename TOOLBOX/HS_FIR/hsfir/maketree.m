function bitspec = maketree(bitspec, archspec, genopts)
%bitspec = maketree(bitspec, archspec, genopts)
%
%Generates partial product specification for carry-save reduction tree.
%This is done in several steps:
%  1. Generate an algorithm-dependent map from the input to the
%     partial products.
%  2. Given the partial products, use the specified reduction method to
%     reduce these to a vector of at most 2 partial products per bit
%     weight. Only the placement of full and half adders is considered
%     here.
%  3. Use the specified VMA to reduce the vector to the final result.
%  4. Map the partial products to the adders.
%
%Arguments:
%  bitspec - algorithm-dependent structure, possible generators:
%    gfir: direct form or transposed direct form FIR filter
%  archspec - algorithm- and architecture-dependent structure
%    mandatory fields:
%      type: specifies architecture
%        for gfir: 'DF', 'DFs', or 'TF'
%      maxadd: maximum number of adders in the critical path
%      addersharing: specify if adder sharing shall be used
%      cstree: reduction method, 'wallace', 'dadda', 'ra', or 'opt'
%      vma: VMA type, only 'rc' implemented
%    optional fields:
%      symmetrysize: symmetry adder size for (type='DFs')
%      optspec: optimization specification structure (cstree='opt')
%  genopts - generator options
%    verbose: verbosity level
%
%Returns:
%  bitspec - bit-level specification of reduction tree

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

% Create partial product specification and map to input signals
bitspec = makepp(bitspec, archspec, genopts);

% Create structure for partial product reduction tree
bitspec = makecs(bitspec, archspec, genopts);

% Create VMA
bitspec = makevma(bitspec, archspec, genopts);

% Calculate additional FIR information: pipeline delay
bitspec = pipedelay(bitspec);

% Create the bit-level map of the reduction tree and VMA
bitspec = makecsmaps(bitspec);

