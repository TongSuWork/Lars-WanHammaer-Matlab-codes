function hdlgencomponent(dir, comp, hdlconf)
%hdlgencomponent(dir, comp, hdlconf)

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

if comp.arch.class == 0 && hdlconf.leafstub == 0
	return
end

fid = fopen(strcat(dir, '/', comp.iface.name, '.vhdl'), 'w');

if fid == -1
	error 'hdlgencomponent: failed creating file %s', strcat(compname, '.vhdl');
end

hdlgenheader(fid, hdlconf);

fprintf(fid, '\n');

hdlgeninterface(fid, comp.iface, hdlconf);

fprintf(fid, '\n');

if comp.arch.class == 0
	hdlgenarchleaf(fid, comp.iface.name, comp.arch, hdlconf);
elseif comp.arch.class == 1
	hdlgenarchstruc(fid, comp.iface.name, comp.arch, hdlconf);
end

fclose(fid);

