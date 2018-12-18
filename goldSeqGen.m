function[goldSeq, x] = goldSeqGen(seq1, seq2, shift)

shiftseq = circshift(seq2,shift); % circular shift by 'shift' sequence 2
for i=1:size(seq1,2)
    goldSeq(i) = seq1(i) + shiftseq(i); % adding seq1 and shifted seq2
    goldSeq = mod(goldSeq,2); % modulo 2
    
end
x = balancedgoldseq(goldSeq);              % Check if balanced

end