function comp = hdlcs(name, csspec, csmap)
%comp = hdlcs(name, csspec, csmap)

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

comp.iface.name = name;
comp.iface.generics = [];

% Generate module inputs
kin = 0;
for l = 1:size(csspec.ppin, 1)
	for w = 1:size(csspec.ppin, 2)
		if csspec.ppin(l,w) > 0
			kin = kin + 1;
			comp.iface.inputs(kin) = hdlsignal(sprintf('in_%d_%d', l, w), 1, csspec.ppin(l,w));
		end
	end
end

% Generate module outputs
kout = 0;
for w = 1:size(csspec.bout, 2)
	if csspec.bout(w) > 0
		kout = kout + 1;
		comp.iface.outputs(kout) = hdlsignal(sprintf('out_%d', w), 1, csspec.bout(w));
	end
end

comp.arch.class = 2;
comp.arch.components = {'fa', 'ha', 'fa_noc', 'ha_noc', 'dff'};
comp.arch.signals = struct('name', {}, 'type', {});
comp.arch.instances = struct('type', {}, 'generics', {}, 'inputs', {}, 'outputs', {});

ksig = 0;
kout = 0;
kinst = 0;
kass = 0;

% Generate cell signals
cellin = csspec.bits;
for l = 1:size(cellin, 1)
	for w = 1:size(cellin, 2)
		if cellin(l,w) > 0
			ksig = ksig + 1;
			comp.arch.signals(ksig) = hdlsignal(sprintf('cellin_%d_%d', l, w), 1, cellin(l,w));
		end
	end
end

cellout = csspec.bits(2:end, :)-[csspec.ppin(2:end, :); zeros(1, csmap.W)];
for l = 1:size(cellout, 1)
	for w = 1:size(cellout, 2)
		if cellout(l,w) > 0
			ksig = ksig + 1;
			comp.arch.signals(ksig) = hdlsignal(sprintf('cellout_%d_%d', l, w), 1, cellout(l,w));
		end
	end
end

% Generate cell input assignments
for i = 1:size(csmap.pp, 1)
	l = csmap.pp(i, :);
	kass = kass + 1;
	comp.arch.assignments(kass) = hdlass(sprintf('cellin_%d_%d', l(1), l(2)), ...
		sprintf('in_%d_%d', l(1), l(2)), 1, [2 l(4)], [2 l(3)]);
end

% Generate map of constant vector inputs
for i = 1:size(csmap.cin, 1)
	l = csmap.cin(i, :);
	kass = kass + 1;
	comp.arch.assignments(kass) = hdlass(sprintf('cellin_%d_%d', l(1), l(2)), '''1''', [2 l(3)]);
end

% Generate FA mapping
for n = 1:size(csmap.fa, 1)
	line = csmap.fa(n, :);
	level = line(1);
	bit = line(2);
	in1 = line(3);
	in2 = line(4);
	in3 = line(5);
	outs = line(6);
	outc = line(7);
	kinst = kinst + 1;
	if outc == -1
		comp.arch.instances(kinst) = hdlinst('fa_noc', [], ...
			[hdlmap('in1', sprintf('cellin_%d_%d', level, bit), 1, [2 in1]);
			 hdlmap('in2', sprintf('cellin_%d_%d', level, bit), 1, [2 in2]);
			 hdlmap('in3', sprintf('cellin_%d_%d', level, bit), 1, [2 in3])], ...
			[hdlmap('outs', sprintf('cellout_%d_%d', level, bit), 1, [2 outs])]);
	else
		comp.arch.instances(kinst) = hdlinst('fa', [], ...
			[hdlmap('in1', sprintf('cellin_%d_%d', level, bit), 1, [2 in1]);
			 hdlmap('in2', sprintf('cellin_%d_%d', level, bit), 1, [2 in2]);
			 hdlmap('in3', sprintf('cellin_%d_%d', level, bit), 1, [2 in3])], ...
			[hdlmap('outs', sprintf('cellout_%d_%d', level, bit), 1, [2 outs]);
			 hdlmap('outc', sprintf('cellout_%d_%d', level, bit-1), 1, [2 outc])]);
	end
end

% Generate HA mapping
for n = 1:size(csmap.ha, 1)
	line = csmap.ha(n, :);
	level = line(1);
	bit = line(2);
	in1 = line(3);
	in2 = line(4);
	outs = line(5);
	outc = line(6);
	kinst = kinst + 1;
	if outc == -1
		comp.arch.instances(kinst) = hdlinst('ha_noc', [], ...
			[hdlmap('in1', sprintf('cellin_%d_%d', level, bit), 1, [2 in1]);
			 hdlmap('in2', sprintf('cellin_%d_%d', level, bit), 1, [2 in2])], ...
			[hdlmap('outs', sprintf('cellout_%d_%d', level, bit), 1, [2 outs])]);
	else
		comp.arch.instances(kinst) = hdlinst('ha', [], ...
			[hdlmap('in1', sprintf('cellin_%d_%d', level, bit), 1, [2 in1]);
			 hdlmap('in2', sprintf('cellin_%d_%d', level, bit), 1, [2 in2])], ...
			[hdlmap('outs', sprintf('cellout_%d_%d', level, bit), 1, [2 outs]);
			 hdlmap('outc', sprintf('cellout_%d_%d', level, bit-1), 1, [2 outc])]);
	end
end

% Generate feed-through connections
for n = 1:size(csmap.feed, 1)
	line = csmap.feed(n, :);
	level = line(1);
	bit = line(2);
	in = line(3);
	out = line(4);
	kass = kass + 1;
	comp.arch.assignments(kass) = hdlass(sprintf('cellout_%d_%d', level, bit), ...
		sprintf('cellin_%d_%d', level, bit), 1, [2 out], [2 in]);
end

% Generate cell interconnections with registers
for n = 1:size(csmap.reg, 1)
	line = csmap.reg(n, :);
	level = line(1);
	bit = line(2);
	in = line(3);
	out = line(4);
	kinst = kinst + 1;
	comp.arch.instances(kinst) = hdlinst('dff', [], ...
		hdlmap('d', sprintf('cellout_%d_%d', level, bit), 1, [2 in]), ...
		hdlmap('q', sprintf('cellin_%d_%d', level+1, bit), 1, [2 out]));
end

% Generate cell interconnections without registers
for n = 1:size(csmap.conn, 1)
	line = csmap.conn(n, :);
	level = line(1);
	bit = line(2);
	in = line(3);
	out = line(4);
	kass = kass + 1;
	comp.arch.assignments(kass) = hdlass(sprintf('cellin_%d_%d', level+1, bit), ...
		sprintf('cellout_%d_%d', level, bit), 1, [2 out], [2 in]);
end

% Generate connections to module output
for w = 1:size(csspec.bout, 2)
	if csspec.bout(w) > 0
		kass = kass + 1;
		comp.arch.assignments(kass) = hdlass(sprintf('out_%d', w), sprintf('cellin_%d_%d', csmap.L, w));
	end
end

