clc
clear
close all

E = 1;
k = 32;
N = 1000000; % количество сообщений при моделировании
               
%gX = x^16+x^13+x^12+x^11+x^10+x^8+x^6+x^5+x^2+1
gX = [1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1];
%gX = [1 1 1 0 1];

SNRdB = -12 : 3 : 15;
PeBitdB = zeros (2, length(SNRdB));
PEDdB = zeros (2, length(SNRdB));
TdB = zeros (2, length(SNRdB));

parfor i = 1 : length(SNRdB)
    tic
        
    disp(SNRdB(i));
    SNR = 10.^(SNRdB(i)/10);
    sigma = sqrt(E / (2*SNR));
    
    [PeBit_1, PED_1, T_1] = model_1(k, gX, sigma, N);
    [PeBit_2, PED_2, T_2] = model_2(k, gX, sigma, N);
   
    PeBitdB(:, i) = [PeBit_1 PeBit_2];
    PEDdB(:, i) = [PED_1 PED_2];
    TdB(:, i) = [T_1 T_2];
    
    toc
end

SNRtheor = 10.^(SNRdB/10);
PeBitstheor = qfunc(sqrt(2*SNRtheor));

figure();
axis('square');
semilogy(SNRdB, PeBitdB(1, :), 'b.-', SNRdB, PeBitdB(2, :), 'r-',...
    SNRdB, PeBitstheor, 'c--');
xlabel('SNRdB'); 
ylabel('PeBit');

legend ({'Вероятность ошибки на бит для первой модели', ...
    'Вероятность ошибки на бит для второй модели'...
    'Вероятность ошибки на бит без использование помехозащитного кодирования'}, ...
'Location','southwest')

r = length(gX) - 1;
PEDtheor = (1 / 2)^r.*ones(1, length(SNRdB));

figure();
axis('square');
hold on
semilogy(SNRdB, PEDdB(1, :), 'b.-', SNRdB, PEDdB(2, :), 'r-', ...
    SNRdB, PEDtheor, 'c--');
xlabel('SNRdB'); 
ylabel('PED');

legend({'Вероятность ошибки декодера для первой модели', ...
    'Вероятность ошибки декодера для второй модели', ...
    'Асимптотическая верхняя граница'},...
'Location','east')

figure();
axis('square');
plot(SNRdB, TdB(1, :), 'b.-', SNRdB, k/((k+r)*4).*ones(1, length(SNRdB)), 'b--',...
    SNRdB, TdB(2, :), 'r.-', SNRdB, k/((k+r)/2*3).*ones(1, length(SNRdB)), 'r--');
xlabel('SNRdB'); 
ylabel('T');

legend ({'Пропускная способность первой модели', ...
    'Верхняя граница пропускной способности первой модели', ...
    'Пропускная способность второй модели', ...
    'Верхняя граница пропускной способности второй модели'}, ...
'Location','southwest')