function C = upCarrier(symbols, Fc, time)
C = zeros(size(symbols));
for t=1:length(symbols)
    C(t) = symbols(t)*exp(j*2*pi*Fc*time(t));
end
end