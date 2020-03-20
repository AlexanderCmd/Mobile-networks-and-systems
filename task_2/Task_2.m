clc
clear
close

%                1 2 3 4 5
matrixHammingDec = [1 0 0 0 0; % 1
                    0 1 0 0 0; % 2
                    1 1 0 0 0; % 3
                    0 0 1 0 0; % 4
                    1 0 1 0 0; % 5
                    0 1 1 0 0; % 6
                    1 1 1 0 0; % 7
                    0 0 0 1 0; % 8
                    1 0 0 1 0; % 9
                    0 1 0 1 0; % 10
                    1 1 0 1 0; % 11
                    0 0 1 1 0; % 12
                    1 0 1 1 0; % 13
                    0 1 1 1 0; % 14
                    1 1 1 1 0; % 15
                    0 0 0 0 1; % 16
                    1 0 0 0 1; % 17
                    0 1 0 0 1; % 18
                    1 1 0 0 1; % 19
                    0 0 1 0 1; % 20
                    1 0 1 0 1; % 21
                    0 1 1 0 1; % 22
                    1 1 1 0 1; % 23
                    0 0 0 1 1; % 24
                    1 0 0 1 1; % 25
                    0 1 0 1 1; % 26
                    % % % % %
                    1 0 0 0 0; % 27
                    0 1 0 0 0; % 28
                    0 0 1 0 0; % 29
                    0 0 0 1 0; % 30
                    0 0 0 0 1];% 31

E = 1;
k = 8;
N = 100000; % количество сообщений при моделировании
               
%gX = x^16+x^13+x^12+x^11+x^10+x^8+x^6+x^5+x^2+1
gX = [1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1];
r = length(gX) - 1;
n = r + k;

codes = codeBook(k, gX); % кодовые слова
modulSignalBook = modulatedCodeBook(codes); % промодулированные кодовые слова с помехоустойчивым кодом

d_min = min(sum(codes(2:end, :),2));
A = A_func(codes);       

SNRdB = -8 : 2 : 16;
PeBits_hard = zeros (1, length(SNRdB));
PEDdB_hard = zeros (1, length(SNRdB));
TdB_hard = zeros (1, length(SNRdB));

PeBits_soft = zeros (1, length(SNRdB));
PEDdB_soft = zeros (1, length(SNRdB));
TdB_soft = zeros (1, length(SNRdB));

parfor i = 1 : length(SNRdB)
    tic
    
    disp(SNRdB(i));
    SNR = 10.^(SNRdB(i)/10);
    sigma = sqrt(E / (2*SNR));
    
    [PeBit_hard, PED_hard, T_hard] = modelWithHardHammingDecoder(k, gX,...
        codes, sigma, N, modulSignalBook, matrixHammingDec);
    
    PeBits_hard(1, i) = PeBit_hard;
    PEDdB_hard(1, i) = PED_hard;
    TdB_hard(1, i) = T_hard;
    
    [PeBit_soft, PED_soft, T_soft] = modelWithSoftHammingDecoder(k, gX,...
        codes, sigma, N, modulSignalBook);
    
    PeBits_soft(1, i) = PeBit_soft;
    PEDdB_soft(1, i) = PED_soft;
    TdB_soft(1, i) = T_soft;
    
    toc
end

%Точная вероятность ошибки декодирования CRC:
%Теоретическая PED
SNRtheor = 10.^(SNRdB/10);
PeBitstheor = qfunc(sqrt(2*SNRtheor));
PEDsExact = zeros (1, length(SNRdB));

for i = 1 : length(SNRdB)
    for j = d_min : n
        PEDsExact(1, i) = PEDsExact(1, i) + A(j + 1) * ...
            PeBitstheor(i)^j * (1 - PeBitstheor(i))^(n - j);
    end
end

%Значение пропускной способности в отсутствие шума
NoNoiseT = ones(1, length(SNRdB)).*k ./ (n + 5);

figure();
axis('square');
hold on
semilogy(SNRdB, PeBits_hard, 'b.-');
semilogy(SNRdB, PeBits_soft, 'cx-');
semilogy(SNRdB, PeBitstheor, 'r-');
xlabel('SNRdB'); 
ylabel('PeBit');
legend ({'Значение вероятности ошибки на бит с использованием помеустойчивого кодирования с жёстким декодером', ...
    'Значение вероятности ошибки на бит с использованием помеустойчивого кодирования с мягким декодером', ...
    'Значение вероятности ошибки на бит без использования помеустойчивого кодирования'}, ...
'Location','southwest')

figure();
axis('square');
hold on
semilogy(SNRdB, PEDdB_hard, 'b.-');
semilogy(SNRdB, PEDdB_soft, 'cx-');
semilogy(SNRdB, PEDsExact, 'r-');
xlabel('SNRdB'); 
ylabel('PED');
legend({'Значение вероятности ошибки декодера с использованием помеустойчивого кодирования с жёстким декодером', ...
    'Значение вероятности ошибки декодера с использованием помеустойчивого кодирования с мягким декодером', ...
    'Значение вероятности ошибки декодера без использования помеустойчивого кодирования'},...
'Location','east')

figure();
axis('square');
hold on
semilogy(SNRdB, TdB_hard, 'b.-');
semilogy(SNRdB, TdB_soft, 'cx-');
semilogy(SNRdB, NoNoiseT, 'r-');
xlabel('SNRdB'); 
ylabel('T');
legend ({'Пропускная способность системы с использованием помеустойчивого кодирования с жёстким декодером при шуме', ...
    'Пропускная способность системы с использованием помеустойчивого кодирования с мягким декодером при шуме', ...
    'Пропускная способность системы с использованием помеустойчивого кодирования без шума'}, ...
'Location','southwest')