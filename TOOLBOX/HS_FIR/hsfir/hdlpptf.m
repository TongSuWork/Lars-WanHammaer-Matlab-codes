function comp = hdlpptf(name, inputs, bits)
%comp = hdlpptf(name, inputs, bits)

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
comp.iface.inputs = inputs;
comp.arch.class = 2;
comp.arch.components = {};
comp.arch.signals = [];
comp.arch.instances = [];
kout = 0;
ka = 0;
for l = 1:size(bits, 1)
	for w = 1:size(bits, 2)
		numpp = size(bits{l,w}, 1);
		if numpp > 0
			pp = bits{l,w};
			kout = kout + 1;
			comp.iface.outputs(kout) = hdlsignal(sprintf('pp_%d_%d', l, w), 1, numpp);
			for k = 1:numpp
				source = pp(k,1);
				switch source
				case 0,
					inbranch = pp(k,2);
					bit = pp(k,3);
					weight = pp(k,4);
					ka = ka + 1;
					comp.arch.assignments(ka) = hdlass(sprintf('pp_%d_%d', l, w), ...
						sprintf('xc_%d', inbranch), 1, [2 k-1], [(weight==-1) 2 bit]);
				case 1,
					shaid = pp(k,2);
					bit = pp(k,3);
					weight = pp(k,4);
					ka = ka + 1;
					comp.arch.assignments(ka) = hdlass(sprintf('pp_%d_%d', l, w), ...
						sprintf('sha_%d', shaid), 1, [2 k-1], [(weight==-1) 2 bit]);
				otherwise,
					error 'not yet'
				end
			end
		end
	end
end

