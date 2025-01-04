function [csspec, solfound] = optcstree_i(ppspec, archspec, optspec, filtspec)
%[csspec solfound] = optcstree_i(ppspec, archspec, optspec, filtspec)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

firgenconf;

workdir = sprintf('%s/opt-%s-%s%d-P%dw%d-J%dK%d-c%d', ...
	optspec.optdir, archspec.type, filtspec.crep.class, filtspec.crep.id, ...
	ppspec.numphases, ppspec.wdata, optspec.numstages, archspec.maxheight, ...
	optspec.constrained);

if OPT_DISPCMD == 1
	disp(sprintf('Working in %s', workdir));
end

problem = 'csatree';

modfile = strcat(problem, '.mod');
datfile = strcat(workdir, '/', problem, '.dat');
lpfile = strcat(workdir, '/', problem, '.lp');
solfile = strcat(workdir, '/', problem, '.sol');
glplogfile = strcat(workdir, '/', problem, '-glp.log');
scipscrfile = strcat(workdir, '/', problem, '-scip.scr');
sciplogfile = strcat(workdir, '/', problem, '-scip.log');

disp(sprintf('Optimizing %s %s%d filter with phases=%d, wd=%d, stages=%d, height=%d, constrained=%d', ...
	archspec.type, filtspec.crep.class, filtspec.crep.id, ...
	ppspec.numphases, ppspec.wdata, optspec.numstages, ...
	archspec.maxheight, optspec.constrained));

lpspec.numstages = optspec.numstages;
lpspec.maxheight = archspec.maxheight;
lpspec.wordlength = ppspec.wout;
lpspec.inbits = zeros(lpspec.maxheight*lpspec.numstages, lpspec.wordlength);
lpspec.cterm = ppspec.cterm;
lpspec.constrained = optspec.constrained;
lpspec.costs = optspec.costs;

if size(lpspec.inbits, 1) < size(ppspec.inbits, 1) || size(lpspec.inbits, 2) ~= size(ppspec.inbits, 2)
	error(sprintf('optcstree_i: inbits has wrong size %dx%d', size(lpspec.inbits)));
end

lpspec.inbits(1:size(ppspec.inbits, 1), :) = ppspec.inbits;

if optspec.forceopt == 0 && isdir(workdir)
	if OPT_DISPCMD == 1
		disp('Data exists, not invoking optimizer');
	end
else
	if ~isdir(workdir)
		mkdir(workdir);
	end

	gencslp(datfile, lpspec);

	glpcmd = sprintf('%s --check --wcpxlp %s -m %s -d %s --log %s > /dev/null', ...
		OPT_GLPSOL, lpfile, modfile, datfile, glplogfile);
	
	if OPT_DISPCMD == 1
		disp(glpcmd);
	end
	system(glpcmd);

	scrid = fopen(scipscrfile, 'w+');
	fprintf(scrid, 'read %s\n', lpfile);
	if OPT_MAXTIME > 0
		fprintf(scrid, 'set limits time %d\n', OPT_MAXTIME);
	end
	if OPT_MAXMEM > 0
		fprintf(scrid, 'set limits memory %d\n', OPT_MAXMEM);
	end
	fprintf(scrid, 'presolve\n');
	fprintf(scrid, 'optimize\n');
	fprintf(scrid, 'write solution %s\n', solfile);
	fprintf(scrid, 'quit\n');
	fclose(scrid);

	scipcmd = sprintf('%s -b %s -l %s -q', OPT_SCIP, scipscrfile, sciplogfile);

	if OPT_DISPCMD == 1
		disp(scipcmd);
	end
	system(scipcmd);
end

soldata = optparsesol(solfile, workdir);

solfound = soldata.solfound;

if solfound == 1
	csspec.ppin = lpspec.inbits;
	csspec.cin = idxmat(lpspec.maxheight*lpspec.numstages, lpspec.wordlength, soldata.cinput);
	csspec.bits = idxmat(lpspec.maxheight*lpspec.numstages+1, lpspec.wordlength, soldata.bits);
	csspec.fa = idxmat(lpspec.maxheight*lpspec.numstages, lpspec.wordlength, soldata.fa);
	csspec.ha = idxmat(lpspec.maxheight*lpspec.numstages, lpspec.wordlength, soldata.ha);
	csspec.regs = idxmat(lpspec.maxheight*lpspec.numstages, lpspec.wordlength, soldata.regs);
	csspec.bout = csspec.bits(end, :);
else
	csspec = [];
end

