	M = 5;	wT = linspace(0,pi,1000);	d = 0.01*pi; F = [0,0.6+d,0.8-2*d,0.8-d,1]; A = [0,0,1,0,0];	x = fir2(1024,F,A);									% Input signal signal 	X = freqz(x,1,wT);									% Input spectrum	subplot(4,1,1); PLOT_ABS_Z(wT, abs(X), 'X')	for n = 1:M-1		plot([1, 1]*n*pi/M, [0.15,0.85]); 				% Band edges	end	hBP = REMEZ_FIR(100,[0,0.6,0.6+d,0.8-d,0.8+d,1]*pi,[0,0,1,1,0,0],[1,1,1],'m'); 	HBP = freqz(hBP,1,wT);  	subplot(4,1,2); PLOT_MAG_Z_dB(wT, HBP, pi, 60, 'H_B_P')	subplot(4,1,3); PLOT_ABS_Z(wT, abs(HBP.*X), 'Y')	x_dn = DOWN_SAMPLE(x,M); 						% Down-sampling	n = 0:length(x_dn)-1;							% Invert the spectrum	x_dn = x_dn.*(-1).^n; 	X_dn = freqz(x_dn,1,wT); 	subplot(4,1,4); PLOT_ABS_Z(wT, M*abs(X_dn), 'Y'); % Scale the spectrum	xlabel('{\it\omegaT} [rad]');