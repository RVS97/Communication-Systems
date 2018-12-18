function[Tss,time] = spreader(symbols, goldSeq, Tcs, Nc)

for i=1:size(symbols,2)*Nc
    time(i) = (i)*(Tcs/Nc);
end

for j=0:size(symbols,2)-1
    Tss((Nc*j) + 1:Nc*(j+1))=symbols(j+1);
end

goldSeqRep = repmat(goldSeq, 1, size(symbols,2));
goldSeqRep = -2*goldSeqRep + 1;

Tss = Tss.*goldSeqRep;

end