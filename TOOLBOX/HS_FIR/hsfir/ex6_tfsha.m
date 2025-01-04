	%Copyright 2008, 2010 Anton Blad	%	%This file is part of firgen.	%	%firgen is free software: you can redistribute it and/or modify	%it under the terms of the GNU General Public License as published by	%the Free Software Foundation, either version 3 of the License, or	%(at your option) any later version.	%	%firgen is distributed in the hope that it will be useful,	%but WITHOUT ANY WARRANTY; without even the implied warranty of	%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	%GNU General Public License for more details.	%	%You should have received a copy of the GNU General Public License	%along with firgen.  If not, see <http://www.gnu.org/licenses/>		% Example for generating VHDL code for a cascaded moving average filter	% for decimation. This example creates a TF FIR filter utilizing adder	% sharing.		% Parameter section		clear firspec	clear arithspec	clear archspec		% Decimation factor: length of moving average filter and number of	% branches in polyphase decomposition	dec = 4;	% Number of moving average filters in cascade	casc = 3;		% Filter specification	firspec = fir_dec(dec, sincfilter(dec, casc));		% Data wordlength	arithspec.wdata = 4;	% Signedness of data and coeffs: 0 for unsigned, 1 for signed two's	% complement. Signed coefficients require signed data.	arithspec.signedcoeffs = 0;	arithspec.signeddata = 0;		% Coefficient type. Possible choices are 'bin' for binary and 'msd' for 	% minimum signed digit. 	arithspec.ctype = 'bin';	% For msd, all representations are indexed by cid.	%arithspec.cid = 0;		% Architecture specification. type can be 'TF' for transposed direct form,	% 'DF' for direct form, or 'DFs' for direct form utilizing coefficient 	% symmetry. maxheight is the maximum adder depth. For DFs, symmetrysize is	% the symmetry adder length.	archspec.type = 'TF';	archspec.maxheight = 3;	archspec.addersharing = 1;	%archspec.symmetrysize = wdata;		% The CS tree generator. Choices are 'wallace', 'dadda', 'ra', 'opt'.	archspec.cstree = 'wallace';		% The VMA generator. Only 'rc' implemented.	archspec.vma = 'rc';		% Optimizer options:	%archspec.optspec.optdir = '/tmp/opt_d4c3';	%archspec.optspec.forceopt = 1;	%archspec.optspec.costs.facost = 3;	%archspec.optspec.costs.hacost = 2;	%archspec.optspec.costs.regcost = 3;	%archspec.optspec.costs.bitcost = 0;		genopts.verbose = 2;		% Directory to generate the output files in	vhdldir = 'vhdl_ex6';	% File name prefix of generated files	vhdlname = 'fir';			% Code section (there should be no need to change anything below)		bitspec = gfir(firspec, arithspec, genopts);	bitspec = maketree(bitspec, archspec, genopts);	cplx = treecomplexity(bitspec);	printcomplexity(cplx);	gfirvhdl(vhdldir, vhdlname, bitspec, 1024, genopts);	