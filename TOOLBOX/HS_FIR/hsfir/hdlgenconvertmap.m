function map = hdlgenconvertmap(map, flist, alist)
%map = hdlgenconvertmap(map, flist, alist)
%
%Converts a hdlmap2 struct to a hdlmap1 struct.
%
%Arguments:
%  map - hdlmap2 struct
%  flist - signal list containing the formal
%  alist - signal list containing the actual
%Returns:
%  map - hdlmap1 struct

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

fsig = hdlgenfindsignal(flist, map.formal);

if isempty(fsig)
	error ('hdlgenconvertmap: formal %s not found in flist', map.formal);
end

switch map.class
case 0,
case 1,
	asig = hdlgenfindsignal(alist, map.actual.ref);
	if isempty(asig)
		error ('hdlgenconvertmap: actual %s not found in alist', map.actual.ref);
	end

	actual.name = map.actual.ref;
	actual.type = asig.type;
	if isfield(map.actual, 'mod')
		actual.mod = map.actual.mod;
	else
		actual.mod = [];
	end
	map.actual = actual;
otherwise
	error 'hdlgenconvertmap: invalid map class'
end

