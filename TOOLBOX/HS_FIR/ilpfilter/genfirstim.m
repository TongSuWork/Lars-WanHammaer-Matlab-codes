function genfirstim(dir, firname, filtspec, samples, pipedelay);
%genfirstim(dir, firname, filtspec, samples, pipedelay);
%
%Generates stimuli files for use with FIR testbench. The function 
%generates two files: one containing input stimuli for the filter,
%and one containing the expected output.
%Inputs:
%  dir - directory to generate stimuli files in.
%  firname - name of the generated FIR filter. The stimuli files will
%    have the names firname_in.stim and firname_out.stim.
%  filtspec - filter specification, used fields:
%    h: filter impulse response
%    numphases: number of phases
%    wdata: data wordlength
%    wout: output wordlength
%    signeddata: signedness of data (0: unsigned, 1: signed two's 
%                complement)
%  samples - number of samples in stimuli.
%  pipedelay - number of samples to delay the expected output with. This
%    can be calculated with
%    pipedelay = csdelay(csspec) + csdelay(vmaspec) - ppspec.strucdelay;

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

fnstimin = sprintf('%s/%s_in.stim', dir, firname);
fnstimout = sprintf('%s/%s_out.stim', dir, firname);

indata = floor(2^filtspec.wdata*rand(1, samples));
if filtspec.signeddata == 1
	indata = indata - 2^(filtspec.wdata-1);
end
outdata = conv(indata, filtspec.h);
outdata = outdata(filtspec.numphases:filtspec.numphases:samples);
outdata = [zeros(1, pipedelay) outdata(1:end-pipedelay)];

inbin = dectobin(indata', filtspec.wdata, filtspec.signeddata);
instim = reshape(inbin', filtspec.numphases*filtspec.wdata, samples/filtspec.numphases)';

outstim = dectobin(outdata', filtspec.wout, filtspec.signeddata);

dlmwrite(fnstimin, instim, '');
dlmwrite(fnstimout, outstim, '');

