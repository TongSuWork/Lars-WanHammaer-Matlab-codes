function hdlgeninterface(fid, iface, hdlconf)
%hdlgeninterface(fid, iface, hdlconf)

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

fprintf(fid, 'entity %s is\n', iface.name);
fprintf(fid, '\n');

if length(iface.generics) > 0
	fprintf(fid, '  generic (\n');
	hdlgensignalblock(fid, iface.generics, '    ', ':', '', ';\n', hdlconf);
	fprintf(fid, ');\n');
	fprintf(fid, '\n');
end

if length(iface.inputs) + length(iface.outputs) > 0
	fprintf(fid, '  port (\n');
	hdlgensignalblock(fid, iface.inputs, '    ', ': in', '', ';\n', hdlconf);
	if ~isempty(iface.inputs) && ~isempty(iface.outputs)
		fprintf(fid, ';\n');
	end
	hdlgensignalblock(fid, iface.outputs, '    ', ': out', '', ';\n', hdlconf);
	fprintf(fid, ');\n');
	fprintf(fid, '\n');
end

fprintf(fid, 'end %s;\n', iface.name);

