	% Example 4.8		b01 = 1; b11 = -2; 			b21 = 1; 			a11 = 1.49139; 		a21 = -0.8997958;	b02 = 1; b12 = -1.006442; 	b22 = 1; 			a12 = 1.305644; 	a22 = -0.9595307;	b03 = 1; b13 = -1.890926; 	b23 = 1; 			a13 = 1.617856; 	a23 = -0.9617549;	b04 = 1; b14 = 2; b24 = 1;  a14 = 1.357826; 	a24 = -0.8956455;	v = zeros(1,10);	u = zeros(1,10);	x = 1;			% The input is an impulse sequence�	for n = 0:16	% At least 2N+1 values of the impulse response 		u(3) = (b01*x + b11*v(1) + b21*v(2))/ 6.95157788264451 + a11*v(3) + a21*v(4);		u(5) = (b02*u(3) + b12*v(3) + b22*v(4))/4.43845503076965 + a12*v(5) + a22*v(6);		u(7) = (b03*u(5) + b13*v(5) + b23*v(6))/2.94221781562377 + a13*v(7) + a23*v(8);		u(9) = (b04*u(7) + b14*v(7) + b24*v(8))/18.05346178242872+ a14*v(9) + a24*v(10);		v(2) = v(1);		% Start of updating the delay elements				v(1) = x; v(4) = v(3); v(3) = u(3); v(6) = v(5);		v(5) = u(5); v(8) = v(7); v(7) = u(7); v(10) = v(9);		v(9) = u(9);		x = 0; 			% Reset the input after the first sample		F3(n+1) = u(3);	% Compute the impulse response to the critical nodes		F5(n+1) = u(5);			F7(n+1) = u(7);		Fy(n+1) = u(9);	end		Norder = 8; wT = linspace(0,pi,1000);	subplot(2,2,1), [G, Z, P] = IMPULSE_2_P_Z(F3, Norder); H3 = PZ_2_FREQ_Z(G, Z, P, wT);	Max3 = max(abs(H3)), PLOT_MAGNITUDE_Z_LS(wT, H3, 0, 1, 'H_3') 	subplot(2,2,2), [G, Z, P] = IMPULSE_2_P_Z(F5, Norder); H5 = PZ_2_FREQ_Z(G, Z, P, wT);	Max5 = max(abs(H5)), PLOT_MAGNITUDE_Z_LS(wT, H5, 0, 1, 'H_5') 		subplot(2,2,3), [G, Z, P] = IMPULSE_2_P_Z(F7, Norder); H7 = PZ_2_FREQ_Z(G, Z, P, wT);	Max7 = max(abs(H7)), PLOT_MAGNITUDE_Z_LS(wT, H7, 0, 1, 'H_7')	subplot(2,2,4), [G, Z, P] = IMPULSE_2_P_Z(Fy, Norder); H = PZ_2_FREQ_Z(G, Z, P, wT);	Maxy = max(abs(H)), PLOT_MAGNITUDE_Z_LS(wT, H, 0, 1, 'H')	