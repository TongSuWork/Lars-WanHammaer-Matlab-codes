function soldata = optparsesol(solfile, workdir)
%soldata = optparsesol(solfile, workdir)
%
%Parses the optimization results, and extracts the number of bits, full/
%half adders, registers, and constant term inputs in each cell.
%Inputs:
%  solfile - file containing solution from optimization program
%  workdir - directory in which to save the parsing results
%Outputs:
%  soldata - structure with fields:
%    solfound: 1 if a solution is found, 0 if not. If 1, the following
%              fields are set:
%    bits: the number of input bits in each cell
%    fa: the number of full adders in each cell
%    ha: the number of half adders in each cell
%    regs: the number of registers in each cell
%    cinput: the number of constant term inputs in each cell
%
%  bits, fa, ha, regs, and cinput should be used with idxmat to create
%  dense matrices for further use.

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

firgenconf;

cmdparse = sprintf('%s %s %s', OPT_PARSESOL, solfile, workdir);
if OPT_DISPCMD == 1
	disp(cmdparse);
end
system(cmdparse);

statusfile = strcat(workdir, '/', 'struc.status');
bitsfile = strcat(workdir, '/', 'struc.bits');
fafile = strcat(workdir, '/', 'struc.FA');
hafile = strcat(workdir, '/', 'struc.HA');
regsfile = strcat(workdir, '/', 'struc.regs');
cinputfile = strcat(workdir, '/', 'struc.cinput');

solfound = dlmread(statusfile);

soldata.solfound = solfound;

if solfound == 1
	soldata.bits = dlmread(bitsfile);
	soldata.fa = dlmread(fafile);
	soldata.ha = dlmread(hafile);
	soldata.regs = dlmread(regsfile);
	soldata.cinput = dlmread(cinputfile);
end

