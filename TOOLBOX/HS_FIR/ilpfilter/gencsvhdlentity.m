function gencsvhdlentity(fid, name, csspec)
%gencsvhdlentity(fid, name, csspec)

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

fprintf(fid, 'entity %s is\n', name);

gencsvhdlport(fid, csspec.ppin, csspec.bout);

fprintf(fid, 'end %s;\n', name);


