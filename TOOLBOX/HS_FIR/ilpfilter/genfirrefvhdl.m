function genfirrefvhdl(dir, name, filtspec, pipedelay)
%genfirrefvhdl(dir, name, filtspec, pipedelay)
%
%Generates FIR reference implementation. The reference implementation
%is input-to-output true, compared with the bit-level implementation.
%The pipeline delay can be specified.
%Inputs:
%  dir - directory to generate file in.
%  name - entity name. The filename will be name.vhdl.
%  filtspec - filter specification, used fields:
%    h: filter impulse response
%    numphases: number of phases
%    wdata: data wordlength
%    wout: output wordlength
%    signeddata: signedness of data (0: unsigned, 1: signed two's 
%                complement)
%  pipedelay - number of samples to delay the expected output with. This
%    can be calculated with
%    pipedelay = csdelay(csspec) + csdelay(vmaspec) - ppspec.strucdelay;

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

inputdelays = ceil((length(filtspec.h)-(0:filtspec.numphases-1))/filtspec.numphases)-1;

filename = sprintf('%s/%s.vhdl', dir, name);

fid = fopen(filename, 'w+');

genvhdllibs(fid);
fprintf(fid, 'use ieee.numeric_std.all;\n');

% Generate entity
fprintf(fid, 'entity %s is\n', name);
fprintf(fid, 'port (\n');
fprintf(fid, '  clk, reset : in std_logic');

for phase = 0:filtspec.numphases-1
	fprintf(fid, ';\n  x_%d : in std_logic_vector(%d downto 0)', phase, filtspec.wdata-1);
end

fprintf(fid, ';\n  y : out std_logic_vector(%d downto 0)', filtspec.wout-1);

fprintf(fid, ');\n');
fprintf(fid, 'end %s;\n', name);

% Generate architecture
fprintf(fid, 'architecture generated of %s is\n', name);

fprintf(fid, 'component reg\n');
fprintf(fid, 'generic (wordlength : positive);\n');
fprintf(fid, 'port (\n');
fprintf(fid, '  clk, reset : in std_logic;\n');
fprintf(fid, '  d : in std_logic_vector(wordlength-1 downto 0);\n');
fprintf(fid, '  q : out std_logic_vector(wordlength-1 downto 0));\n');
fprintf(fid, 'end component;\n');

% Generate delay line signals
for phase = 0:filtspec.numphases-1
	for d = 0:inputdelays(phase+1)
		fprintf(fid, 'signal x_%d_%d : std_logic_vector(%d downto 0);\n', ...
			phase, d, filtspec.wdata-1);
	end
end

% Generate product signals
for phase = 0:filtspec.numphases-1
	for d = 0:inputdelays(phase+1)
		fprintf(fid, 'signal prod_%d_%d : std_logic_vector(%d downto 0);\n', ...
			phase, d, filtspec.wout-1);
	end
end

% Generate output pipeline signals
for d = 0:pipedelay
	fprintf(fid, 'signal sum_%d : std_logic_vector(%d downto 0);\n', ...
		d, filtspec.wout-1);
end

% Generate filter coefficients
for d = 0:max(inputdelays)
	for phase = 0:filtspec.numphases-1
		if d <= inputdelays(phase+1)
			idx = d*filtspec.numphases + phase + 1;
			fprintf(fid, 'constant c_%d_%d : integer := %d;\n', ...
				phase, d, filtspec.h(idx));
		end
	end
end

fprintf(fid, 'begin\n');

% Connect input to delay line
for phase = 0:filtspec.numphases-1
	fprintf(fid, 'x_%d_0 <= x_%d;\n', phase, filtspec.numphases-1-phase);
end

% Generate registers for delay line
for phase = 0:filtspec.numphases-1
	for d = 0:inputdelays(phase+1)-1
		fprintf(fid, 'xd_%d_%d_i : reg generic map(%d) port map(clk, reset, x_%d_%d, x_%d_%d);\n', ...
			phase, d, filtspec.wdata, phase, d, phase, d+1);
	end
end

% Generate multiplications
wcoeff = filtspec.wout-filtspec.wdata;
for phase = 0:filtspec.numphases-1
	for d = 0:inputdelays(phase+1)
		if filtspec.signeddata == 1
			fprintf(fid, 'prod_%d_%d <= std_logic_vector(signed(x_%d_%d) * to_signed(c_%d_%d, %d));\n', ...
				phase, d, phase, d, phase, d, wcoeff);
		else
			fprintf(fid, 'prod_%d_%d <= std_logic_vector(unsigned(x_%d_%d) * to_unsigned(c_%d_%d, %d));\n', ...
				phase, d, phase, d, phase, d, wcoeff);
		end
	end
end

% Generate sum
fprintf(fid, 'sum_0 <= std_logic_vector(');
comma = '';
for phase = 0:filtspec.numphases-1
	for d = 0:inputdelays(phase+1)
		if filtspec.signeddata == 1
			fprintf(fid, '%ssigned(prod_%d_%d)', comma, phase, d);
		else
			fprintf(fid, '%sunsigned(prod_%d_%d)', comma, phase, d);
		end
		comma = ' + ';
	end
end
fprintf(fid, ');\n');

% Generate output delays
for d = 0:pipedelay-1
	fprintf(fid, 'sumd_%d_i : reg generic map(%d) port map(clk, reset, sum_%d, sum_%d);\n', ...
		d, filtspec.wout, d, d+1);
end

% Assign output
fprintf(fid, 'y <= sum_%d;\n', pipedelay);

fprintf(fid, 'end generated;\n');

fclose(fid);

