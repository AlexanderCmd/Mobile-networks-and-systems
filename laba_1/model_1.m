function [PeBit, PED, T] = model_1(k, gX, sigma, N)

codeGenerator = [13 17 11 3];
tblen = 4; % максимальная глубина обратной связи
trellis = poly2trellis(tblen, codeGenerator); % решётка свёрточного кода

r = length(gX) - 1;
n = (k + r) * length(codeGenerator);

Ncur = 0;
Nt = 0;

PeBit = 0;
PED = 0;
buffer = zeros(1, n);

% for fast model
mX = zeros(1, k + r); 
mS = ones(1, n);

while Ncur < N
    %{
    %     CRC-r
    mX = zeros(1, k + r); % моделируем на код. слове из нулей
    %     Convolutional Encoder
    mC = convenc(mX, trellis);
    %     BPSK
    mS = mC.*-2 + 1;
    %}
    
    %------------------Канал--------------------
    H = sqrt(randn().^2 + randn().^2);
    noise = sigma * randn(1, n);
    
    mR = mS.*H + noise;
    %-----------------!Канал--------------------
    
    %     Convolutional Decoder
    buffer = buffer + mR;
    mX_ = vitdec(mR, trellis, tblen, 'trunc', 'unquant');
    
    %     CRC-r ^-1    
    flagCRC = sum(modGx(mX_, gX));
    flagSum = sum(xor(mX_, mX));
    
    if flagCRC == 0 % ошибки нет или не обнаружена
        PED = PED + (flagSum > 0);% & flagCRC == 0);
        
        Ncur = Ncur + 1;
        buffer = zeros(1, n);
    else
        %     Convolutional Decoder
        mX_ = vitdec(buffer, trellis, tblen, 'trunc', 'unquant');
        
        %     CRC-r ^-1   
        flagCRC = sum(modGx(mX_, gX));
        flagSum = sum(xor(mX_, mX));
        
        if flagCRC == 0 % ошибки нет или не обнаружена
            PED = PED + (flagSum > 0);% & flagCRC == 0);
        
            Ncur = Ncur + 1;
            buffer = zeros(1, n);
        end
    end
    
    PeBit = PeBit + flagSum;
    Nt = Nt + 1;
end

PeBit = PeBit / Nt / n;
PED = PED / Nt;
T = (k * N) / (n * Nt);