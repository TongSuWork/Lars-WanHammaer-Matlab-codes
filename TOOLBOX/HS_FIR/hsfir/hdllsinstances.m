function hdllsinstances(comp, hdlconf)
%hdllsinstances(comp[, hdlconf])
%
%Lists all instances in a component architecture
%Uses the format specified in hdlconf, or VHDL if not specified.

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

if nargin < 2
	hdlconf = [];
end

if comp.arch.class ~= 2
	disp('Not a struc2 component');
	return
end

instances = comp.arch.instances;

numinstances = length(instances);

disp(sprintf('Number of instances: %d', numinstances));
for k = 1:numinstances
	mapstr = '';
	maps = [instances(k).generics;instances(k).inputs;instances(k).outputs];
	for l = 1:length(maps)
		if isfield(maps(l), 'actualmod')
			modstr = sprintf('[%s]', sprintf(' %d', maps(l).actualmod));
		else
			modstr = '';
		end
		map = sprintf('%s => %s%s', maps(l).formal, maps(l).actual, modstr);
		mapstr = sprintf('%s, %s', mapstr, map);
	end
	mapstr = mapstr(3:end);
	disp(sprintf('%s: %s', instances(k).type, mapstr));
end

