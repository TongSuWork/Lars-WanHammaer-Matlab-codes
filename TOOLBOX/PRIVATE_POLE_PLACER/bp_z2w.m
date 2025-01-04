	function [w] = bp_z2w(z,wa,wb)	% 	% Converts for the bandpass case from the transformed variable	% plane to the jw plane.	% The passband cutoff frequencies wa and wb is needed.		% Author: 			Per Loewenborg    % Modified by:		LW 	% Copyright:		by authors - not released for commercial use	% Version: 			1		% Known bugs:		None	% Report bugs to:	larsw@isy.liu.se		w = sqrt(((z.^2)*(wa^2)-(wb^2))./((z.^2)-1));