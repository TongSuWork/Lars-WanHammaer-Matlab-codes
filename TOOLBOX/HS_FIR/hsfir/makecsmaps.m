function bitspec = makecsmaps(bitspec)
%bitspec = makecsmaps(bitspec)
%
%Creates bit-level maps for reduction trees for CS and VMA
%
%Arguments:
%  bitspec - structure, used fields:
%    branches{k}:
%      csspec: reduction tree specification
%      vmaspec: VMA specification (as reduction tree)
%
%Returns:
%  bitspec - added fields:
%    branches{k}:
%      csmap: bit-level map of reduction tree
%      vmamap: bit-level map of VMA

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

for b = 1:bitspec.numout
	csspec = bitspec.branches{b}.csspec;
	vmaspec = bitspec.branches{b}.vmaspec;

	csmap = makecsmap(csspec);
	vmamap = makecsmap(vmaspec);

	bitspec.branches{b}.csmap = csmap;
	bitspec.branches{b}.vmamap = vmamap;
end

