%Clear the command window and workspace
clear all;
clc;

%Get the user to input the sample
sample = input('Input file name for sample: ', 's');

%Create 2 new arrays based upon the reading of the sample
[data, fs] = audioread(sample);
data(:,2) = [];     %Make the second column of the array null, changing from stereo to mono

sound(data,fs);     %Play the sample for the user to hear
T = 1/fs;           %Define the peroid of the sample
L = length(data);   %Define length of the sample
t = (0:L-1)*T;      %Define time in seconds of sample

y = fft(data);      %Get the fast fourier transform of the sample


%Get one side of the real values of FFT results
P2=abs(y/L);
P1=P2(1:L/2+1);
P1(2:end-1)=2*P1(2:end-1);

%Define frequency domain
ff = fs*(0:(L/2))/L;

%Plot the audio data against time
subplot(2,1,1);
plot(t,data);
title('Sample Audio');
xlabel('Time (S)') 
ylabel('Amplitude') 

%Plot the non-normalised FFT results
subplot(2,1,2);
plot(ff, P1);
title('Harmonics of sample')
xlabel('Frequency (Hz)') 
ylabel('Amplitude') 

i = 5;
while (i==5)
i = input('Enter harmonic to filter (0 for fundamental, 1, 2, 3 or 4): ');
switch i
    case 0
        filt = getFilterF;
    case 1
        filt = getFilter1;
    case 2
        filt = getFilter2;
    case 3
        filt = getFilter3;
    case 4
        filt = getFilter4;
    otherwise
        i = 5;
end
end

z = filter(filt, data);

%Play both of the samples with a pause between them
fprintf('Playing original sample\n');
sound(data, fs);
pause(t+1);
fprintf('Playing filtered sample\n');
sound(z, fs);

%Get one side of the real values of filtered sample's FFT
zfft = fft(z);

P2z=abs(zfft/L);
P1z=P2z(1:L/2+1);
P1z(2:end-1)=2*P1z(2:end-1);

subplot(4,1,1);
plot(t,data);
title('Sample Audio');
xlabel('Time (S)') 
ylabel('Amplitude') 

subplot(4,1,2);
plot(t,z);
title('Filtered Sample Audio');
xlabel('Time (S)') 
ylabel('Amplitude') 

subplot(4,1,3);
plot(ff, P1);
title('Harmonics of sample')
xlabel('Frequency (Hz)') 
ylabel('Amplitude') 

subplot(4,1,4);
plot(ff, P1z);
title('Harmonics of filtered sample')
xlabel('Frequency (Hz)') 
ylabel('Amplitude') 

filename = input('Input the name of your file: ', 's');
audiowrite(filename, z, fs);

