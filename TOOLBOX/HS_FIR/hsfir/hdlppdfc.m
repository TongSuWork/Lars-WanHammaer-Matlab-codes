function comp = hdlppdfc(name, numin, wdata, delays)
%comp = hdlppdfc(name, numin, wdata, delays)

%Copyright 2008, 2010 Anton Blad
%
%This file is part of firgen.
%
%firgen is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%firgen is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with firgen.  If not, see <http://www.gnu.org/licenses/>

comp.iface.name = name;
comp.iface.generics = [];
comp.arch.class = 2;
comp.arch.components = {'reg'};

kin = 0;
kout = 0;
ksig = 0;
kinst = 0;
kass = 0;

for b = 0:numin-1
	kin = kin + 1;
	comp.iface.inputs(kin) = hdlsignal(sprintf('x_%d', b), 1, wdata);
	for d = 0:delays(b+1)
		kout = kout + 1;
		comp.iface.outputs(kout) = hdlsignal(sprintf('xc_%d_%d', b, d), 1, wdata);
		ksig = ksig + 1;
		comp.arch.signals(ksig) = hdlsignal(sprintf('x_%d_%d_s', b, d), 1, wdata);
	end
	for d = 0:delays(b+1)-1
		kinst = kinst + 1;
		comp.arch.instances(kinst).type = 'reg';
		comp.arch.instances(kinst).generics = hdlmap('wordlength', wdata);
		comp.arch.instances(kinst).inputs = hdlmap('d', sprintf('x_%d_%d_s', b, d));
		comp.arch.instances(kinst).outputs = hdlmap('q', sprintf('x_%d_%d_s', b, d+1));
	end
	kass = kass + 1;
	comp.arch.assignments(kass) = hdlass(sprintf('x_%d_0_s', b), sprintf('x_%d', b), 1);
	for d = 0:delays(b+1)
		kass = kass + 1;
		comp.arch.assignments(kass) = hdlass(sprintf('xc_%d_%d', b, d), sprintf('x_%d_%d_s', b, d), 1);
	end
end

