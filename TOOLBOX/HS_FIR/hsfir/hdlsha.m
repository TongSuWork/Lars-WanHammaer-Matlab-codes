function comp = hdlsha(name, inputs, sha)
%comp = hdlsha(name, inputs, sha)

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
comp.iface.outputs = struct('name', {}, 'type', {});
comp.arch.class = 2;
comp.arch.components = {'fa', 'reg'};
comp.arch.signals = struct('name', {}, 'type', {});
comp.arch.instances = struct('type', {}, 'generics', {}, 'inputs', {}, 'outputs', {});
comp.arch.assignments = struct('class', {}, 'dest', {}, 'destmod', {}, 'src', {});

kout = 0;
ksig = 0;
kinst = 0;
kass = 0;

wpp = (size(sha, 2)-1)/3;

for a = 1:size(sha, 1)
	kout = kout + 1;
	comp.iface.outputs(kout) = hdlsignal(sprintf('sha_%d', a-1), 1, 2);
	
	ppv = [sha(a, 1:wpp); sha(a, wpp+1:2*wpp); sha(a, 2*wpp+1:3*wpp)];

	ksig = ksig + 1;
	comp.arch.signals(ksig) = hdlsignal(sprintf('sha_%d_in', a-1), 1, 3);
	ksig = ksig + 1;
	comp.arch.signals(ksig) = hdlsignal(sprintf('sha_%d_out', a-1), 1, 2);
	ksig = ksig + 1;
	comp.arch.signals(ksig) = hdlsignal(sprintf('sha_%d_s', a-1), 1, 2);

	for v = 1:3
		if ppv(v,1) == 0
			ppsrc = sprintf('xc%s', sprintf('_%d', ppv(v, 2:end-2)));
		elseif ppv(v,1) == 1
			ppsrc = sprintf('sha_%d_s', ppv(v, 2));
		else
			error 'hdlsha: invalid source for shared adder %d', a-1;
		end

		kass = kass + 1;
		comp.arch.assignments(kass) = hdlass(sprintf('sha_%d_in', a-1), ...
			ppsrc, 1, [2 v-1], [ppv(v,end)==-1 2 ppv(v,end-1)]);
	end

	kinst = kinst + 1;
	comp.arch.instances(kinst) = hdlinst('fa', [], ...
		[hdlmap('in1', sprintf('sha_%d_in', a-1), 1, [2 0]);
		 hdlmap('in2', sprintf('sha_%d_in', a-1), 1, [2 1]);
		 hdlmap('in3', sprintf('sha_%d_in', a-1), 1, [2 2])], ...
		[hdlmap('outs', sprintf('sha_%d_out', a-1), 1, [2 0]);
		 hdlmap('outc', sprintf('sha_%d_out', a-1), 1, [2 1])]);

	if sha(a,end) == 1
		kinst = kinst + 1;
		comp.arch.instances(kinst) = hdlinst('reg', ...
			hdlmap('wordlength', 2), ...
			hdlmap('d', sprintf('sha_%d_out', a-1)), ...
			hdlmap('q', sprintf('sha_%d_s', a-1)));
	else
		kass = kass + 1;
		comp.arch.assignments(kass) = hdlass(sprintf('sha_%d_s', a-1), ...
			sprintf('sha_%d_out', a-1));
	end

	kass = kass + 1;
	comp.arch.assignments(kass) = hdlass(sprintf('sha_%d', a-1), ...
		sprintf('sha_%d_s', a-1));
end

