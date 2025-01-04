	function [f, g] = EX_8_14_fun(x, H, wT)		% Cost function used in Example 9.14		f = x(1);	g = 0;	%	Two second-order Richards' structures	Dap = conv([1 x(4)*(x(3)-1) -x(3)], [1 x(6)*(x(5)-1) -x(5)]);	Nap = fliplr(Dap);	Hap = freqz(Nap, Dap, wT);	Ph = unwrap(angle(H.*Hap));	g = abs(Ph+x(2)*wT)-x(1); % Phase error	