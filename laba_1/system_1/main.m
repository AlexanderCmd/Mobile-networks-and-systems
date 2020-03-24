clc
clear
close

E = 1;
k = 32;
N = 10000000; % количество сообщений при моделировании
               
%gX = x^16+x^13+x^12+x^11+x^10+x^8+x^6+x^5+x^2+1
gX = [1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1];

SNRdB = -10 : 0;
PeBits = zeros (1, length(SNRdB));
PEDdB = zeros (1, length(SNRdB));
TdB = zeros (1, length(SNRdB));

parfor i = 1 : length(SNRdB)
    tic
        
    disp(SNRdB(i));
    SNR = 10.^(SNRdB(i)/10);
    sigma = sqrt(E / (2*SNR));
    
    [PeBit, PED, T] = model(k, gX, sigma, N);
    
    PeBits(1, i) = PeBit;
    PEDdB(1, i) = PED;
    TdB(1, i) = T;
    
    toc
end

figure();
axis('square');
semilogy(SNRdB, PeBits, 'b.-');
xlabel('SNRdB'); 
ylabel('PeBit');
legend ({'Практическое значение вероятности ошибки на бит'}, ...
'Location','southwest')

figure();
axis('square');
hold on
semilogy(SNRdB, PEDdB, 'b+-');
xlabel('SNRdB'); 
ylabel('PED');
legend({'Практическое значение вероятности ошибки декодера'},...
'Location','east')

figure();
axis('square');
semilogy(SNRdB, TdB, 'b.-');
xlabel('SNRdB'); 
ylabel('T');
legend ({'Пропускная способность'}, ...
'Location','southwest')