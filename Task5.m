SNR_in = -10:1:30;
BERtheory = [41];
for i=1:41
   BERtheory(i) = qfunc(sqrt(2*10^((i-11)/10))); 
end
figure(1)
plot(SNR_in,BERtheory, 'b:x')
title('BER Vs SNR for QPSK');
xlabel('SNR_i_n');
ylabel('BER - Bit Error Rate');