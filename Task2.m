%% load text and turn it to bits
text = fileread('text.txt');
binMessage = reshape(dec2bin(text,8).'-'0',1,[]);

Fs = 8e3; %Sampling frequency
Tb = 1/Fs; %Period
Tcs = 2*Tb; %Channel symbol period
Fc = 1e6; %Carrier frequency
SNR = 30;

time = [];
for i=1:length(binMessage)/2
    time(i) = i*Tcs;
end

%% divide array and modulate to constellation
data = reshape(binMessage,2,[]);
T = [];
for i=1:length(data)
    T(i) = QPSKmod(data(1,i),data(2,i),sqrt(2));
end

%multiply by carrier
C = upCarrier(T, Fc, time);
%% channel
E = awgn(C, SNR);

%% carrier and plotting
%multiply by carrier
That = downCarrier(E, Fc, time);

figure(1)
plot(That,'xb')
axis([-2 2 -2 2])
title('For SNR_i_n = 30dB at point T(hat) and absence of jammer');
xlabel('Real');
ylabel('Imaginary');
grid on;
hold on;
x=-4:4;
y=tan(deg2rad(13))*x; % decision limits
z= tan(deg2rad(103))*x; % decision limits
plot(x,y,'k:');
plot(x,z,'k:');
hold off;

%% QPSK demodulation

Bhat=[];
j=1;
for i=1:length(That)
    [Bhat(j),Bhat(j+1)]=QPSKdemod(That(i));
    j=j+2;
end
%% checking
[NBE, BER] = biterr(binMessage,Bhat);
rx = (char(bin2dec(reshape(char(Bhat+'0'), 8,[]).')))';