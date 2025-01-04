	function MAG = LATTICE_2_MAG_Z(P, wT)		% 	Computes the magnitude function for a lowpass filter,	%	realized using a digital lattice filter, from the poles.	%	The order must be odd for lowpass filters		%	Toolbox for DIGITAL FILTERS USING MATLAB 			% 	Author: 		Tapio Saram�ki 8.5.2018	% 	Modified by: 	LW 2018-06-08	% 	Copyright:		by authors - not released for commercial use	% 	Version:		1 	% 	Known bugs:			% 	Report bugs to:	tapio.saramaki@tut.fi		[Zodd, Podd, Zeven, Peven] = SORT_LATTICE_POLES_LP(P);	[S1, S2] = LATTICE_2_H_Z(Zodd, Podd, Zeven, Peven, wT);	MAG = abs((S2-S1)/2);	