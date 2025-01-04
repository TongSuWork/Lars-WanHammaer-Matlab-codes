function genppvhdl(filename, name, ppspec, ppmap)
%genppvhdl(filename, name, ppspec, ppmap)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

L = size(ppmap.bits, 1);
W = size(ppmap.bits, 2);

wdata = ppspec.wdata;
pp = ppspec.inbits;
numphases = ppspec.numphases;

fid = fopen(filename, 'w+');

genvhdllibs(fid);

fprintf(fid, 'entity %s is\n', name);
genppvhdlport(fid, numphases, wdata, pp);
fprintf(fid, 'end %s;\n', name);

fprintf(fid, 'architecture generated of %s is\n', name);

if strcmp(ppmap.type, 'DF')
	% Direct form

	delays = ppmap.delays;
	bitmap = ppmap.bits;

	fprintf(fid, 'component reg\n', name);
	fprintf(fid, 'generic (wordlength : positive);\n');
	fprintf(fid, 'port (\n');
	fprintf(fid, 'clk, reset : in std_logic;\n');
	fprintf(fid, 'd : in std_logic_vector(wordlength-1 downto 0);\n');
	fprintf(fid, 'q : out std_logic_vector(wordlength-1 downto 0));\n');
	fprintf(fid, 'end component;\n');

	for phase = 0:numphases-1
		for delay = 0:delays(phase+1)
			fprintf(fid, 'signal in_%d_%d : std_logic_vector(%d downto 0);\n', phase, delay, wdata-1);
		end
	end

	fprintf(fid, 'begin\n');

	for phase = 0:numphases-1
		fprintf(fid, 'in_%d_0 <= in_%d;\n', phase, phase);
		for delay = 1:delays(phase+1)
			fprintf(fid, 'in_d_%d_%d: reg generic map(%d) port map(clk, reset, in_%d_%d, in_%d_%d);\n', ...
				phase, delay, wdata, phase, delay-1, phase, delay);
		end
	end

	for l = 1:L
		for w = 1:W
			bits = bitmap{l,w};

			numpp = size(bits, 1);

			for i = 1:numpp
				phase = bits(i, 1);
				delay = bits(i, 2);
				bit = bits(i, 3);
				weight = bits(i, 4);

				if weight == 1
					fprintf(fid, 'out_%d_%d(%d) <= in_%d_%d(%d);\n', l, w, i-1, phase, delay, bit);
				elseif weight == -1
					fprintf(fid, 'out_%d_%d(%d) <= not in_%d_%d(%d);\n', l, w, i-1, phase, delay, bit);
				else
					disp('genppvhdl : invalid weight');
				end
			end
		end
	end
