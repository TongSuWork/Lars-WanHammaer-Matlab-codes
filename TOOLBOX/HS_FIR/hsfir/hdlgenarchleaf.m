function hdlgenarchleaf(fid, name, arch, hdlconf)
%hdlgenarchleaf(fid, name, arch, hdlconf)

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

fprintf(fid, 'architecture behav of %s is\n', name);
fprintf(fid, '\n');
fprintf(fid, 'begin\n');
fprintf(fid, '\n');
fprintf(fid, 'end behav;\n');

