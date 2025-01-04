	function s = scipinit(scippath)	%s = scipinit(scippath)	%	%Arguments:	%  scippath - path to scip	%	%Returns:	%  s - internal structure, use in subsequent calls to scip functions		%Copyright 2010 Anton Blad	%	%This file is part of mscip.	%	%mscip is free software: you can redistribute it and/or modify	%it under the terms of the GNU General Public License as published by	%the Free Software Foundation, either version 3 of the License, or	%(at your option) any later version.	%	%mscip is distributed in the hope that it will be useful,	%but WITHOUT ANY WARRANTY; without even the implied warranty of	%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	%GNU General Public License for more details.	%	%You should have received a copy of the GNU General Public License	%along with mscip.  If not, see <http://www.gnu.org/licenses/>		if ~ischar(scippath)		error 'scipinit: scippath must be string';	end		[stat, res] = system(sprintf('%s -c quit', scippath));	if stat ~= 0		error('scipinit: invoking %s failed, reason:\n%s', scippath, res);	end		s.scip = scippath;	s.glpsol = '';	s.log = 0;	s.maxtime = 1e20;	s.maxmem = 1e20;	