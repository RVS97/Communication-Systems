%% load text and turn it to bits
text = fileread('text.txt');
jammer = fileread('jammer.txt');
binMessage = reshape(dec2bin(text,8).'-'0',1,[]);
binJammer = reshape(dec2bin(jammer,8).'-'0',1,[]);

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
jammerdata = reshape(binJammer,2,[]);

T = [];
for i=1:length(data)
    T(i) = QPSKmod(data(1,i),data(2,i),sqrt(2));
end

J =[];
for j=1:length(jammerdata)
    J(j) = QPSKmod(jammerdata(1,j),jammerdata(2,j),10*sqrt(2));
end

%multiply by carrier
C = upCarrier(T, Fc, time);
C2 = upCarrier(J, Fc, time);
%% channel
E = awgn(C, SNR);
E = E + C2;

%% carrier and plotting
%multiply by carrier
That = downCarrier(E, Fc, time);

figure(1)
plot(That,'xb')
axis([-15 15 -15 15])
title('For SNR_i_n = 30dB at point T(hat) and presence of jammer');
xlabel('Real');
ylabel('Imaginary');
grid on;
hold on;
x=-15:15;
y=tan(deg2rad(13))*x;
z= tan(deg2rad(103))*x;
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