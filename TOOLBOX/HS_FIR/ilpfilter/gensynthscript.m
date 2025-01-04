function gensynthscript(dir)
%gensynthscript(dir)
%
%Generates a shell script to synthesize generated FIR files 

firgenconf;

vhdlfiles = { 'fa.vhdl', 'fa_noc.vhdl', 'ha.vhdl', 'ha_noc.vhdl', ...
	'dff.vhdl', 'reg.vhdl', 'fir_pp.vhdl', 'fir_cs.vhdl', ...
	'fir_vma.vhdl', 'fir.vhdl', 'fir_tb.vhdl', 'firref.vhdl'};

fn = strcat(dir, '/', 'synth.sh');

fid = fopen(fn, 'w+');

fprintf(fid, '#!/usr/bin/env bash\n');
fprintf(fid, '\n');

fprintf(fid, '%s\n', SYNTH_CMD);

fclose(fid);

if isunix == 1
	fileattrib(fn, '+x', 'a');
end

gendcscript(dir);

