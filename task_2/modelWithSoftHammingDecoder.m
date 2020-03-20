function [PeBit, PED, T] = modelWithSoftHammingDecoder(k, gX, codes, sigma, N, modulSignalBook)
 
r = length(gX) - 1;
n = k + r + 5;
K = 2^k;

Ncur = 0;
Nt = 0;

PeBit = 0;
PED = 0;

%     Источник
indexCode = randi([1 K],1,1);%генерация индекса код. слова

while Ncur < N
    mS = modulSignalBook(indexCode, :);
    
    %     АБГШ
    mR = mS + sigma * randn(1, n);
    
    %     Soft Hamming Decoder
    mH_ = softHammingDecoder(mR, codes, modulSignalBook);
    
    %     CRC-r ^-1    
    flagCRC = sum(modGx(mH_, gX));
    flagSum = sum(xor(mH_, codes(indexCode, :)));
    
    if flagCRC == 0 % ошибки нет или не обнаружена
        PED = PED + (flagSum > 0 & flagCRC == 0);
        indexCode = randi([1 K],1,1);%генерация индекса код. слова
        Ncur = Ncur + 1;
    end
    
    PeBit = PeBit + flagSum;
    Nt = Nt + 1;
end

PeBit = PeBit / Nt / n;
PED = PED / Nt;
T = (k * N) / (n * Nt);