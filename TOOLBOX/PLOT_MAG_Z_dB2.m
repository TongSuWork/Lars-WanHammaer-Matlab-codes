	function PLOT_MAG_Z_dB2(wT, H, wTaxis, Amin, Ylabel)		% 	Plots the magnitude in dB given the frequency response 	%	of a digital filter 	%	Toolbox for DIGITAL FILTERS USING MATLAB		% 	Author: 		Lars Wanhammar 2015-10-07	% 	Modified by: 	 		% 	Copyright:		by authors - not released for commercial use	% 	Version:		1	 	% 	Known bugs:		 	% 	Report bugs to:	Wanhammar@gmail.com		%========================================================		% Standard settings	fs = 14; 		% Font size	lw = 2; 		% Linewidth	fn = 'times'; 	% Font	%========================================================	plot(wT, H_2_MAG(H),'linewidth',2); 	ymax = 0; y = floor(max(abs(H)));	axis([0 wTaxis -Amin ymax]);	set(gca,'FontName', 'times','FontSize', fs);		if wTaxis <= 0.05*pi		fs = 14;		ax = [0 0.025*pi 0.05*pi];		lab = {'0';'0.025\pi';'0.05\pi'};	elseif wTaxis <= 0.1*pi		fs = 14;		ax = [0 0.02*pi 0.04*pi 0.06*pi 0.08*pi 0.1*pi];		lab = {'0';'0.02\pi';'0.04\pi';'0.06\pi';'0.08\pi';'0.1\pi'};		elseif wTaxis <= 0.2*pi		fs = 14;		ax = [0 0.05*pi 0.1*pi 0.15*pi 0.2*pi];		lab = {'0';'0.05\pi';'0.1\pi';'0.15\pi';'0.2\pi'};		else		ax = [0 0.1*pi 0.2*pi 0.3*pi 0.4*pi 0.5*pi ];		lab = {'0';'0.1\pi';'0.2\pi';'0.3\pi';'0.4\pi';'0.5\pi'};		end	if Ylabel ~= '-'		ylabel(['{|\it' Ylabel '}({\ite^j^\omega^T})|  [dB]'],'FontName', fn,'FontSize',fs);	end	xlabel('{\it\omegaT} [rad]');		xtick(ax,lab);	grid on;