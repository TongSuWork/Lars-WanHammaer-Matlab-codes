	% Example 4.2  	% Zero-input oscillation	clear all	close all	a1 = 489/256; a2 = -15/16;	K = 200;	% number of samples	Q = 1/512; N = 6;	y = zeros(1,K); x = zeros(1,K);	y1 = 0; y2 = 0;	for n = 1:15		x(n) = round(0.005*cos(pi*n/N)*512)/512;	end	for n = 1:K		y(n) = round(a1*y1*512)/512 + round(a2*y2*512)/512 + x(n);		y2 = y1; 		y1 = y(n);	end	subplot(2,1,1);	stem(x, 'k.-');	  	axis([0 K -0.005 0.005]);	set(gca,'FontName','times','FontSize',16)	ylabel('{\itx}','FontName', 'times','FontSize',16);	grid on	subplot(2,1,2);	stem(y*512, 'k.-');	axis([0 K -30 20]);	set(gca,'FontName','times','FontSize',16)	ylabel('{\ity_ rQ}','FontName','times','FontSize',16);	grid on