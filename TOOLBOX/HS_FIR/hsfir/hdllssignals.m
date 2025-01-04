function hdllssignals(comp, hdlconf)
%hdllssignals(comp[, hdlconf])
%
%Lists all signals in a component architecture
%Uses the format specified in hdlconf, or VHDL if not specified.

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

if nargin < 2
	hdlconf = [];
end

if comp.arch.class ~= 2
	disp('Not a struc2 component');
	return
end

signals = comp.arch.signals;

numsignals = length(signals);

disp(sprintf('Number of signals: %d', numsignals));
for k = 1:numsignals
	disp(sprintf('%s: %s', signals(k).name, ...
		hdlgensignaltypeimage(signals(k).type, hdlconf)));
end

