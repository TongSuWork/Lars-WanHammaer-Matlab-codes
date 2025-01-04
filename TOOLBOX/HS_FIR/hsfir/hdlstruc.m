function comp = hdlstruc(name, generics, inputs, outputs)
%comp = hdlstruc(name, generics, inputs, outputs)

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

comp.iface.name = name;
comp.iface.generics = generics;
comp.iface.inputs = inputs;
comp.iface.outputs = outputs;

comp.arch.class = 2;
comp.arch.components = {};
comp.arch.signals = [];
comp.arch.instances = [];
comp.arch.assignments = [];

k = 0;
for kin = 1:length(inputs)
	k = k + 1;
	comp.arch.signals(k).name = strcat('in_', inputs(kin).name);
	comp.arch.signals(k).type = inputs(kin).type;
	comp.arch.assignments(k).class = 1;
	comp.arch.assignments(k).dest = comp.arch.signals(k).name;
	comp.arch.assignments(k).src.ref = inputs(kin).name;
end

for kout = 1:length(outputs)
	k = k + 1;
	comp.arch.signals(k).name = strcat('out_', outputs(kout).name);
	comp.arch.signals(k).type = outputs(kout).type;
	comp.arch.assignments(k).class = 1;
	comp.arch.assignments(k).dest = outputs(kout).name;
	comp.arch.assignments(k).src.ref = comp.arch.signals(k).name;
end

