function comp = hdlpptfc(name, numin, wdata)
%comp = hdlpptfc(name, numin, wdata)

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
comp.arch.components = {};
comp.arch.instances = [];
comp.arch.signals = [];

kin = 0;
kout = 0;
kass = 0;

for b = 0:numin-1
	kin = kin + 1;
	comp.iface.inputs(kin) = hdlsignal(sprintf('x_%d', b), 1, wdata);
	kout = kout + 1;
	comp.iface.outputs(kout) = hdlsignal(sprintf('xc_%d', b), 1, wdata);
	kass = kass + 1;
	comp.arch.assignments(kass) = hdlass(sprintf('xc_%d', b), sprintf('x_%d', b), 1);
end

