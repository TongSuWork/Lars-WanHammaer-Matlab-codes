function hdlgenheader(fid, hdlconf)
%hdlgenheader(fid, hdlconf)

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

fprintf(fid, 'library ieee;\n');
fprintf(fid, 'use ieee.std_logic_1164.all;\n');
fprintf(fid, 'use ieee.numeric_std.all;\n');

