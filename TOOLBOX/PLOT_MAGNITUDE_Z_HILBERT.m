	function PLOT_MAGNITUDE_Z_HILBERT(wT, Mag, Amin, Ylabel) 	% 	Plots the magnitude in dB given the frequency response 	%	of a digital Hilbert filter 	%	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		Lars Wanhammar 2015-10-07	% 	Modified by: 	 		% 	Copyright:		by authors - not released for commercial use	% 	Version:			 	% 	Known bugs:		 	% 	Report bugs to:	Wanhammar@gmail.com 	%========================================================		% Standard settings	fs = 16; 		% Font size	lw = 2; 		% Linewidth	fn = 'times'; 	% Font	%========================================================	plot(wT, Mag,'linewidth',2);  	axis([-pi pi -Amin 10]);	set(gca,'FontName', 'times','FontSize', 16);	ax = [-pi -0.8*pi -0.6*pi -0.4*pi -0.2*pi 0*pi 0.2*pi 0.4*pi 0.6*pi 0.8*pi pi];	lab = {'-\pi';'-0.8\pi';'-0.6\pi';'-0.4\pi';'-0.2\pi';' 0';'0.2\pi';'0.4\pi';'0.6\pi';'0.8\pi';'\pi'};		ylabel(['{|\it' Ylabel '}({\ite^j^\omega^T})|  [dB]'],'FontName', fn,'FontSize',fs);	xlabel('{\it\omegaT} [rad]');		xtick(ax,lab);	grid on;	hold on		axes('position',[0.2 0.6 0.25 0.2]);	plot(wT, Mag, 'linewidth', 2); 	axis([-0.1*pi 0.9*pi -0.0000006 0])		ylabel(['{|\it' Ylabel '}({\ite^j^\omega^T})|'],'FontName', fn,'FontSize',fs-2);	xlabel('{\it\omegaT} [rad]','FontName', fn,'FontSize', fs-2);	ax = [0.1*pi 0.3*pi 0.5*pi 0.7*pi 0.9*pi];		lab = {'0.1\pi';'0.3\pi';'0.5\pi';'0.7\pi';'0.9\pi'};	xtick(ax,lab);		grid on