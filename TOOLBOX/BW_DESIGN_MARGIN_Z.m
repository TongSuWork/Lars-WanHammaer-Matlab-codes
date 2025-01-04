	function DM = BW_DESIGN_MARGIN_Z(N, wcT, wsT, Amax, Amin, Case)		%	Computes the design margin for a digital Nth-order Butterworth filter.	%	The program maximize/minimize one of the design parameters, i.e.,	%	Case = 1, 2, 3, or 4 for the parameters wcT, wsT, Amax, Amin, respectively.			% 	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		Tapio Saramaki, 2018-03-10	% 	Modified by: 	LW 2018-04-04	% 	Version: 		1	% 	Known bugs:			% 	Report bugs to:	Wanhammar@gmail.com			if N ~= round(N)		disp([ 'N must be an integer'])		break	end		switch Case	case 1		JJ = (10^(Amin/10)-1)/(10^(Amax/10)-1);		Ome = JJ^(1/(2*N));		wcT = 2*atan(tan(wsT/2)/Ome);		DM = wcT;	case 2		JJ = (10^(Amin/10)-1)/(10^(Amax/10)-1);		Ome = JJ^(1/(2*N));		wsT = 2*atan(Ome*tan(wcT/2)); 		DM = wsT;	case 3		Ome = tan(wsT/2)/tan(wcT/2);		Amax = 10*log10(1+(10^(Amin/10)-1)/Ome^(2*N));		DM = Amax;	case 4		Ome = tan(wsT/2)/tan(wcT/2);		Amin = 10*log10(1+(10^(Amax/10)-1)*Ome^(2*N));		DM = Amin;	end		