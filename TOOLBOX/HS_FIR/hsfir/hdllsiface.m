function hdllsiface(comp, hdlconf)
%hdllsiface(comp[, hdlconf])
%
%Lists interface of a component
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

generics = comp.iface.generics;
inputs = comp.iface.inputs;
outputs = comp.iface.outputs;

numgenerics = length(generics);
numinputs = length(inputs);
numoutputs = length(outputs);

disp(sprintf('Listing interface for component %s', comp.iface.name));
disp(sprintf('Generics: %d, Inputs: %d, Outputs: %d', numgenerics, numinputs, numoutputs));

for k = 1:numgenerics
	disp(sprintf('Generic %s: %s', generics(k).name, ...
		hdlgensignaltypeimage(generics(k).type, hdlconf)));
end

for k = 1:numinputs
	disp(sprintf('Input %s: %s', inputs(k).name, ...
		hdlgensignaltypeimage(inputs(k).type, hdlconf)));
end

for k = 1:numoutputs
	disp(sprintf('Output %s: %s', outputs(k).name, ...
		hdlgensignaltypeimage(outputs(k).type, hdlconf)));
end

