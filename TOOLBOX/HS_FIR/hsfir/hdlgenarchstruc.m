function hdlgenarchstruc(fid, name, arch, hdlconf)
%hdlgenarchstruc(fid, name, arch, hdlconf)

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

numcomponents = length(arch.components);
numsignals = length(arch.signals);
numinstances = length(arch.instances);
numassignments = length(arch.assignments);

fprintf(fid, 'architecture generated of %s is\n', name);
fprintf(fid, '\n');

for k = 1:numcomponents
	fprintf(fid, '  component %s\n', arch.components(k).name);
	if length(arch.components(k).generics) > 0
		fprintf(fid, '    generic (\n');
		hdlgensignalblock(fid, arch.components(k).generics, '      ', ':', '', ';\n', hdlconf);
		fprintf(fid, ');\n');
		fprintf(fid, '\n');
	end

	if length(arch.components(k).inputs) + length(arch.components(k).outputs) > 0
		fprintf(fid, '    port (\n');
		hdlgensignalblock(fid, arch.components(k).inputs, '      ', ': in', '', ';\n', hdlconf);
		if ~isempty(arch.components(k).inputs) && ~isempty(arch.components(k).outputs)
			fprintf(fid, ';\n');
		end
		hdlgensignalblock(fid, arch.components(k).outputs, '      ', ': out', '', ';\n', hdlconf);
		fprintf(fid, ');\n');
	end
	fprintf(fid, '  end component;\n');
	fprintf(fid, '\n');
end

hdlgensignalblock(fid, arch.signals, '  signal ', ':', ';\n', '', hdlconf);

fprintf(fid, 'begin\n');
fprintf(fid, '\n');

for k = 1:numinstances
	fprintf(fid, '  inst_%d: %s', k, arch.instances(k).type);
	if length(arch.instances(k).generics) > 0
		fprintf(fid, '\n');
		fprintf(fid, '    generic map(\n');
		hdlgensignalmap(fid, arch.instances(k).generics, '      ', hdlconf);
		fprintf(fid, ')');
	end
	if length(arch.instances(k).inputs) + length(arch.instances(k).outputs) > 0
		fprintf(fid, '\n');
		fprintf(fid, '    port map(\n');
		hdlgensignalmap(fid, [arch.instances(k).inputs,arch.instances(k).outputs], '      ', hdlconf);
		fprintf(fid, ')');
	end
	fprintf(fid, ';\n');
	fprintf(fid, '\n');
end

for k = 1:numassignments
	if arch.assignments(k).class == 0
		fprintf(fid, '  %s <= %s;\n', ...
			hdlgensigrefimage(arch.assignments(k).dest, hdlconf), ...
			arch.assignments(k).src);
	elseif arch.assignments(k).class == 1
		fprintf(fid, '  %s <= %s;\n', ...
			hdlgensigrefimage(arch.assignments(k).dest, hdlconf), ...
			hdlgensigrefimage(arch.assignments(k).src, hdlconf));
	else
		error ('hdlgenarchstruc : illegal assignment type for assignment %d', k);
	end
end

fprintf(fid, 'end generated;\n');

