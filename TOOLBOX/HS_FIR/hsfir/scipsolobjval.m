function val = scipsolobjval(sol)
%val = scipsolobjval(sol)
%
%Returns the objective value in the solution structure

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
	error 'scipsolobjval: missing argument';
end

% Check solution status
if sol.status ~= 0
	error 'scipsolobjval: sol contains no solution';
end

val = sol.objval;

