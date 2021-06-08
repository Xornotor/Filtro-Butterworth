pkg load signal

%[aud, fs] = audioread("E:/andre/Desktop/Filtro Butterworth/cover_altj_intro.wav")

n = 6; %número de ordens
wc = 2*pi/3; %frequência digital
Td = 1/fs; %Período de amostragem
wn = 2*tan(wc/2)/Td; %frequência analógica transformada para uso na Bilinear

[Bs,As] = butter(n, wn, "s"); %construindo filtro butterworth
[Zb,Za] = bilinear(Bs, As, Td); %transformação bilinear

%Plotagem do áudio:
figure(10)
specgram(aud, 256, fs);
title("Plotagem espectrograma pré-processamento");

%Tranformação z-1 = z-2
for k=1:length(Zb)
  BT2(2*(k)-1) = Zb(k)
  AT2(2*(k)-1) = Za(k)
  BT2(2*(k)) = 0
  AT2(2*(k)) = 0
end

%Filtragem do áudio com o filtro z-2:
aud_filtT2 = filtfilt(BT2, AT2, aud);
[S, f, t] = specgram(aud_filtT2);
figure(11)
specgram(aud_filtT2, 256, fs);
title("Plotagem espectrograma com z-2");

[hT2, wT2] = freqz(BT2, AT2) 
figure(12)
freqz_plot(wT2, hT2)
title("Plotagem filtro z-2")

%Escrevendo novos arquivos de áudio para cada filtragem:
audiowrite("E:/andre/Desktop/Filtro Butterworth/cover_altj_intro_filt_2.wav", aud_filtT2, fs) %rejeita-faixa