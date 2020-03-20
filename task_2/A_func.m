function A = A_func(codes)
size_A = length(codes(1, :)) + 1;
A = zeros(1, size_A);

w = sum(codes, 2);

for i = 0 : size_A - 1
    A(1, i + 1) = sum((i == w));    
end