function gencslp(datfile, lpspec)
%gencslp(datfile, lpspec)
%
%Generates the data file for an ILP optimization problem in the GNU
%Mathprog modeling language
%Inputs:
%  datfile - the name of the file to generate
%  lpspec: structure with fields:
%    numstages: Number of stages in CS tree
%    maxheight: Number of levels in each stage
%    wordlength: Input and output wordlength
%    inbits: Input bitproducts, matrix of size (maxheight*numstages+1) x wordlength
%    cterm: Constant term, vector of size 1 x wordlength
%    constrained: Number of constrained bits in output
%    costs: structure with fields:
%      facost, hacost, regcost, bitcost

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

inbits = lpspec.inbits;
cterm = lpspec.cterm;
numstages = lpspec.numstages;
maxheight = lpspec.maxheight;
wordlength = lpspec.wordlength;
constrained = lpspec.constrained;
costs = lpspec.costs;

% Generate BitsIn vector to optimization problem
levelidx = reshape(repmat(0:maxheight*numstages-1, wordlength, 1), 1, maxheight*numstages*wordlength);
bitidx = reshape(repmat(1:wordlength, maxheight*numstages, 1)', 1, maxheight*numstages*wordlength);
bitproducts = reshape(inbits', 1, maxheight*numstages*wordlength);
bitsin = reshape([levelidx;bitidx;bitproducts], 1, 3*maxheight*numstages*wordlength);

ctermidx = 1:wordlength;
ctermvec = reshape([ctermidx;cterm], 1, 2*wordlength);

fid = fopen(datfile, 'w+');
if fid == -1
	error 'gencslp: error opening file';
end

fprintf(fid, '/* Complexity costs */\n');
fprintf(fid, 'param UCost_FA := %d;\n', costs.facost);
fprintf(fid, 'param UCost_HA := %d;\n', costs.hacost);
fprintf(fid, 'param UCost_reg := %d;\n', costs.regcost);
fprintf(fid, 'param UCost_bit := %d;\n', costs.bitcost);
fprintf(fid, '\n');
fprintf(fid, 'param NumConstrainedOut := %d;\n', constrained);
fprintf(fid, '\n');
fprintf(fid, '/* Parameters */\n');
fprintf(fid, 'param AdderLevels := %d;\n', maxheight*numstages);
fprintf(fid, 'param Wordlength := %d;\n', wordlength);
fprintf(fid, 'param MaxHeight := %d;\n', maxheight);
fprintf(fid, 'param BitsIn := %s;\n', sprintf(' %d', bitsin));
fprintf(fid, 'param CTerm := %s;\n', sprintf(' %d', ctermvec));
fprintf(fid, '\n');
fprintf(fid, 'end;\n');

fclose(fid);

