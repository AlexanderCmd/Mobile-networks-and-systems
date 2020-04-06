function A = A_func(codes)
size_A = length(codes(1, :)) + 1;
A = zeros(1, size_A);

w = sum(codes, 2);

for i = 1 : size_A
    A(1, i) = sum(((i - 1) == w));    
end
