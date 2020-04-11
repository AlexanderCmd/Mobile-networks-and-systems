function [PeBit, PED, T] = model_2(k, gX, sigma, N)
codeGenerator = [23 35 0 32 07 16 14 06; 0 5 13 07 13 05 10 01];
tblen = [5 4];
for i = 0 : 5
    trellis(i + 1) = poly2trellis(tblen,[codeGenerator(1, 1:1:end - i); codeGenerator(2, 1:1:end - i)]);
end

r = length(gX) - 1;
nCrc = r + k; 
n = nCrc * 8/2;
Nt = 0;
Ncur = 0;
bitSum = 0;

PeBit = 0;
PED = 0;

mX = zeros(1, nCrc);

while Ncur < N
    %{
    %     CRC-r
    mX = zeros(1, k + r); % моделируем на код. слове из нулей
    %     Convolutional Encoder
    mC = convenc(mX, trellis(1));
    %}
    
    % fast modelling
    mS = ones(1, n);
    
    %------------------Канал--------------------
    H = sqrt(randn().^2 + randn().^2);
    noise = sigma * randn(1, n);
    
    mR = mS.*H + noise;
    %-----------------!Канал--------------------
    
    for ind = 3 : 8
        mRCur = zeros(1, nCrc * ind/2);
        
        for i = 1 : nCrc / 2
            index_1 = 1 + (i - 1)*ind;
            index_2 = 1 + (i - 1)*8;
            mRCur(1, index_1 : index_1 + ind - 1) = mR(1, index_2 : index_2 + ind - 1); 
        end
    
        mX_ = vitdec(mRCur, trellis(9 - ind), 2, 'trunc', 'unquant');

        %     CRC-r ^-1
        flagCRC = sum(modGx(mX_, gX));
        flagSum = sum(xor(mX_, mX));

        if flagCRC == 0 % ошибки нет или не обнаружена
            PED = PED + (flagSum > 0);
            bitSum = bitSum + length(mRCur);
            Ncur = Ncur + 1;
            if mod(Ncur, 200000) == 0
                disp(Ncur);
            end
            break;
        end       
    end  
    
    if flagCRC ~= 0
        bitSum = bitSum + length(mRCur);
    end
    
    Nt = Nt + 1;
    PeBit = PeBit + flagSum;
end

PeBit = PeBit / bitSum;
PED = PED / Nt;
T = (k * N) / bitSum;