function numregs = csdelay(csspec)
%numregs = csdelay(csspec)
%
%Computes the delay in a carry-save tree.
%Inputs:
%  csspec - carry-save tree specification
%Outputs:
%  numregs - delay

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

numregs = sum(any(csspec.regs > 0, 2));

