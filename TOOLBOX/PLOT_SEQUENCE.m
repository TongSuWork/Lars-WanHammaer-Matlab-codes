	function PLOT_SEQUENCE(y, ylabel) 	%	Plots the sequence y.	%	The string ylable = holds the lable on the vertical axis. 	%	Toolbox for DIGITAL FILTERS USING MATLAB	% Author: 			Lars Wanhammar 2005-05-04	% Modified by: 	 	LW 2017-10-12	% Copyright:		by authors - not released for commercial use	% Version:			1 	% Known bugs:			% Report bugs to:	Wanhammar@gmail.com	%========================================================		% Standard settings	fs = 16; 		% Font size	lw = 2; 		% Linewidth	fn = 'times'; 	% Font	%========================================================	color = 'b';			% Set color	linetype = '-';	x = [0:length(y)-1];	x = x(:)';    y = y(:)';	xx = [x; x];	yy = [zeros(1, length(x)); y];	ax = newplot;	hold on;	aym = floor(10*max(abs(y)))*0.01;	set(ax,'ylim',[min(y)-aym max(y)+aym], 'Xcolor', color,'fontsize', fs,'linewidth', 1, 'fontname', fn);	set(ax,'xlim',[x(1)-1 x(end)+1], 'Ycolor', color);	set(get(ax,'xlabel'),'string','\itn','fontsize',fs,'fontname', fn);	set(get(ax,'ylabel'),'string', ylabel,'fontsize', fs,'fontname', fn);	plot(x, y, [color '.'], xx, yy, [color linetype],'linewidth', lw)	stem(x,y,'filled')	hold off;	grid on;	box on;