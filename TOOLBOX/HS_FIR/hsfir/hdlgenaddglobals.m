function comp = hdlgenaddglobals(comp, hdlconf)
%comp = hdlgenaddglobals(comp, hdlconf)

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

comp.iface.inputs = [comp.iface.globals, comp.iface.inputs];

switch comp.arch.class
case 1,
	numcomponents = length(comp.arch.components);
	for k = 1:numcomponents
		comp.arch.components(k).inputs = [comp.arch.components(k).globals, comp.arch.components(k).inputs];
	end

	numinstances = length(comp.arch.instances);
	for k = 1:numinstances
		globalmap = struct('class', {}, 'formal', {}, 'actual', {});

		insttype = comp.arch.instances(k).type;
		instif = hdlgenfindinterface(comp.arch.components, insttype);
		numglobals = length(instif.globals);
		for l = 1:numglobals
			globalmap(l).class = 1;
			globalmap(l).formal = instif.globals(l).name;
			globalmap(l).actual.name = instif.globals(l).name;
			globalmap(l).actual.type = instif.globals(l).type;
		end
		comp.arch.instances(k).inputs = [globalmap, comp.arch.instances(k).inputs];
	end
end

