function[point] = QPSKmod(a,b,amp)

% map to points 1,2,3,4 according to a & b (00,01,10,11)
% phase of points are 58, 148, 238(-122) and 328(-32) degrees
point = 0;

if a==0
    if b==0
        point = amp*exp(j*deg2rad(58)); % 00
    else
        point = amp*exp(j*deg2rad(148)); % 01
    end
else
    if b==0
        point = amp*exp(j*deg2rad(-32)); % 10
    else
        point = amp*exp(j*deg2rad(-122)); % 11
    end
end