function s = scipsetoption(s, opt, arg)
%s = scipsetoption(s, opt, arg)
%
%Arguments:
%  opt - option to set
%  arg - new option value
%
%Available options:
%  'glpsol' - path to the GLPK solver (needed for some problem formats)
%  'log' - create log files if set to 1
%  'maxtime' - maximum time the solver will run (in secs)
%  'maxmem' - maximum amount of memory to use (in MB)

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

if nargin ~= 3
	error 'scipsetoption: invalid number of arguments';
end

if ~ischar(opt)
	error 'scipsetoption: opt must be string';
end

if strcmp(opt, 'glpsol')
	if ~ischar(arg)
		error 'scipsetoption: glpsol option must be string';
	end
	[stat, res] = system(sprintf('%s --version', arg));
	if stat ~= 0
		error('scipsetoption: invoking %s failed, reason:\n%s', arg, res);
	end
	s.glpsol = arg;
elseif strcmp(opt, 'log')
	if ~isnumeric(arg) || ~isscalar(arg)
		error 'scipsetoption: log option must be scalar integer';
	end
	if arg == 0 || arg == 1
		s.log = arg;
	else
		error 'scipsetoption: valid log options are 0 and 1';
	end
elseif strcmp(opt, 'maxtime')
	if ~isnumeric(arg) || ~isscalar(arg)
		error 'scipsetoption: maxtime option must be scalar number';
	end
	s.maxtime = arg;
elseif strcmp(opt, 'maxmem')
	if ~isnumeric(arg) || ~isscalar(arg)
		error 'scipsetoption: maxmem option must be scalar number';
	end
	s.maxmem = arg;
else
	error('scipsetoption: invalid option %s', opt);
end

