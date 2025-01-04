function vmaspec = makercvma(csspec, archspec)
%vmaspec = makercvma(csspec, archspec)
%
%Creates a ripple-carry VMA for a specified CS tree.
%Inputs:
%  csspec - the CS tree to create a ripple-carry VMA for
%  archspec - architecture specification, structure with fields:
%    maxheight: maximum number of adders in critical path
%Outputs:
%  vmaspec - structure describing placement of adders in a CS tree
%            implementing a ripple-carry VMA

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

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

