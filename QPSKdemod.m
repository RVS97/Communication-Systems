function[out1,out2] = QPSKdemod(point)

% demodulate according to position of point
%&shift by (58-45) in order to center points and minimise error
point = point*exp(j*deg2rad(-13));

% demodulation according to quadrant in which point is
if imag(point)>=0
    out1=0;
else
    out1=1;
end
if real(point)>=0
    out2=0;
else 
    out2=1;
end
    
end