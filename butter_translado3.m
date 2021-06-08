pkg load signal

%[aud, fs] = audioread("E:/andre/Desktop/Filtro Butterworth/cover_altj_intro.wav")

n = 6; %n�mero de ordens
wc = 2*pi/3; %frequ�ncia digital
Td = 1/fs; %Per�odo de amostragem
wn = 2*tan(wc/2)/Td; %frequ�ncia anal�gica transformada para uso na Bilinear

[Bs,As] = butter(n, wn, "s"); %construindo filtro butterworth
[Zb,Za] = bilinear(Bs, As, Td); %transforma��o bilinear

%Plotagem do �udio:
figure(13)
specgram(aud, 256, fs);
title("Plotagem espectrograma pr�-processamento");

%Tranforma��o z-1 = -z-2
for k=1:length(Zb)
  BT3(2*(k)-1) = Zb(k)*realpow(-1, k)
  AT3(2*(k)-1) = Za(k)*realpow(-1, k)
  BT3(2*(k)) = 0
  AT3(2*(k)) = 0
end

%Filtragem do �udio com o filtro -z-2:
aud_filtT3 = filtfilt(BT3, AT3, aud);
[S, f, t] = specgram(aud_filtT3);
figure(14)
specgram(aud_filtT3, 256, fs);
title("Plotagem espectrograma com -z-2");

[hT3, wT3] = freqz(BT3, AT3) 
figure(15)
freqz_plot(wT3, hT3)
title("Plotagem filtro -z-2")

%Escrevendo novos arquivos de �udio para cada filtragem:
audiowrite("E:/andre/Desktop/Filtro Butterworth/cover_altj_intro_filt_3.wav", aud_filtT3, fs) %passa-faixa