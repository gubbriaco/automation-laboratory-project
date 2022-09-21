close all; clc; clear;

A1 = 1; A2 = 1;
f1 = 1; f2 = 8;
T1 = 1/f1; T2 = 1/f2;
phi1 = pi/6; phi2 = 3;
% frequenza di campionamento
fc = 256;
% tempo di campionamento
Tc = 1/fc;
% frequenza fondamentale
T = double(lcm(sym(T1),sym(T2)));
% orizzonte temporale
t = [0 : Tc : T/2 - Tc + 0.56];
% segnale
xn = A1*sin(2*pi*f1*t+phi1)+A2*cos(2*pi*f2*t+phi2);

Nn = length(xn);

%% Dispersione Spettrale
Xn = fft(xn);
wcn = 2*pi/Tc;
wkn = [-fc/2 : fc/Nn : fc/2-fc/Nn];
Xsn = fftshift(Xn);

Xrealn = real(Xsn);
jn = find( abs(Xrealn) <= 10e-10 );
Xrealn(jn) = 0;

Ximaginaryn = imag(Xsn);
jn = find( abs(Ximaginaryn) <= 10e-10 );
Ximaginaryn(jn) = 0;

bin = fc/Nn;
fkn = [-fc/2 : bin : (fc/2) - bin];

figure(1);
subplot(2,1,1),stem(fkn,2*abs(complex(Xrealn,Ximaginaryn))/Nn);
xlabel('f_k'); title('modulo'); grid;
subplot(2,1,2),stem(fkn,(unwrap(angle(complex(Xrealn,Ximaginaryn))))) ; 
xlabel('f_k'); ylabel('fase'); grid;


%% Funzione di Hann
wx1 = hanning(length(xn))';
xw1 = xn.*wx1;

%% Funzione di Bartlett
wx2 = bartlett(length(xn))';
xw2 = xn.*wx2;

%% Modulo e Fase dopo aver applicato la funzione di Hann e la funzione di Bartlett
Xn1 = fftshift(fft(xw1));
Xn2 = fftshift(fft(xw2)); 


Xr1 = real(Xn1); jn = find(abs(Xr1)<=10e-10); Xr1(jn) = 0;
Xi1 = imag(Xn1);jn = find(abs(Xi1)<=10e-10); Xi1(jn) = 0;

Xr2 = real(Xn2); jn = find(abs(Xr2)<=10e-10); Xr2(jn) = 0;
Xi2 = imag(Xn2);jn = find(abs(Xi2)<=10e-10); Xi2(jn) = 0;


figure(2);
subplot(2,1,1),stem(fkn,2*abs(complex(Xr1,Xi1))/Nn); 
xlabel("f_k") ; title('modulo'); grid;
subplot(2,1,2),stem(fkn,(unwrap(angle(complex(Xr1,Xi1))))); 
xlabel("f_k"); title('fase'); grid;

figure(3);
subplot(2,1,1),stem(fkn,2*abs(complex(Xr2,Xi2))/Nn); 
xlabel("f_k"); title('modulo'); grid;
subplot(2,1,2),stem(fkn,(unwrap(angle(complex(Xr2,Xi2))))); 
xlabel("f_k"); title('fase'); grid;


%% Finestratura
figure(4); 
plot(t,xn); 
hold on; 
plot(t,xw1);
hold on;
plot(t,xw2);
grid;
legend('segnale','Hanning','Bartlett');