function comp = hdlconnect(comp, srcid, srcsig, dstid, dstsig)
%comp = hdlconnect(comp, srcid, srcsig, dstid, dstsig)

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

kass = length(comp.arch.assignments);

srcmask = strcat(srcid, '_', srcsig);
dstmask = strcat(dstid, '_', dstsig);

srcsigs = hdlgenmatchsignals(comp.arch.signals, srcmask);
dstsigs = hdlgenmatchsignals(comp.arch.signals, dstmask);

while length(srcsigs) > 0
	srcsig = 1;
	srcsigname = srcsigs(srcsig).name;
	sigtail = srcsigname(length(srcmask)+1:end);
	dstsigname = strcat(dstmask, sigtail);

	dstsig = -1;
	for k = 1:length(dstsigs)
		if strcmp(dstsigs(k).name, dstsigname)
			if dstsig ~= -1
				disp(sprintf('hdlconnect: dst signal %s occurred twice', dstsigname));
			end
			dstsig = k;
		end
	end
	if dstsig == -1
		disp(sprintf('hdlconnect: dst signal %s not found for src signal %s', dstsigname, srcsigname));
	else
		%disp(sprintf('assigning %s <= %s', dstsigname, srcsigname));

		kass = kass + 1;
		comp.arch.assignments(kass).class = 1;
		comp.arch.assignments(kass).dest = dstsigname;
		comp.arch.assignments(kass).src.ref = srcsigname;

		dstsigs(dstsig) = [];
	end
	srcsigs(srcsig) = [];
end

for k = 1:length(dstsigs)
	disp(sprintf('hdlconnect: dst signal %s unconnected', dstsigs(k).name));
end

