pkg load signal

%[aud, fs] = audioread("E:/andre/Desktop/Filtro Butterworth/cover_altj_intro.wav")

fs = 44100
n = 6; %número de ordens
wc = 2*pi/3; %frequência digital
Td = 1/fs; %Período de amostragem
wn = 2*tan(wc/2)/Td; %frequência analógica transformada para uso na Bilinear

[Bs,As] = butter(n, wn, "s"); %construindo filtro butterworth
[Zb,Za] = bilinear(Bs, As, Td); %transformação bilinear

Zbr = round(Zb .* 10) ./ 10
Zar = round(Za .* 10) ./ 10

[h, w] = freqz(Zb, Za)
figure(3)
freqz_plot(w, h)
title("Plotagem sem truncamento");

[hr, wr] = freqz(Zbr, Zar)
figure(4);
freqz_plot(wr, hr)
title("Plotagem com truncamento");

%Plotagem do áudio:
figure(5)
specgram(aud, 256, fs);
title("Plotagem espectrograma pré-processamento");

%Filtragem do áudio com o filtro z-1:
aud_filt = filtfilt(Zb, Za, aud);
[S, f, t] = specgram(aud_filt);
figure(6)
specgram(aud_filt, 256, fs);
title("Plotagem espectrograma com z-1");

%Escrevendo novos arquivos de áudio para cada filtragem:
audiowrite("E:/andre/Desktop/Filtro Butterworth/cover_altj_intro_filt.wav", aud_filt, fs) %passa-baixa