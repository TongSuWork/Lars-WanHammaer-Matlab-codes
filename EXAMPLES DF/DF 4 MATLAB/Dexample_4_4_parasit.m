	% Example 4.4	clear all	close all	N = 6; K = 400;	alfa = pi/N;	Q = 1/512;	a1 = 1.91015625;	a2 = -0.9375;	x = zeros(1, K); y1 = 0; y2 = 0;	if 1==2		% scale		S = 0; x = 1;		for n = 1:K			y(n) = x/16 + a1*y1+ a2*y2;			y2 = y1;			y1 = y(n);			x = 0;			S = S+y(n)^2;		end		S			subplot(2,1,1);		stem(y, 'k.-');	  		axis([0 K -1 1]);		set(gca,'FontName','times','FontSize',16)		ylabel('{\itx}','FontName', 'times','FontSize',16);		grid on		zoom on		%	end	x = zeros(1, K);y1 = 0; y2 = 0;	for n = 1:K		x(n) = round(0.11*cos(alfa*n)*512)/512;		end	x(232) = -0.2;	for n = 1:K		y(n) = x(n) + a1*y1+ a2*y2;		if abs(y(n)) > 1			if y(n) >= 1 				y(n) = y(n) - 2;				%y(n) = 1 - Q;			else				y(n) = y(n) + 2;				%y(n) = -1			end		end		y2 = y1;		y1 = y(n);  		  	end	x(1:100) =[];	y(1:100)=[];	subplot(2,1,1);	stem(x, 'k.-');	  	axis([0 K-100 -0.15 0.15]);	set(gca,'FontName','times','FontSize',16)	ylabel('{\itx}','FontName', 'times','FontSize',16);	grid on		subplot(2,1,2);	stem(y*512, 'k.-');	axis([0 K-100 -512 512]);	set(gca,'FontName','times','FontSize',16)	ylabel('{\ity_Q}','FontName','times','FontSize',16);	grid on		