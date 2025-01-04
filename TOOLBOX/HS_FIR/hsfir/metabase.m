%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

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

basefiles = {'base/fa.vhdl', 'base/fa_noc.vhdl', 'base/ha.vhdl', ...
	'base/ha_noc.vhdl', 'base/dff.vhdl', 'base/reg.vhdl', ...
	'base/scmult.vhdl', 'base/ucmult.vhdl', ...
	'base/sadd.vhdl', 'base/uadd.vhdl', ...
	'base/clkgen.vhdl', 'base/stimgen.vhdl', 'base/cmp.vhdl'};

meta(basefiles, 'vhdlbase');

