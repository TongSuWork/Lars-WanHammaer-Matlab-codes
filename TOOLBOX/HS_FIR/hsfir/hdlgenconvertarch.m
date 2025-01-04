function arch = hdlgenconvertarch(interface, arch, components, hdlconf)
%arch = hdlgenconvertarch(interface, arch, components, hdlconf)

%Copyright 2010 Anton Blad

%This file is part of vhdlgen.

%vhdlgen is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.

%vhdlgen is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.

%You should have received a copy of the GNU General Public License
%along with vhdlgen.  If not, see <http://www.gnu.org/licenses/>.

arch.class = 1;

allinterfaces = [components.iface];

numinstances = length(arch.instances);

arch.components = {};
for i = 1:numinstances
	arch.components = unique({arch.components{:}, arch.instances(i).type});
end

numcomponents = length(arch.components);

if numcomponents == 0
	s1comps = struct([]);
else
	for k = 1:numcomponents
		iface = hdlgenfindinterface(allinterfaces, arch.components{k});
		if isempty(iface)
			error('hdlgenconvertarch: interface %s not found', arch.components{k});
		end
		s1comps(k) = iface;
	end
end

arch.components = s1comps;

constants = interface.generics;
destsignals = [interface.outputs, arch.signals];
srcsignals = [interface.inputs, arch.signals];

for i = 1:numinstances
	inst = arch.instances(i);
	comp = hdlgenfindinterface(arch.components, inst.type);
	if isempty(comp)
		error('hdlgenconvertarch: component %s not found while converting instance %d', inst.type, i);
	end

	% TODO: Generics conversion

	numgenerics = length(inst.generics);
	numinputs = length(inst.inputs);
	numoutputs = length(inst.outputs);

	generics = struct('class', {}, 'formal', {}, 'actual', {});
	for k = 1:numgenerics
		try
			generics(k) = hdlgenconvertmap(inst.generics(k), comp.generics, constants);
		catch exc
			error('%s\nhdlgenconvertarch: while converting generic map %d for instance %d(%s)', ...
				exc.message, k, i, inst.type);
		end
	end
	inst.generics = generics;

	inputs = struct('class', {}, 'formal', {}, 'actual', {});
	for k = 1:numinputs
		try
			inputs(k) = hdlgenconvertmap(inst.inputs(k), comp.inputs, srcsignals);
		catch exc
			error('%s\nhdlgenconvertarch: while converting input map %d for instance %d(%s)', ...
				exc.message, k, i, inst.type);
		end
	end
	inst.inputs = inputs;

	outputs = struct('class', {}, 'formal', {}, 'actual', {});
	for k = 1:numoutputs
		try
			outputs(k) = hdlgenconvertmap(inst.outputs(k), comp.outputs, destsignals);
		catch exc
			error('%s\nhdlgenconvertarch: while converting output map %d for instance %d(%s)', ...
				exc.message, k, i, inst.type);
		end
	end
	inst.outputs = outputs;

	arch.instances(i) = inst;
end

s1assignments = struct('class', {}, 'dest', {}, 'src', {});
numassignments = length(arch.assignments);
for i = 1:numassignments
	dsig = hdlgenfindsignal(destsignals, arch.assignments(i).dest);
	if isempty(dsig)
		error('hdlgenconvertarch: dst signal %s does not exist for assignment %d while converting interface %s', ... 
			arch.assignments(i).dest, i, interface.name);
	end

	s1assignments(i).class = arch.assignments(i).class;
	s1assignments(i).dest.name = arch.assignments(i).dest;
	s1assignments(i).dest.type = dsig.type;
	if isfield(arch.assignments(i), 'destmod')
		s1assignments(i).dest.mod = arch.assignments(i).destmod;
	end

	switch s1assignments(i).class
	case 0,
		s1assignments(i).src = arch.assignments(i).src;
	case 1,
		ssig = hdlgenfindsignal(srcsignals, arch.assignments(i).src.ref);
		if isempty(ssig)
			error('hdlgenconvertarch: src signal %s does not exist for assignment %d while converting interface %s', ...
				arch.assignments(i).src.ref, i, interface.name);
		end

		s1assignments(i).src.name = arch.assignments(i).src.ref;
		s1assignments(i).src.type = ssig.type;
		if isfield(arch.assignments(i).src, 'mod')
			s1assignments(i).src.mod = arch.assignments(i).src.mod;
		end
	otherwise,
		error('hdlgenconvertarch: invalid assignment class %d for assignment %d', ass.class, i);
	end
end
arch.assignments = s1assignments;

