function mat = scipsoldata(sol, var, sz, base)
%mat = scipsoldata(sol, var, sz, base)
%
%Parses the solution sol for the variable var.
%
%Arguments:
%  sol - the solution (structure from scipparsesol)
%  var - the variable name to parse (string)
%  sz - the size of the matrix in which to parse the variable (array)
%  base - index of first elements
%
%Returns:
%  mat - a matrix with size(mat)=[1 1] if sz=[], size(mat)=[1 n] if sz=n,
%        else size(mat)=sz
%
%sz can be:
%  [] if the variable result is scalar (no indeces in solution file)
%  a scalar n if the variable result is one-dimensional
%  a length-k vector if the variable result is k-dimensional
%  omitted, in which case [] is assumed
%
%base:
%  must have same size as sz if specified, defaults to zeros(size(sz))

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

if nargin < 2
	error 'scipsoldata: missing arguments'
elseif nargin < 3
	sz = [];
else
	sz = sz(:)';
	if nargin < 4
		base = zeros(size(sz));
	else
		base = base(:)';
	end
end

% Check solution status
if sol.status ~= 0
	error('scipsoldata: sol contains no solution');
end

% Initialize result matrix
ndim = length(sz);
if ndim == 0
	mat = zeros(1);
elseif ndim == 1
	mat = zeros(1, sz);
else
	mat = zeros(sz);
end

% Look through the parsed elements
for k = 1:length(sol.vars)
	if length(sol.vars{k}) < 1
		continue
	end
	if strcmp(sol.vars{k}.var, var)
		if ndim == 0
			if isfield(sol.vars{k}, 'idx') && ~isempty(sol.vars{k}.idx)
				error ('scipsoldata: no dimensions specified for variable ''%s'' (indeces (%s))', var, sol.vars{k}.idx)
			else
				mat(1) = str2num(sol.vars{k}.val);
			end
		else
			if ~isfield(sol.vars{k}, 'idx') || isempty(sol.vars{k}.idx)
				error ('scipsoldata: dimensions specified for variable ''%s'', but result is scalar', var)
			else
				idx = regexp(sol.vars{k}.idx, ',', 'split');
				for i = 1:length(idx)
					idx{i} = str2num(idx{i})-base(i)+1;
				end
				if length(idx) ~= ndim
					error ('scipsoldata: dimension mismatch for variable ''%s'' (%d specified, but result has %d)', var, ndim, length(idx))
				end
				if any([idx{:}] > sz)
					sol.vars{k}
					[idx{:}]
					sz
					error ('scipsoldata: subscripts out of range for variable ''%s''', var)
				end
				mat(idx{:}) = str2num(sol.vars{k}.val);
			end
		end
	end
end


