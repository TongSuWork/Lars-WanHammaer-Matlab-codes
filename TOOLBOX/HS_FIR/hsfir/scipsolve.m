function scipsolve(s, format, varargin)
%scipsolve(s, format, files...)
%
%Invokes the SCIP solver
%
%Arguments:
%  s - internal structure
%  format - one of
%    'lp' - use .lp in ILOG LP format
%        files: file.lp, file.sol
%    'mod' - use .mod in Mathprog format (requires glpsol)
%        files: file.mod, file.sol
%    'moddat' - use .mod and .dat in Mathprog format (requires glpsol)
%        files: file.mod, file.dat, file.sol

%Copyright 2010 Anton Blad
%
%This file is part of mscip.
%
%mscip is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%mscip is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with mscip.  If not, see <http://www.gnu.org/licenses/>

if strcmp(format, 'moddat')
	if nargin < 5
		error 'scipsolve: moddat solving requires exactly 3 file arguments';
	end
	solf = varargin{3};
elseif strcmp(format, 'mod')
	error 'not implemented';
elseif strcmp(format, 'lp')
	error 'not implemented';
else
	error 'scipsolve: invalid problem format';
end

basef = solf;
idx = strfind(basef, '.');
if ~isempty(idx)
	basef = basef(1:idx(end)-1);
end
glplogf = strcat(basef, '-glp.log');
sciplogf = strcat(basef, '-scip.log');

if s.log == 1
	glplog = sprintf('--log %s', glplogf);
	sciplog = sprintf('-l %s', sciplogf);
else
	glplog = '';
	sciplog = '';
end

if strcmp(format, 'moddat')
	modf = varargin{1};
	datf = varargin{2};
	lpf = strcat(basef, '.lp');

	if isempty(s.glpsol)
		error 'scipsolve: glpsol option not set';
	end

	glpcmd = sprintf('%s --check --wcpxlp %s -m %s -d %s %s > /dev/null', s.glpsol, lpf, modf, datf, glplog);
	[stat, res] = system(glpcmd);
	if stat ~= 0
		error('scipsolve: invoking %s failed, reason:\n%s', glpcmd, res);
	end
end

scrf = strcat(basef, '.scr');
scrid = fopen(scrf, 'w+');
fprintf(scrid, 'read %s\n', lpf);
fprintf(scrid, 'set limits time %f\n', s.maxtime);
fprintf(scrid, 'set limits memory %f\n', s.maxmem);
fprintf(scrid, 'presolve\n');
fprintf(scrid, 'optimize\n');
fprintf(scrid, 'write solution %s\n', solf);
fprintf(scrid, 'quit\n');
fclose(scrid);

scipcmd = sprintf('%s -b %s %s -q', s.scip, scrf, sciplog);
[stat, res] = system(scipcmd);
if stat ~= 0
	error('scipsolve: invoking %s failed, reason:\n%s', scipcmd, res);
end

