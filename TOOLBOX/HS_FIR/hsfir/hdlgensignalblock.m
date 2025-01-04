function hdlgensignalblock(fid, signals, prefix, infix, suffix, sep, hdlconf)
%hdlgensignalblock(fid, signals, prefix, infix, suffix, sep, hdlconf)

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

numsignals = length(signals);

sep = sprintf(sep);
suffix = sprintf(suffix);

s = '';

for k = 1:numsignals
	fprintf(fid, '%s%s%s %s %s%s', s, prefix, signals(k).name, infix, ...
		hdlgensignaltypeimage(signals(k).type, hdlconf), suffix);
	s = sep;
end

