function csspec = makecsra(ppspec, archspec)
%csspec = makecsra(ppspec, archspec)
%
%Creates a partial product reduction tree using a modified Reduced Area 
%heuristic.
%
%Arguments:
%  ppspec - partial product specification
%  archspec - architecture specification
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

inbits = ppspec.inbits;
cterm = ppspec.cterm;
maxheight = archspec.maxheight;

bits = inbits;
bits(end, :) = bits(end, :) + cterm;
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

	if m < M && target == 2
		target = 3;
	end

	% Find the number of FA and HA for each bit
	carry = 0;
	rightmost = 1;
	fat = zeros(1, W);
	hat = zeros(1, W);
	for w = W:-1:1
		if rightmost == 1 && bitst(w) == 2 && m >= M
			hat(w) = 1;
		end
		if bitst(w) > 1
			rightmost = 0;
		end
		fat(w) = floor(bitst(w)/3);
		b = bitst(w)-2*fat(w)+carry;
		if b > target
			hat(w) = 1;
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
	% Sanity check
	if any(obits(m, :) > target)
		disp(sprintf('makecsra: failed sanity check (target=%d) for obits:', target));
		obits(m,:)
	end
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
cin(M, :) = cterm;

csspec.ppin = ppin;
csspec.cin = cin;
csspec.bits = bits;
csspec.fa = fa;
csspec.ha = ha;
csspec.regs = regs;
csspec.bout = bits(end, :);
csspec.outdelay = outdelay;

