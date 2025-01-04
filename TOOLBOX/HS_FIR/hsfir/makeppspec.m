function branch = makeppspec(branch, genopts)
%branch = makeppspec(branch[, genopts])
%
%Creates partial product matrix for a branch, for use by the partial
%product reduction algorithms.
%
%Arguments:
%  branch - used fields:
%    ppmap:
%      bits: partial product map
%  genopts - generator options
%    verbose: verbosity level
%
%Returns:
%  branch - added fields:
%    ppspec:
%      bits: reduction tree specification

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

if nargin < 2 
	genopts = [];
end
genopts = parseopts(genopts);

ppmap = branch.ppmap;

numlevels = size(ppmap.bits, 1);
numbits = size(ppmap.bits, 2);
bits = zeros(numlevels, numbits);

for level = 1:numlevels
	for bit = 1:numbits
		inb = ppmap.bits{level, bit};
		bits(level, bit) = size(inb, 1);
	end
end

if genopts.verbose >= 1
	disp(sprintf('  Generated partial products:'))
	for level = 1:numlevels
		if any(bits(level, :) > 0)
			disp(sprintf('  level %2d: %s', level-1, sprintf(' %3d', bits(level, :))));
		end
	end
end

branch.ppspec.bits = bits;

