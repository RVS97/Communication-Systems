function That = downCarrier(symbols, Fc, time)
That = zeros(size(symbols));
for t=1:length(symbols)
    That(t) = symbols(t)*exp(-j*2*pi*Fc*time(t));
end
end