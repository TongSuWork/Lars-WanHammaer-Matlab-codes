function map = hdlmap(formal, actual, class, mod)
%map = hdlmap(formal, actual[, class, mod])
%
%Creates a hdlmap2 structure
%
%Arguments:
%  formal - formal of map
%  actual - actual of map
%  class
%    0: constant map
%      numeric actual: 
%        mod = []: formal => actual
%        mod = 'timens': formal => actual ns
%      string actual: formal => "actual"
%    1: signal map: formal => actual (with optional modifier mod)

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

if nargin < 3
	if isnumeric(actual)
		class = 0;
	else
		class = 1;
	end
end

if nargin < 4
	modspec = 0;
else 
	modspec = 1;
end

map.class = class;
map.formal = formal;

switch class
case 0,
	if isnumeric(actual)
		if modspec == 0
			map.actual = sprintf('%d', actual);
		elseif modspec == 1 && strcmp(mod, 'timens')
			map.actual = sprintf('%d ns', actual);
		end
	elseif ischar(actual)
		map.actual = sprintf('"%s"', actual);
	else
		error('hdlmap: invalid actual for formal %s', formal);
	end
case 1,
	map.actual.ref = actual;
	if modspec == 1
		map.actual.mod = mod;
	end
otherwise,
	error('hdlmap: invalid class %d for formal %s', class, formal);
end

