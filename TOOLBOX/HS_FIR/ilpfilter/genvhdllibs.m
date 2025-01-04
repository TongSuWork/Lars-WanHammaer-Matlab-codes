function genvhdllibs(fid)
%genvhdllibs(fid)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

fprintf(fid, 'library ieee;\n');
fprintf(fid, 'use ieee.std_logic_1164.all;\n');
fprintf(fid, '\n');

