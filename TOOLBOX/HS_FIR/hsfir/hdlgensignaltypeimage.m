function str = hdlgensignaltypeimage(type, hdlconf)
%str = hdlgensignaltypeimage(type, hdlconf)

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

switch type.class
case 0,
	str = 'std_logic';
case 1,
	str = sprintf('std_logic_vector(%s-1 downto 0)', hdlgenexprimage(type.width, hdlconf));
case 2,
	if isfield(type, 'range')
		str = sprintf('integer range %d to %d', type.range);
	else
		str = 'integer';
	end
case 256,
	str = 'time';
case 257,
	str = 'string';
otherwise,
	error 'hdlgensignaltypeimage: illegal signal type %d', type.class;
end

