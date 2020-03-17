clc
clear
close

E = 1;
N = 100000;
k = 4;
r = 3;
n = k + r;
[informBook, modulSignalBook] = modulatedCodeBook(k);

SNRdB = -10 : 0;
PeBits_1 = zeros (1, length(SNRdB));
PeBits_2 = zeros (1, length(SNRdB));

for i = 1 : length(SNRdB)
    
    disp(SNRdB(i));
    SNR = 10.^(SNRdB(i)/10);
    sigma = sqrt(E / (2*SNR));
    
    PeBits_1(1, i) = model_1(informBook, modulSignalBook, k, n, sigma, N);
    PeBits_2(1, i) = model_2(informBook, modulSignalBook, k, n, sigma, N);
end

figure();
axis('square');
semilogy(SNRdB, PeBits_1, 'b.-', SNRdB, PeBits_2, 'r-');
xlabel('SNRdB'); 
ylabel('PeBit');
legend ({'Вероятность ошибки на бит при жёстком декодировании', ...
         'Вероятность ошибки на бит при мягком декодировании'}, ...
'Location','southwest')