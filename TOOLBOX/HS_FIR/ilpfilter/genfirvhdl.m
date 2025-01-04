function genfirvhdl(dir, name, filtspec, ppspec, ppmap, csspec, csmap, vmaspec, vmamap)
%genfirvhdl(dir, name, filtspec, ppspec, ppmap, csspec, csmap, vmaspec, vmamap)
%
%Generates VHDL code for an FIR filter. This function generates five 
%VHDL files:
%  name.vhdl - structural code for the FIR filter. The interface 
%    consists of:
%      clk, reset: Inputs of type std_logic
%      x_0 .. x_{filtspec.num_phases-1}: Inputs of type
%        std_logic_vector(filtspec.wdata-1 downto 0)
%      y: Output of type std_logic_vector(filtspec.wout-1 downto 0)
%  name_pp.vhdl - code for generating the partial products from the
%    filter inputs. The code is dependent on the choice of architecture.
%  name_cs.vhdl - code for reducing the partial products to a vector
%    with at most two partial products for each bit weight.
%  name_vma.vhdl - code for the VMA.
%Inputs:
%  dir - directory to generate code in
%  name - entity and file name of generated code
%  filtspec - filter specification, used fields:
%    numphases: number of phases
%    wdata: data wordlength
%    wout: output wordlength
%  ppspec - partial product specification, from makeppgen
%  ppmap - partial product map, from makeppgen
%  csspec - CS tree specification
%  csmap - CS tree map, from makecsmap
%  vmaspec - VMA specification, from makercvma
%  vmamap - VMA map, fram makecsmap

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

ppname = strcat(name, '_pp');
csname = strcat(name, '_cs');
vmaname = strcat(name, '_vma');

ppfile = sprintf('%s/%s.vhdl', dir, ppname);
csfile = sprintf('%s/%s.vhdl', dir, csname);
vmafile = sprintf('%s/%s.vhdl', dir, vmaname);
strucfile = sprintf('%s/%s.vhdl', dir, name);

genppvhdl(ppfile, ppname, ppspec, ppmap);
gencsvhdl(csfile, csname, csspec, csmap);
gencsvhdl(vmafile, vmaname, vmaspec, vmamap);
genstrucvhdl(strucfile, name, ppspec, csspec, vmaspec);

