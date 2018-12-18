function[sequence] = seqgen(coeffs)
%coeeficients in array form
selectedcoeffs = find(coeffs); % select non-zero coeffs

bits = ones(size(coeffs));
Nc = 2^(size(bits,2)) - 1; %sequence period
temp = bits;

sequence = [31];
for i=1:Nc % concatenation of bits to [sumof(coeffs),2:end] using temp
    sequence(i) = temp(size(bits,2));
    temp(1) = mod(sum(bits(selectedcoeffs)),2);
    temp(2:size(bits,2)) = bits(1:size(bits,2)-1);
    bits = temp;
end
end