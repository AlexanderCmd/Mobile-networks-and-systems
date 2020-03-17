clc
clear
close

E = 1;
k = 8;
N = 100000; % ���������� ��������� ��� �������������
               
%gX = x^16+x^13+x^12+x^11+x^10+x^8+x^6+x^5+x^2+1
gX = [1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1];
r = length(gX) - 1;
n = r + k;

codes = codeBook(k, gX);
        
SNRdB = -10 : 0;
PeBits = zeros (1, length(SNRdB));
PEDdB = zeros (1, length(SNRdB));
TdB = zeros (1, length(SNRdB));

parfor i = 1 : length(SNRdB)
    tic
    
    disp(SNRdB(i));
    SNR = 10.^(SNRdB(i)/10);
    sigma = sqrt(E / (2*SNR));
    
    [PeBit, PED, T] = model(k, gX, codes, sigma, N);
    
    PeBits(1, i) = PeBit;
    PEDdB(1, i) = PED;
    TdB(1, i) = T;
    
    toc
end

%������ ����������� ������ ������������� CRC:
d_min = min(sum(codes(2:end, :),2));
A = A_func(codes);

%������������� PED
SNRtheor = 10.^(SNRdB/10);
PeBitstheor = qfunc(sqrt(2*SNRtheor));
PEDsExact = zeros (1, length(SNRdB));

for i = 1 : length(SNRdB)
    for j = d_min : n
        PEDsExact(1, i) = PEDsExact(1, i) + A(j + 1) * ...
            PeBitstheor(i)^j * (1 - PeBitstheor(i))^(n - j);
    end
end

%������������� PED � ������������ ������������ ������ �� ���

PEDsExactPractic = zeros (1, length(SNRdB));

for i = 1 : length(SNRdB)
    for j = d_min : n
        PEDsExactPractic(1, i) = PEDsExactPractic(1, i) + A(j + 1) * ...
            PeBits(i)^j * (1 - PeBits(i))^(n - j);
    end
end

figure();
axis('square');
semilogy(SNRdB, PeBits, 'b.-', SNRdB, PeBitstheor, 'r-');
xlabel('SNRdB'); 
ylabel('PeBit');
legend ({'������������ �������� ����������� ������ �� ���', ...
    '������������� �������� ����������� ������ �� ���'}, ...
'Location','southwest')

figure();
axis('square');
hold on
semilogy(SNRdB, PEDdB, 'b+-');
semilogy(SNRdB, PEDsExact, 'cx-');
semilogy(SNRdB, PEDsExactPractic, 'ro');
xlabel('SNRdB'); 
ylabel('PED');
legend({'������������ �������� ����������� ������ ��������', ...
    '������������� �������� ����������� ������ ��� �������� ��� ������������� Pe', ...
    '������������� �������� ����������� ������ ��� �������� ��� ������������ Pe'},...
'Location','east')

figure();
axis('square');
semilogy(SNRdB, TdB, 'b.-');
xlabel('SNRdB'); 
ylabel('T');
legend ({'���������� �����������'}, ...
'Location','southwest')