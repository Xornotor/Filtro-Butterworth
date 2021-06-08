pkg load signal

%[aud, fs] = audioread("E:/andre/Desktop/Filtro Butterworth/cover_altj_intro.wav")

n = 6; %n�mero de ordens
wc = 2*pi/3; %frequ�ncia digital
Td = 1/fs; %Per�odo de amostragem
wn = 2*tan(wc/2)/Td; %frequ�ncia anal�gica transformada para uso na Bilinear

[Bs,As] = butter(n, wn, "s"); %construindo filtro butterworth
[Zb,Za] = bilinear(Bs, As, Td); %transforma��o bilinear

%Plotagem do �udio:
figure(7)
specgram(aud, 256, fs);
title("Plotagem espectrograma pr�-processamento");

%Transforma��o z-1 = -z-1
for i=1:length(Zb)
  BT1(i) = Zb(i)*realpow(-1, i)
  AT1(i) = Za(i)*realpow(-1, i)
end

%Filtragem do �udio com o filtro -z-1:
aud_filtT1 = filtfilt(BT1, AT1, aud);
[S, f, t] = specgram(aud_filtT1);
figure(8)
specgram(aud_filtT1, 256, fs);
title("Plotagem espectrograma com -z-1");

[hT1, wT1] = freqz(BT1, AT1) 
figure(9)
freqz_plot(wT1, hT1)
title("Plotagem filtro -z-1")

%Escrevendo novos arquivos de �udio para cada filtragem:
audiowrite("E:/andre/Desktop/Filtro Butterworth/cover_altj_intro_filt_1.wav", aud_filtT1, fs) %passa-alta