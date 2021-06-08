pkg load signal %carregamento do pacote

fs = 44100; %frqu�ncia de amostragem
n = 6; %n�mero de ordens
wc = 2*pi/3; %frequ�ncia digital
Td = 1/fs; %Per�odo de amostragem
wn = 2*tan(wc/2)/Td; %frequ�ncia anal�gica transformada para uso na Bilinear

[Bs,As] = butter(n, wn, "s"); %construindo filtro butterworth
[Zb,Za] = bilinear(Bs, As, Td);

[sos,g] = tf2sos(Zb,Za); %transforma��o para cascata

%Arrendondamento:
sos = round(sos .* 1) ./ 1;

%Plotagem dos gr�ficos com e sem arrendondamento:
[B,A] = sos2tf(sos, g); 
[h, w] = freqz(Zb, Za)
[hsos, wsos] = freqz(B, A)
figure(1)
freqz_plot(w, h)
title("Plotagem sem truncamento - cascata");
figure(2)
freqz_plot(wsos, hsos)  
title("Plotagem com truncamento - cascata");