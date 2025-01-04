function [symbits, symadd, sympass] = symmetryadder(w, k, signed)
%[symbits, symadd, sympass] = symmetryadder(w, k, signed)
%
%Create a description of a symmetry adder with a specified block size
%Inputs:
%  w - the length of the adder
%  k - the symmetry block size
%  signed - inhibits reduction of lone half adder at msb
%Outputs:
%  symbits - the output bit matrix
%  symadd - list of adders and expected input
%  sympass - list of leftover input bits which are not added

%Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
%This file is licensed under a modified version of GPL v2, see the file
%LICENSE for details.

adder = @(m) (m == 1) * vertcat(horzcat(zeros(1, m), 2), zeros(m, m+1)) + ...
	(m > 1) * vertcat(zeros(1, m+1), horzcat(vertcat(zeros(m-1, 1), 1), fliplr(eye(m))));
adder2 = @(m) vertcat(zeros(1, m+1), horzcat(vertcat(zeros(m-1, 1), 1), fliplr(eye(m))));

A = zeros(k+1, w+1);
symadd = [];
sympass = [];

i = 0;
while w-i > k
	A(:, w-k-i+1:w-i+1) = A(:, w-k-i+1:w-i+1) + adder(k);
	symadd = [symadd; i+k-1 i];
	i = i + k;
end
if signed == 0
	A(1:w-i+1, 1:w-i+1) = A(1:w-i+1, 1:w-i+1) + adder(w-i);
else
	A(1:w-i+1, 1:w-i+1) = A(1:w-i+1, 1:w-i+1) + adder2(w-i);
end
if w-i > 1 || signed == 1
	symadd = [symadd; w-1 i];
else
	sympass = w-1;
end

symbits = A;

