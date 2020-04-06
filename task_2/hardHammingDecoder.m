function mX = hardHammingDecoder(matrixHammingDec, mH)

S = mod(mH * matrixHammingDec, 2);
if sum(S) ~= 0
    indexError = bi2de(S);
    mH(indexError) = xor(mH(indexError), 1);
end

mX = mH(1:1:end - 5);