elseif strcmp(ppmap.type, 'DFs')
	% Direct form with symmetry

	delays = ppmap.delays;
	bitmap = ppmap.bits;
	merge = ppmap.premergers;
	dirbits = ppmap.dirbits;
	invbits = ppmap.invbits;
	invneeded = ppmap.invneeded;

	fprintf(fid, 'component fa\n');
	fprintf(fid, 'port (in1, in2, in3 : in  std_logic;\n');
	fprintf(fid, '      outs, outc    : out std_logic);\n');
	fprintf(fid, 'end component;\n');

	fprintf(fid, 'component ha\n');
	fprintf(fid, 'port (in1, in2   : in  std_logic;\n');
	fprintf(fid, '      outs, outc : out std_logic);\n');
	fprintf(fid, 'end component;\n');

	fprintf(fid, 'component dff\n');
	fprintf(fid, 'port (clk, reset : in std_logic;\n');
	fprintf(fid, '      d : in  std_logic;\n');
	fprintf(fid, '      q : out std_logic);\n');
	fprintf(fid, 'end component;\n');

	for phase = 0:numphases-1
		for b = 0:wdata-1
			for delay = 0:ppmap.delays(phase+1, b+1)
				fprintf(fid, 'signal in_%d_%d_%d : std_logic;\n', phase, b, delay);
			end
		end
	end

	for phase = 0:numphases-1
		for b = 0:wdata-1
			for delay = 0:ppmap.delays(phase+1, b+1)
				if invneeded(1+phase, 1+delay, 1+b) == 1
					fprintf(fid, 'signal in_%d_%d_%d_inv : std_logic;\n', phase, b, delay);
				end
			end
		end
	end

	for n = 1:size(merge, 1)
		fprintf(fid, 'signal syms_%d_i : std_logic_vector(%d downto 0);\n', n, merge(n, 7)-1);
		fprintf(fid, 'signal syms_%d : std_logic_vector(%d downto 0);\n', n, merge(n, 7));
		fprintf(fid, 'signal symc_%d_i : std_logic_vector(%d downto 0);\n', n, merge(n, 7)-1);
		fprintf(fid, 'signal symc_%d : std_logic_vector(%d downto 0);\n', n, merge(n, 7)-1);
	end

	for n = 1:size(dirbits, 1)
		fprintf(fid, 'signal pass_%d : std_logic;\n', n);
	end

	fprintf(fid, 'begin\n');

	for phase = 0:numphases-1
		for b = 0:wdata-1
			if any(invbits == b)
				fprintf(fid, 'in_%d_%d_0 <= not in_%d(%d);\n', phase, b, phase, b);
			else
				fprintf(fid, 'in_%d_%d_0 <= in_%d(%d);\n', phase, b, phase, b);
			end
		end
	end

	for phase = 0:numphases-1
		for b = 0:wdata-1
			for delay = 1:ppmap.delays(phase+1, b+1)
				fprintf(fid, 'in_d_%d_%d_%d: dff port map(clk, reset, in_%d_%d_%d, in_%d_%d_%d);\n', ...
					phase, b, delay, phase, b, delay-1, phase, b, delay);
			end
		end
	end

	for phase = 0:numphases-1
		for b = 0:wdata-1
			for delay = 0:ppmap.delays(phase+1, b+1)
				if invneeded(1+phase, 1+delay, 1+b) == 1
					fprintf(fid, 'in_%d_%d_%d_inv <= not in_%d_%d_%d;\n', phase, b, delay, phase, b, delay);
				end
			end
		end
	end

	for n = 1:size(merge, 1)
		m = merge(n, :);
		delay = 0;
		for b = 0:m(7)-1
			if b == 0
				if m(9) == 1
					fprintf(fid, 'symadd_%d_%d: ha port map(in_%d_%d_%d, in_%d_%d_%d_inv, syms_%d_i(%d), symc_%d_i(%d));\n', ...
						n, b, m(1), m(3)+b, m(2)+delay, m(4), m(6)+b, m(5)+delay, n, b, n, b);
				else
					fprintf(fid, 'symadd_%d_%d: ha port map(in_%d_%d_%d, in_%d_%d_%d, syms_%d_i(%d), symc_%d_i(%d));\n', ...
						n, b, m(1), m(3)+b, m(2)+delay, m(4), m(6)+b, m(5)+delay, n, b, n, b);
				end
			else
				if m(9) == 1
					fprintf(fid, 'symadd_%d_%d: fa port map(in_%d_%d_%d, in_%d_%d_%d_inv, symc_%d(%d), syms_%d_i(%d), symc_%d_i(%d));\n', ...
						n, b, m(1), m(3)+b, m(2)+delay, m(4), m(6)+b, m(5)+delay, n, b-1, n, b, n, b);
				else
					fprintf(fid, 'symadd_%d_%d: fa port map(in_%d_%d_%d, in_%d_%d_%d, symc_%d(%d), syms_%d_i(%d), symc_%d_i(%d));\n', ...
						n, b, m(1), m(3)+b, m(2)+delay, m(4), m(6)+b, m(5)+delay, n, b-1, n, b, n, b);
				end
			end

			if mod(b+1, m(8)) == 0
				fprintf(fid, 'symaddregs_%d_%d: dff port map(clk, reset, syms_%d_i(%d), syms_%d(%d));\n', ...
					n, b, n, b, n, b);
				fprintf(fid, 'symaddregc_%d_%d: dff port map(clk, reset, symc_%d_i(%d), symc_%d(%d));\n', ...
					n, b, n, b, n, b);
					delay = delay + 1;
			else
				fprintf(fid, 'syms_%d(%d) <= syms_%d_i(%d);\n', n, b, n, b);
				fprintf(fid, 'symc_%d(%d) <= symc_%d_i(%d);\n', n, b, n, b);
			end
		end
		fprintf(fid, 'syms_%d(%d) <= symc_%d(%d);\n', n, m(7), n, m(7)-1);
	end

	for n = 1:size(dirbits, 1)
		m = dirbits(n, :);
		if m(4) == 1
			fprintf(fid, 'pass_%d <= in_%d_%d_%d_inv;\n', n, m(1), m(3), m(2));
		else
			fprintf(fid, 'pass_%d <= in_%d_%d_%d;\n', n, m(1), m(3), m(2));
		end
	end

	for l = 1:L
		for w = 1:W
			bits = bitmap{l,w};

			numpp = size(bits, 1);

			for i = 1:numpp
				source = bits(i, 1);
				id = bits(i, 2);
				bit = bits(i, 3);
				weight = bits(i, 4);

				if weight == 1
					wmod = '';
				elseif weight == -1
					wmod = 'not ';
				else
					disp('genppvhdl : invalid weight');
				end

				if source == 0
					fprintf(fid, 'out_%d_%d(%d) <= %ssyms_%d(%d);\n', l, w, i-1, wmod, id, bit);
				else
					fprintf(fid, 'out_%d_%d(%d) <= %spass_%d;\n', l, w, i-1, wmod, id);
				end
			end
		end
	end
elseif strcmp(ppmap.type, 'TF')
	% Transposed direct form
	fprintf(fid, 'begin\n');

	for l = 1:L
		for w = 1:W
			bits = ppmap.bits{l,w};
			
			numpp = size(bits, 1);

			for i = 1:numpp
				phase = bits(i, 1);
				bit = bits(i, 2);
				weight = bits(i, 3);
				
				if weight == 1
					fprintf(fid, 'out_%d_%d(%d) <= in_%d(%d);\n', l, w, i-1, phase-1, bit);
				elseif weight == -1
					fprintf(fid, 'out_%d_%d(%d) <= not in_%d(%d);\n', l, w, i-1, phase-1, bit);
				else
					disp('genppvhdl : invalid weight');
				end
			end
		end
	end
end

fprintf(fid, 'end generated;\n');

fclose(fid);

