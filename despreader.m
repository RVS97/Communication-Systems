function[That] = despreader(symbols, goldSeq, Nc)

goldSeqRep = repmat(goldSeq, 1, size(symbols,2)/Nc);
goldSeqRep = -2*goldSeqRep + 1;

symbols = symbols.*goldSeqRep;

for i = 0:(size(symbols,2))/Nc -1
   That(i+1) = mean(symbols(Nc*i+1:Nc*(i+1)));        % Taking averages of the demodulated symbols 
end


end