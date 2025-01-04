function str = hdlgenexprimage(expr, hdlconf)
%str = hdlgenexprimage(expr, hdlconf)

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

switch expr.class
case 0,
	str = sprintf('%d', expr.val);
case 1,
	if isfield(expr, 'mod')
		if expr.mod(1) == 1
			str = sprintf('%s+%d', expr.ref, expr.mod(2));
		end
	else
		str = sprintf('%s', expr.ref);
	end
otherwise,
	error 'hdlgenexprimage: invalid expression class'
end

