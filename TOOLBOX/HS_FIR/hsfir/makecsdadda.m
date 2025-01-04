function csspec = makecsdadda(ppspec, archspec)
%csspec = makecsdadda(ppspec, archspec)
%
%Create a Dadda tree to sum partial products.
%Inputs:
%  ppspec - partial product specification
%  archspec - architecture specification
%Outputs:
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

inbits = ppspec.inbits;
cterm = ppspec.cterm;
maxheight = archspec.maxheight;

bits = inbits;
bits(1, :) = bits(1, :) + cterm;
fa = [];
ha = [];

W = size(inbits, 2);
M = size(inbits, 1);

m = 1;

obits = zeros(M, W);

while m <= M || max(bits(end, :)) > 2
	% Maximum number of bit products in current level
	bitst = bits(m, :);
	maxbits = max(bitst);

	% Find the number of bit products to target for next level
	t = 2;
	target = 2;
	while t < maxbits
		target = t;
		t = floor(target*3/2);
	end

	% Find the number of FA and HA for each bit
	carry = 0;
	fat = zeros(1, W);
	hat = zeros(1, W);
	for w = W:-1:1
		b = carry + bitst(w);
		if b > target
			fat(w) = floor((b - target)/2);
			hat(w) = b-target-2*fat(w);
		end
		carry = fat(w) + hat(w);
	end

	fa = [fa; fat];
	ha = [ha; hat];
	if m >= M
		bits = [bits; zeros(1, W)];
	end
	a = fa(end, :) + ha(end, :);
	obits(m, :) = bits(m, :) - 3*fa(m, :) - 2*ha(m, :) + [a(2:end) 0] + a;
	bits(m+1, :) = bits(m+1, :) + obits(m, :);
	m = m + 1;
end

regs = zeros(size(bits, 1)-1, size(bits, 2));

for m = maxheight:maxheight:size(regs, 1)
	regs(m, :) = obits(m, :);
end

outdelay = mod(size(regs, 1), maxheight);

ppin = zeros(size(bits, 1)-1, size(bits, 2));
ppin(1:size(inbits, 1), :) = inbits;
cin = zeros(size(bits, 1)-1, size(bits, 2));
cin(1, :) = cterm;

csspec.ppin = ppin;
csspec.cin = cin;
csspec.bits = bits;
csspec.fa = fa;
csspec.ha = ha;
csspec.regs = regs;
csspec.bout = bits(end, :);
csspec.outdelay = outdelay;

