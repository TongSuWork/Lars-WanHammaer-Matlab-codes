function gensimscript(dir)
%gensimscript(dir)
%
%Generates a shell script to compile and simulate generated FIR files 

firgenconf;

vhdlfiles = { 'fa.vhdl', 'fa_noc.vhdl', 'ha.vhdl', 'ha_noc.vhdl', ...
	'dff.vhdl', 'reg.vhdl', 'fir_pp.vhdl', 'fir_cs.vhdl', ...
	'fir_vma.vhdl', 'fir.vhdl', 'fir_tb.vhdl', 'firref.vhdl'};

fn = strcat(dir, '/', 'sim.sh');

fid = fopen(fn, 'w+');

fprintf(fid, '#!/usr/bin/env bash\n');
fprintf(fid, '\n');

fprintf(fid, '%s\n', SIM_INIT);

for f = 1:length(vhdlfiles)
	cfn = vhdlfiles{f};
	fprintf(fid, '%s %s\n', SIM_COMPILE, cfn);
end

fprintf(fid, '%s fir_tb\n', SIM_SIMULATE);

fclose(fid);

if isunix == 1
	fileattrib(fn, '+x', 'a');
end

