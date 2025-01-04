	function branch = makeppmap(bitspec, branch, archspec, genopts)	%branch = makeppmap(bitspec, branch, archspec[, genopts])	%	%Creates the map of inputs to partial products for a branch		%Copyright 2008, 2010 Anton Blad	%	%This file is part of firgen.	%	%firgen is free software: you can redistribute it and/or modify	%it under the terms of the GNU General Public License as published by	%the Free Software Foundation, either version 3 of the License, or	%(at your option) any later version.	%	%firgen is distributed in the hope that it will be useful,	%but WITHOUT ANY WARRANTY; without even the implied warranty of	%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	%GNU General Public License for more details.	%	%You should have received a copy of the GNU General Public License	%along with firgen.  If not, see <http://www.gnu.org/licenses/>		if nargin < 3		genopts = [];	end	genopts = parseopts(genopts);		h = branch.h;	coeffs = branch.crep.coeffs;	cterm = branch.cterm;	numphases = bitspec.numin;	wdata = bitspec.arith.wdata;	wout = bitspec.arith.wout;	signeddata = bitspec.arith.signeddata;		type = archspec.type;	maxheight = archspec.maxheight;		numcoeffs = size(coeffs, 1);	wcoeffs = size(coeffs, 2);		cbits = zeros(1, wout);		ppmap.type = type;		if genopts.verbose >= 1		disp(sprintf('  Using %s partial product generator', archspec.type));	end		if strcmp(type, 'DF')		strucdelay = 0;			bitmap = cell(1, wout);		nbits = zeros(1, wout);		delays = zeros(1, numphases);			for c = 1:numcoeffs			phase = numphases-1-mod((c-1), numphases);			delay = floor((c-1)/numphases);				for bc = 1:wcoeffs				if coeffs(c, bc) ~= 0					if delay > delays(phase+1)						delays(phase+1) = delay;					end					for bd = 0:wdata-1						bit = bc+wout-wcoeffs-bd;						if bit >= 1							if signeddata == 1 & bd == wdata-1								bitsign = -coeffs(c,bc);							else								bitsign = coeffs(c,bc);							end							bitmap{1,bit} = [bitmap{1,bit}; 0 phase delay bd bitsign];							if bitsign == -1								nbits(1,bit) = nbits(1,bit)+1;							end						end					end				end			end		end			if genopts.verbose >= 2			disp(sprintf('  Delays in input branches: %s', sprintf(' %d', delays)));		end			%extraregs = (size(coeffs, 1)-numphases)*wdata;		%extraha = 0;		%extrafa = 0;			ppmap.bits = bitmap;		ppmap.delays = delays;		elseif strcmp(type, 'DFs')		if signeddata == 1			invbits = wdata-1;		else			invbits = [];		end			symsize = archspec.symmetrysize;			strucdelay = 0;		if mod(numcoeffs, 2) == 0			odd = 0;		else			odd = 1;		end			numsym = floor(numcoeffs/2);			symcoeffs = [1:numsym ; numcoeffs:-1:numcoeffs-numsym+1];		if odd == 1			dircoeffs = ceil(numcoeffs/2);		else			dircoeffs = [];		end			% Verify that coefficients are symmetrical		if all(h(1:numsym)-h(end:-1:end-numsym+1) == 0)			antisymmetry = 0;		elseif all(h(1:numsym)+h(end:-1:end-numsym+1) == 0)			antisymmetry = 1;		else			error 'Coefficients are not (a-)symmetrical, can not create DFs structure'		end			[symbits, symadd, sympass] = symmetryadder(wdata, symsize, signeddata);			% Create a list of mergers and directly connected bits		premergers = [];		dircbits = [];		bitmap = cell(symsize+1, wout);		pbits = zeros(symsize+1, wout);		nbits = zeros(symsize+1, wout);		delays = zeros(numphases, wdata);		invneeded = zeros(numphases, ceil(numcoeffs/numphases)+ceil(symsize/maxheight), wdata);			for c = 1:numsym			c1 = symcoeffs(1, c);			c2 = symcoeffs(2, c);			c1phase = numphases-1-mod(c1-1, numphases);			c2phase = numphases-1-mod(c2-1, numphases);			c1delay = floor((c1-1)/numphases);			c2delay = floor((c2-1)/numphases);				coeff = coeffs(c1, :);				% Correct for carry-in of symmetry substractors			if antisymmetry == 1				for bc = 1:wcoeffs					if coeff(bc) == 1						cbits(1, bc+wout-wcoeffs) = cbits(1, bc+wout-wcoeffs) + 1;					elseif coeff(bc) == -1						for b = 1:bc+wout-wcoeffs							cbits(1, b) = cbits(1, b) + 1;						end					end				end			end				% Create the symmetry adder blocks			for s = 1:size(symadd, 1)				symlsb = symadd(s, 2);				symlen = symadd(s, 1)-symadd(s, 2)+1;				premergers = [premergers; c1phase c1delay symlsb ...					c2phase c2delay symlsb symlen maxheight antisymmetry];					% Compute required delay of the individual bits of the symmetry adder inputs				for b = 0:symlen-1					d = c1delay+floor(b/maxheight);					if d > delays(c1phase+1, symlsb+b+1)						delays(c1phase+1, symlsb+b+1) = d;					end					d = c2delay+floor(b/maxheight);					if d > delays(c2phase+1, symlsb+b+1)						delays(c2phase+1, symlsb+b+1) = d;					end					if antisymmetry == 1						invneeded(c2phase+1, d+1, symlsb+b+1) = 1;					end				end					mergeid = size(premergers, 1);					% Connect the symmetry adder output to partial products				for symb = 0:symlen					l = symb+1;					if symb < symlen						l = l + 1;					end					bd = symlsb+symb;					for bc = 1:wcoeffs						if coeff(bc) ~= 0							bit = bc-bd;							if bit >= 1								bitmap{l,bit} = [bitmap{l,bit}; 0 0 mergeid symb coeff(bc)];								if signeddata == 1 & bd == wdata									bitsign = -coeff(bc);								else									bitsign = coeff(bc);								end								if bitsign == 1									pbits(l,bit) = pbits(l,bit) + 1;								else									nbits(l,bit) = nbits(l,bit) + 1;								end							end						end					end				end			end				% Save bits that are not connected to a symmetry adder block			for s = 1:size(sympass, 1)				passbit = sympass(s, 1);				dircbits = [dircbits; c1 passbit 0];				dircbits = [dircbits; c2 passbit 0];			end		end			% Save bits connected to non-symmetrical coefficients		for c = 1:length(dircoeffs)			c1 = dircoeffs(c, 1);			for s = 1:wdata				dircbits = [dircbits; c1 wdata-s 0 0];			end		end			% Connect the direct bits to the partial product tree		dirbits = zeros(size(dircbits, 1), 4);		for d = 1:size(dircbits, 1)			c1 = dircbits(d, 1);			bd = dircbits(d, 2);			invert = dircbits(d, 3);			c1phase = numphases-1-mod(c1-1, numphases);			c1delay = floor((c1-1)/numphases);			coeff = coeffs(c1, :);				for bi = 1:wdata				if c1delay > delays(c1phase+1, bi)					delays(c1phase+1, bi) = c1delay;				end			end				dirbits(d, :) = [c1phase c1delay bd invert];						for bc = 1:wcoeffs				if coeff(bc) ~= 0					bit = bc-wcoeffs+wout-bd;					if bit >= 1						bitmap{1,bit} = [bitmap{1,bit}; 0 1 d 0 coeff(bc)];						if signeddata == 1 & bd == wdata-1							bitsign = -coeff(bc);						else							bitsign = coeff(bc);						end						if bitsign == 1							pbits(1,bit) = pbits(1,bit) + 1;						else							nbits(1,bit) = nbits(1,bit) + 1;						end					end				end			end		end				%extraregs = sum(sum(delays)) + 2*numsym*floor(symsize/maxheight);		%extraha = size(premergers, 1);		%extrafa = sum(premergers(:, 7)-1);			ppmap.bits = bitmap;		ppmap.delays = delays;		ppmap.premergers = premergers;		ppmap.dirbits = dirbits;		ppmap.invbits = invbits;		ppmap.antisymmetry = antisymmetry;		ppmap.invneeded = invneeded;		elseif strcmp(type, 'TF')		numinitstages = ceil(numcoeffs/numphases);		initcoeffs = [zeros(numphases*numinitstages-numcoeffs, wcoeffs); flipud(coeffs)];			strucdelay = numinitstages-1;		bitmap = cell((numinitstages-1)*maxheight+1, wout);		nbits = zeros((numinitstages-1)*maxheight+1, wout);			for stage = 1:numinitstages			inlevel = maxheight*(stage-1) + 1;			incoeffs = (stage-1)*numphases+1:stage*numphases;						for phase = 1:numphases				c = incoeffs(phase);				for bc = 1:wcoeffs					if initcoeffs(c, bc) ~= 0						for bd = 0:wdata-1							bit = bc+wout-wcoeffs-bd;							if bit >= 1								if signeddata == 1 & bd == wdata-1									bitsign = -initcoeffs(c,bc);								else									bitsign = initcoeffs(c,bc);								end								bitmap{inlevel, bit} = [bitmap{inlevel,bit}; 0 phase-1 bd bitsign];								if bitsign == -1									nbits(inlevel,bit) = nbits(inlevel,bit) + 1;								end							end						end					end				end			end		end			%extraregs = 0;		%extraha = 0;		%extrafa = 0;			ppmap.bits = bitmap;	else		error "Unknown architecture type."	end		cterm = conv(sum(nbits, 1), ones(1, wout));	cterm = cterm(end-wout+1:end);	cterm = cterm+cbits;	s = 0;	for n = length(cterm):-1:1		t = mod(cterm(n)+s, 2);		s = (cterm(n)+s-t)/2;		cterm(n) = t;	end		%branch.pphw.extraregs = extraregs;	%branch.pphw.extraha = extraha;	%branch.pphw.extrafa = extrafa;	branch.ppmap = ppmap;	branch.ppspec.cterm = cterm;	branch.ppspec.strucdelay = strucdelay;		if genopts.verbose >= 1		disp(sprintf('  Architecture structural delay: %d', strucdelay));	end	