function mX = softHammingDecoder(mR, codes, modulSignalBook)

[~, I] = min(pdist2(modulSignalBook(1:end, :), mR));
mX = codes(I, :);