%% load text and turn it to bits
text = fileread('text.txt');
jammer = fileread('jammer.txt');
binMessage = reshape(dec2bin(text,8).'-'0',1,[]);
binJammer = reshape(dec2bin(jammer,8).'-'0',1,[]);

%polynomials of sequences, first value not included (D^5)
mesPoly1 = [0 0 1 0 1]; % D^5 + D^2 + 1
mesPoly2 = [0 1 1 1 1]; % D^5 + D^3 + D^2 + D + 1
jamPoly1 = [0 1 0 0 1]; % D^5 + D^3 + 1
jamPoly2 = [1 0 1 1 1]; % D^5 + D^4 + D^2 + D + 1

Fs = 8e3; %Sampling frequency
Tb = 1/Fs; %Period
Tcs = 2*Tb; %Channel symbol period
Fc = 1e6; %Carrier frequency
SNR = 30;
shift = 9; %shift for gold sequence = (22(V)+18(R))mod31 = 9 

%% divide array and modulate to constellation
data = reshape(binMessage,2,[]);
T = [];
for i=1:length(data)
    T(i) = QPSKmod(data(1,i),data(2,i),sqrt(2));
end

jammerdata = reshape(binJammer,2,[]);
J =[];
for j=1:length(jammerdata)
    J(j) = QPSKmod(jammerdata(1,j),jammerdata(2,j),10*sqrt(2));
end

%% Gold sequence generation
mseq1 = seqgen(mesPoly1);
mseq2 = seqgen(mesPoly2);

jseq1 = seqgen(jamPoly1);
jseq2 = seqgen(jamPoly2);

balanced = 0; % initialise balanced
k = shift;
while balanced==0
    [mgoldSeq, balanced] = goldSeqGen(mseq1, mseq2, mod(k,31));
    k = k + 1;
end
balanced = 0; %reset balanced to 0
k = shift;
while balanced==0
    [jgoldSeq, balanced] = goldSeqGen(jseq1, jseq2, mod(k,31));
    k = k + 1;
end
    
%% Spreader and Upcarrier
[Tss,time] = spreader(T, mgoldSeq, Tcs, size(mgoldSeq, 2));
[Jss,time] = spreader(J, jgoldSeq, Tcs, size(jgoldSeq, 2));

%multiply by carrier
C = upCarrier(Tss, Fc, time);
C2 = upCarrier(Jss, Fc, time);
%% channel
E = awgn(C, SNR); %adding noise to addition of signal and jammer
E = E + C2;

%% Downcarrier and Despreading
%multiply by carrier
Tsshat = downCarrier(E, Fc, time);

That = despreader(Tsshat, mgoldSeq, size(mgoldSeq, 2));

%% Plot
figure(1)
plot(That,'xb')
axis([-3 3 -3 3])
title('For SNR_i_n = 30dB at point T(hat) and presence of jammer');
xlabel('Real');
ylabel('Imaginary');
grid on;
hold on;
x=-4:4;
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
%% Error checking
[NBE, BER] = biterr(binMessage,Bhat);
rx = (char(bin2dec(reshape(char(Bhat+'0'), 8,[]).')))'