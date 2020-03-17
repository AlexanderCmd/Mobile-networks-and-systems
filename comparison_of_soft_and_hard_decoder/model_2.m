function PeBit = model_2(informBook, modulSignalBook, k, n, sigma, N)

K = 2^k;
PeBit= 0;

for i = 1 : N
   indexSignal = randi([1 K],1,1); 
   mS = modulSignalBook(indexSignal, :);
   
   %     ¿¡√ÿ
   mR = mS + sigma * randn(1, n);
   %     Hamming Decoder
   mH_ = softHammingDecoder(informBook, modulSignalBook, mR);
   
   PeBit = PeBit + sum(xor(mH_, informBook(indexSignal, :)));
end

PeBit = PeBit / N / k;