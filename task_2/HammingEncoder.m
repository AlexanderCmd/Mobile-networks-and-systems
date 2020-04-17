function mH = HammingEncoder(matrixHammingEnc, mX)
mH = mod(mX*matrixHammingEnc, 2);