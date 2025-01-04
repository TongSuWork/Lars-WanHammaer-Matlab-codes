function str = hdlgensigrefimage(sigref, hdlconf)
%str = hdlgensigrefimage(sigref, hdlconf)

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

if isfield(sigref, 'mod')
	mod = sigref.mod;
else
	mod = 0;
end

if isempty(mod)
	str = sigref.name;
	return
end

switch sigref.type.class
case 0,
	if length(mod) == 1
		if mod == 0
			str = sigref.name;
		elseif mod == 1
			str = strcat('not ', sigref.name);
		else
			error ('hdlgensigrefimage : invalid sigref for %s', sigref.name);
		end
	else
		error ('hdlgensigrefimage : invalid sigref for %s', sigref.name);
	end
case 1,
	notstr = '';
	selstr = '';
	while length(mod) > 0
		switch mod(1)
		case 0,
			mod = mod(2:end);
		case 1,
			notstr = 'not ';
			mod = mod(2:end);
		case 2,
			if length(mod) < 2
				error('hdlgensigrefimage : invalid mod %sfor sigref %s class 1', sprintf('%d ', sigref.mod), sigref.name);
			end
			selstr = sprintf('(%d)', mod(2));
			mod = mod(3:end);
		case 3,
			if length(mod) < 3
				error('hdlgensigrefimage : invalid mod %sfor sigref %s class 1', sprintf('%d ', sigref.mod), sigref.name);
			end
			selstr = sprintf('(%d downto %d)', mod(3), mod(2));
			mod = mod(4:end);
		otherwise,
			error('hdlgensigrefimage : invalid mod %sfor sigref %s class 1', sprintf('%d ', sigref.mod), sigref.name);
		end
	end

	str = strcat(notstr, sigref.name, selstr);
case 2,
	if length(mod) > 0
		switch mod(1)
		case 0,
			str = sigref.name;
		case 1,
			if length(mod) < 2
				error('hdlgensigrefimage : invalid mod %sfor sigref %s class 2', sprintf('%d ', sigref.mod), sigref.name);
			end
			str = sprintf('%s + %d', sigref.name, mod(2));
		otherwise,
			error ('hdlgensigrefimage : invalid sigref for %s', sigref.name);
		end
	else
		str = sigref.name;
	end
otherwise,
	error ('hdlgensigrefimage : invalid type class for %s', sigref.name);
end

