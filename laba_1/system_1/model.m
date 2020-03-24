function [PeBit, PED, T] = model(k, gX, sigma, N)

tblen = 4; % ������������ ������� �������� �����
trellis = poly2trellis(tblen, [13 17 11 3]); % ������� ���������� ����

r = length(gX) - 1;
n = (k + r) * 4;

Ncur = 0;
Nt = 0;

PeBit = 0;
PED = 0;
buffer = zeros(1, n);

while Ncur < N
    %     CRC-r
    mX = zeros(1, k + r); % ���������� �� ���. ����� �� �����
    
    %     Convolutional Encoder
    mC = convenc(mX, trellis);
    
    %     BPSK
    mS = mC.*-2 + 1;
    
    %------------------�����--------------------
    %     ���������
    H = sqrt(randn(1, n).^2 + randn(1, n).^2);
    mH = mS.* H;
    %     ����
    mR = mH + sigma * randn(1, n);
    %-----------------!�����--------------------
    
    %     Convolutional Decoder
    buffer = buffer + mR;
    mX_ = vitdec(mR, trellis, tblen, 'trunc', 'unquant');
    
    %     CRC-r ^-1    
    flagCRC = sum(modGx(mX_, gX));
    flagSum = sum(xor(mX_, mX));
    
    if flagCRC == 0 % ������ ��� ��� �� ����������
        PED = PED + flagSum > 0;
        
        Ncur = Ncur + 1;
        buffer = zeros(1, n);
    else
        %     Convolutional Decoder
        buffer_mX_ = vitdec(buffer, trellis, tblen, 'trunc', 'unquant');
        
        %     CRC-r ^-1   
        flagBufferCRC = sum(modGx(buffer_mX_, gX));
        flagSum = sum(xor(buffer_mX_, mX));
        
        if flagBufferCRC == 0 % ������ ��� ��� �� ����������
            PED = PED + flagSum > 0;
        
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