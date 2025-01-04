function bitspec = makevma(bitspec, archspec, genopts)
%bitspec = makevma(bitspec, archspec, genopts)
%
%Creates VMAs for all branches.
%
%Arguments:
%  bitspec - structure:
%    branches{k}:
%      csspec: reduction tree specification
%  archspec - structure:
%    vma: specifies VMA generator, valid choices: 'rc'
%  genopts - generator options:
%    verbose: verbosity level
%
%Returns:
%  bitspec - added fields:
%    branches{k}:
%      vmaspec: VMA specification

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
	if genopts.verbose >= 1
		disp(sprintf('Branch %d VMA generation (%s)', b-1, archspec.vma));
	end

	csspec = bitspec.branches{b}.csspec;

	if strcmp(archspec.vma, 'rc')
		vmaspec = makevmarc(csspec, archspec);
	else
		error 'makevma: Invalid VMA type'
	end

	bitspec.branches{b}.vmaspec = vmaspec;
end

