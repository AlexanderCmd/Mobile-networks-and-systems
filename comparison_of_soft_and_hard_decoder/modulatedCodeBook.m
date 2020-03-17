function [informBook, modulSignalBook] = modulatedCodeBook(k)

%                   1 2 3 4 5 6 7 
matrixHammingEnc = [1 0 0 0 1 0 0; % 1
                    0 1 0 0 0 1 0; % 2
                    0 0 1 0 1 1 0; % 3
                    0 0 0 1 0 0 1;]; % 4
                 


r = 3;
n = k + r;

K = 2^k;
informBook = zeros(K, k);
modulSignalBook = zeros(K, n);

for m = 0 : K - 1
   m_xK = de2bi(m, k);
   m_xK = m_xK(end:-1:1);
   
   mH = HammingEncoder(matrixHammingEnc, m_xK);
   
   informBook(m + 1, :) = m_xK;
   modulSignalBook(m + 1, :) = mH.*-2 + 1;
end