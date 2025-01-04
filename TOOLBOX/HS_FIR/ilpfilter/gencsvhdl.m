function gencsvhdl(filename, name, csspec, csmap)
%gencsvhdl(filename, name, csspec, csmap)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

fid = fopen(filename, 'w+');

genvhdllibs(fid);
gencsvhdlentity(fid, name, csspec);
gencsvhdlarchitecture(fid, name, csspec, csmap);

fclose(fid);

