function PeBit = model_1(informBook, modulSignalBook, k, n, sigma, N)

%                   1 2 3
matrixHammingDec = [1 0 0;   % 1
                    0 1 0;   % 2
                    1 1 0;   % 3
                    0 0 1;   % 4
                    % % % %  % %
                    1 0 0;   % 5
                    0 1 0;   % 6
                    0 0 1;]; % 7
                    

K = 2^k;
PeBit = 0;

for i = 1 : N
   indexSignal = randi([1 K],1,1); 
   mS = modulSignalBook(indexSignal, :);
   
   %     ¿¡√ÿ
   mR = mS + sigma * randn(1, n);
   %     BPSK ^-1
   mX_ = mR < 0;
   %     Hamming Decoder
   mH_ = hardHammingDecoder(matrixHammingDec, mX_);
   
   PeBit = PeBit + sum(xor(mH_, informBook(indexSignal, :)));
end

PeBit = PeBit / N / k;