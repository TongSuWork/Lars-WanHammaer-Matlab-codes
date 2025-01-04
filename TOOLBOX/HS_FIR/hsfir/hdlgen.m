function hdlgen(dir, hdlspec, hdlconf)
%hdlgen(dir, hdlspec, hdlconf)

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

if nargin < 3
	hdlconf = [];
end

if ~isfield(hdlconf, 'leafstub')
	hdlconf.leafstub = 0;
end

if isfield(hdlconf, 'defaultglobals')
	defaultglobals = hdlconf.defaultglobals;
else
	defaultglobals(1).name = 'clk';
	defaultglobals(1).type.class = 0;
	defaultglobals(2).name = 'reset';
	defaultglobals(2).type.class = 0;
end

if ~isdir(dir)
	mkdir(dir);
end

numcomponents = length(hdlspec.components);

for c = 1:numcomponents
	if ~isfield(hdlspec.components(c).iface, 'globals')
		hdlspec.components(c).iface.globals = defaultglobals;
	end
end

for c = 1:numcomponents
	if hdlspec.components(c).arch.class == 2
		try
			hdlspec.components(c).arch = hdlgenconvertarch(hdlspec.components(c).iface, ...
				hdlspec.components(c).arch, hdlspec.components, hdlconf);
		catch exc
			%exc.message = sprintf('%s\nhdlgen: while converting architecture for component %d(%s)', ...
			%	exc.message, c, hdlspec.components(c).iface.name);
			%rethrow exc
			error('%s\nhdlgen: while converting architecture for component %d(%s)', ...
				exc.message, c, hdlspec.components(c).iface.name);
		end
	end
end

for c = 1:numcomponents
	hdlspec.components(c) = hdlgenaddglobals(hdlspec.components(c), hdlconf);
end

for c = 1:numcomponents
	hdlgencomponent(dir, hdlspec.components(c), hdlconf);
end

