function mX = softHammingDecoder(informBook, modulSignalBook, mR)

[~, I] = min(pdist2(modulSignalBook(1:end, :), mR));

mX = informBook(I, :);