function sol = scipparsesol(solfile)
%sol = scipparsesol(solfile)
%
%Parses a SCIP solution file.
%
%Arguments:
%  solfile - SCIP solution file
%
%Returns:
%  sol - solution structure, to be used with scipsolstatus, scipsolobjval
%        and scipsoldata

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

if nargin < 1
	error 'scipparsesol: missing argument'
end

% Try to open the solution file
fid = fopen(solfile);
if fid == -1
	error('scipparsesol: could not open file %s', solfile);
end

% Read solution status
strstat = fgetl(fid);
if strcmp(strstat, 'solution status: optimal solution found')
	sol.status = 0;
elseif strcmp(strstat, 'solution status: infeasible')
	sol.status = 1;
else
	error('scipparsesol: invalid solution status "%s"', strstat);
end

if sol.status ~= 0
	return
end

% Read objective value
strobj = fgetl(fid);
obj = regexp(strobj, '^objective value:\s+(\d+).*$', 'tokens');
res = obj{1};
sol.objval = str2num(res{1});

% Read the variables
data = fread(fid, inf, 'uint8=>char')';
fclose(fid);
sdata = regexp(data, '\n', 'split');
sol.vars = regexp(sdata, '^(?<var>\w+)\((?<idx>[\d,]+)\)\s+(?<val>\d+)|^(?<var>\w+)(?<idx>)\s+(?<val>\d+)', 'names');

