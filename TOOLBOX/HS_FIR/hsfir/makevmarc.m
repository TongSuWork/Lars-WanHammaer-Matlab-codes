function vmaspec = makevmarc(csspec, archspec)
%vmaspec = makevmarc(csspec, archspec)
%
%Creates a ripple-carry VMA for a specified CS tree.
%
%Arguments:
%  csspec - partial product reduction tree specification
%  archspec - architecture specification
%
%Returns:
%  vmaspec - structure describing placement of adders in a CS tree
%            implementing a ripple-carry VMA

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

inbits = csspec.bout;
maxheight = archspec.maxheight;

W = length(inbits);

bits = inbits;
outbits = inbits;
fa = [];
ha = [];
regs = [];

l = mod(size(csspec.bits, 1)-1, maxheight);
l = csspec.outdelay;

piperegs = 0;

while any(outbits > 1)
	i = max(find(outbits > 1));
	adder = zeros(size(inbits));
	adder(i) = 1;
	if outbits(i) == 2
		ha = [ha;adder];
		fa = [fa;zeros(size(inbits))];
	else
		ha = [ha;zeros(size(inbits))];
		fa = [fa;adder];
	end

	outbits(i) = 1;
	if i > 1
		outbits(i-1) = outbits(i-1)+1;
	end
	bits = [bits;outbits];

	l = l + 1;
	if l == maxheight
		regs = [regs;outbits];
		l = 0;
		piperegs = piperegs + 1;
	else
		regs = [regs;zeros(size(inbits))];
	end
end

if l > 0
	bits = [bits;outbits];
	fa = [fa;zeros(size(inbits))];
	ha = [ha;zeros(size(inbits))];
	regs = [regs;outbits];
	piperegs = piperegs + 1;
end

if size(bits, 1) == 1
	bits = [bits;outbits];
	fa = [fa;zeros(size(inbits))];
	ha = [ha;zeros(size(inbits))];
	regs = [regs;zeros(size(inbits))];
end

ppin = [inbits; zeros(size(bits, 1)-2, size(bits, 2))];

cin = zeros(size(ppin));

vmaspec.ppin = ppin;
vmaspec.cin = cin;
vmaspec.bits = bits;
vmaspec.bout = outbits;
vmaspec.fa = fa;
vmaspec.ha = ha;
vmaspec.regs = regs;
vmaspec.piperegs = piperegs;
vmaspec.outdelay = 0;

