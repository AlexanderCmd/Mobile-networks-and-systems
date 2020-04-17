function codes = codeBook(k, gX)
r = length(gX) - 1;
n = k + r;

R = 2^r;
K = 2^k;

codes = zeros(K, n);

for m = 0 : K - 1
   m_xK = de2bi(m*R, n);
   m_xK = m_xK(end:-1:1); %мл.б на свое место
   
   codes(m + 1, :) = xor(m_xK, modGx(m_xK, gX));
end