	% Example for generating VHDL code for a cascaded moving average filter	% for decimation			% Parameter section		% Decimation factor: length of moving average filter and number of	% branches in polyphase decomposition	dec = 4;	% Number of moving average filters in cascade	casc = 3;		% Data wordlength	wdata = 4;	% Signedness of data and coeffs: 0 for unsigned, 1 for signed two's	% complement. Signed coefficients require signed data.	signedcoeffs = 0;	signeddata = 0;		% Coefficient type. Possible choices are 'bin' for binary and 'msd' for 	% minimum signed digit. 	ctype = 'bin';	% For msd, all representations are indexed by cid.	cid = 0;		% Architecture specification. type can be 'TF' for transposed direct form,	% or 'DF' for direct form. maxheight is the maximum adder depth.	archspec.type = 'DF';	archspec.maxheight = 3;	archspec.symmetrysize = wdata;		% Directory to generate the output files in	vhdldir = 'vhdl_ex1';	% File name prefix of generated files	vhdlname = 'fir';			% Code section (there should be no need to change anything below)		% Create the filter impulse response	h = sincfilter(dec, casc);		% Determine the required output wordlength	wout = wdata+ceil(log2(sum(abs(h))));		% Generate and choose coefficient representation	creps = gencoeffreps(h, wout, signedcoeffs);	crep = chooserep(creps, ctype, cid);		% Compute the needed correction term from the coefficient and data formats	cterm = calccterm(crep, wout, wdata, signeddata);		% Create filter specification structure	filtspec.h = h;	filtspec.crep = crep;	filtspec.cterm = cterm;	filtspec.numphases = dec;	filtspec.wdata = wdata;	filtspec.wout = wout;	filtspec.signeddata = signeddata;		% Create partial product specification and map to input signals	[ppspec, ppmap, pphw] = makeppgen(filtspec, archspec);		% Create structure for partial product reduction tree	% makewallace: Wallace tree	% makedadda: Dadda tree	% makera: Reduced Area heuristic	%csspec = makewallace(ppspec, archspec);	%csspec = makedadda(ppspec, archspec);	csspec = makera(ppspec, archspec);		% Create a ripple-carry adder for the VMA	vmaspec = makercvma(csspec, archspec);		% Calculate the pipeline delay of the architecture	piperegs = csdelay(csspec) + csdelay(vmaspec) - ppspec.strucdelay;		% Print FIR information	printfirinfo(filtspec, ppspec, pphw, csspec, vmaspec, piperegs);		% Create the bit-level map of the reduction tree and VMA	csmap = makecsmap(csspec);	vmamap = makecsmap(vmaspec);		mkdir(vhdldir);		% Generate VHDL code for full adders, half adders, and registers	genbasevhdl(vhdldir);		% Generate bit-level FIR filter code	genfirvhdl(vhdldir, vhdlname, filtspec, ppspec, ppmap, csspec, csmap, vmaspec, vmamap);		% Generate high-level FIR direct form reference code	firrefname = strcat(vhdlname, 'ref');	genfirrefvhdl(vhdldir, firrefname, filtspec, piperegs);		% Generate test bench for bit-level and high-level filters	firtbname = strcat(vhdlname, '_tb');	stiminfile = strcat(vhdlname, '_in.stim');	stimoutfile = strcat(vhdlname, '_out.stim');	genfirtbvhdl(vhdldir, firtbname, vhdlname, firrefname, stiminfile, stimoutfile, filtspec);		% Generate stimuli files for testbench	genfirstim(vhdldir, vhdlname, filtspec, 1024, piperegs);		% Generate simulation script	gensimscript(vhdldir);		% Generate synthesis script	gensynthscript(vhdldir);	