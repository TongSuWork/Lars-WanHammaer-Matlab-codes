function [csspec, solfound] = optcstree(ppspec, archspec, optspec)
%[csspec, solfound] = optcstree(ppspec, archspec, optspec)

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

firgenconf;

workdir = sprintf('%s/opt-%d-%d', optspec.optdir, optspec.numstages, optspec.constrained);

if OPT_DISPCMD == 1
	disp(sprintf('Working in %s', workdir));
end

problem = 'csatree';

modfile = strcat(FIRGEN_DIR, '/', problem, '.mod');
datfile = strcat(workdir, '/', problem, '.dat');
lpfile = strcat(workdir, '/', problem, '.lp');
solfile = strcat(workdir, '/', problem, '.sol');
glplogfile = strcat(workdir, '/', problem, '-glp.log');
scipscrfile = strcat(workdir, '/', problem, '-scip.scr');
sciplogfile = strcat(workdir, '/', problem, '-scip.log');

disp(sprintf('Optimizing filter with stages=%d, height=%d, constrained=%d', ...
	optspec.numstages, archspec.maxheight, optspec.constrained));

lpspec.numstages = optspec.numstages;
lpspec.maxheight = archspec.maxheight;
lpspec.wordlength = size(ppspec.bits, 2);
lpspec.inbits = zeros(lpspec.maxheight*lpspec.numstages, lpspec.wordlength);
lpspec.cterm = ppspec.cterm;
lpspec.constrained = optspec.constrained;
lpspec.costs = optspec.costs;

if size(lpspec.inbits, 1) < size(ppspec.bits, 1) || size(lpspec.inbits, 2) ~= size(ppspec.bits, 2)
	error(sprintf('optcstree: inbits has wrong size %dx%d', size(lpspec.inbits)));
end

lpspec.inbits(1:size(ppspec.bits, 1), :) = ppspec.bits;

if optspec.forceopt == 0 && isdir(workdir)
	if OPT_DISPCMD == 1
		disp('Data exists, not invoking optimizer');
	end
else
	if ~isdir(workdir)
		mkdir(workdir);
	end

	gencslp(datfile, lpspec);

	s = scipinit(OPT_SCIP);
	s = scipsetoption(s, 'glpsol', OPT_GLPSOL);
	s = scipsetoption(s, 'log', 1);
	if OPT_MAXTIME > 0
		s = scipsetoption(s, 'maxtime', OPT_MAXTIME);
	end
	if OPT_MAXMEM > 0
		s = scipsetoption(s, 'maxmem', OPT_MAXMEM);
	end

	scipsolve(s, 'moddat', modfile, datfile, solfile);
end

sol = scipparsesol(solfile);
if scipsolstatus(sol) == 0
	solfound = 1;
	l = lpspec.maxheight*lpspec.numstages;
	w = lpspec.wordlength;
	csspec.ppin = lpspec.inbits;
	csspec.cin = round(scipsoldata(sol, 'cinput', [l w], [0 1]));
	csspec.bits = round(scipsoldata(sol, 'bits', [l+1 w], [0 1]));
	csspec.fa = round(scipsoldata(sol, 'FA', [l w], [0 1]));
	csspec.ha = round(scipsoldata(sol, 'HA', [l w], [0 1]));
	csspec.regs = round(scipsoldata(sol, 'regs', [l w], [0 1]));
	csspec.bout = csspec.bits(end, :);
else
	solfound = 0;
	csspec = [];
end

