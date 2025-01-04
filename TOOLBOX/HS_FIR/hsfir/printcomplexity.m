function printcomplexity(cplx)
%printcomplexity(cplx)
%
%Prints CSA tree complexity information
%
%Arguments:
%  cplx - complexity structure

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

wout = cplx.wout;
numout = cplx.numout;

disp ' '
disp(sprintf('Number of output bits: %d', wout));
disp(sprintf('Number of output branches: %d', numout));

for b = 1:numout
	br = cplx.branches{b};
	disp ' '
	disp(sprintf('Branch %d', b-1));
	disp(sprintf('Structural FA:   %d', br.ppfa));
	disp(sprintf('Structural HA:   %d', br.ppha));
	disp(sprintf('Structural regs: %d', br.ppregs));
	disp(sprintf('CSA tree FA:   %d', br.csfa));
	disp(sprintf('CSA tree HA:   %d', br.csha));
	disp(sprintf('CSA tree regs: %d', br.csregs));
	disp(sprintf('VMA FA:   %d', br.vmafa));
	disp(sprintf('VMA HA:   %d', br.vmaha));
	disp(sprintf('VMA regs: %d', br.vmaregs));
	disp(sprintf('Pipeline delay: %d', br.pipedelay));
end

if cplx.sha.fa > 0
	disp ' '
	disp(sprintf('Shared adders: %d', cplx.sha.fa));
	disp(sprintf('Shared registers: %d', cplx.sha.regs));
end

disp ' '
disp(sprintf('Total FA:   %d', cplx.ppfa+cplx.csfa+cplx.vmafa+cplx.sha.fa));
disp(sprintf('Total HA:   %d', cplx.ppha+cplx.csha+cplx.vmaha));
disp(sprintf('Total regs: %d', cplx.ppregs+cplx.csregs+cplx.vmaregs+cplx.sha.regs));

