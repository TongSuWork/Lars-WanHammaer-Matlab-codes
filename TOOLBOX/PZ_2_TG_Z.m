	function Taug = PZ_2_TG_Z(G, Z, P, wT)		% Computes the group delay from the gain, poles and zeros for 	% a discrete-time transfer function. 	%	Toolbox for DIGITAL FILTERS USING MATLAB		% Author: 			Lars Wanhammar, 2005-11-11	% Modified by: 		LW 2008-07-11, 2010-05-22	% Copyright:		by authors - not released for commercial use	% Version: 			1	% Known bugs:			% Report bugs to:	Wanhammar@gmail.com		if (G < 0) 		Taug = -pi*ones(1, length(wT));	else		Taug = zeros(1, length(wT));	end	cosWT = cos(wT);	sinWT = sin(wT);	for n = 1:length(P)		x = real(P(n));		y = imag(P(n));		Taug = Taug - (x.*cosWT + y.*sinWT-1)./(abs(P(n))^2 + 1 - 2*x*cosWT - 2*y*sinWT); 	end	Z( find( abs(( abs(Z) - 1 )) < 100000*eps ) ) = []; 	% Remove zeros on the unit circle	 	for n = 1:length(Z)		x = real(Z(n));		y = imag(Z(n)); 		Taug = Taug + (x.*cosWT + y.*sinWT-1)./(abs(Z(n))^2 + 1 - 2*x*cosWT - 2*y*sinWT);	end	%	for n = 2:length(Taug)	% Remove outliers	%	if Taug(n) > 10*Taug(n-1);		%	Taug(n) = Taug(n-1);%		end	%	end		