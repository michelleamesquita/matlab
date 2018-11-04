function [mepocas,time,n_epocas]=mediacoerente2(anot, sinal, canal, fs, limiar)
%MEDIACOERENTE2 Retorna mediacoerente,tempo e numero de epocas
%   Anot : Anotação do sinal
%   Fs Frequencia de amostragem do sinal em Hz
%   Sinal que eu quero processar
%   Canal: Numero do Canal a ser coletado


%por enquanto usar funcaoCriarAnot anot(1:72000)=CriarAnot(Fs,120,20);
%mediacoerente(anot,emg,1,Fs)
%figure;plot(mediacoerente(anot,emg,1,Fs))
%anot(1:72000)=CriarAnot(Fs,120,20);

inicios = separar_epocas2(anot, limiar);

% Definir tamanho da epoca
mini = fix(10*fs)+fix(2*fs);
pre = fix(2*fs);


% Filtragem inicial
[b,a] = butter(2,1/(fs/2),'high');
sinal = filter(b, a, sinal);

% Mais uma filtragem
[b,a] = butter(2,4/(fs/2),'low');
sinal = filter(b, a, sinal);

[b,a] = butter(4,4/(fs/2),'low');
sinal = filter(b, a, sinal);

% Separar as epocas
%epocas = zeros(mini+pre, length(inicios));
%saber o tamanho da epoca
epocas = zeros(mini+pre, 15);
rotacao = 1;
for epoca=1:length(inicios)
    if (limiar == 50)
        if (mod(epoca, 8) == 0)
            continue;
        end
    end
    
    epocas(:,rotacao) = sinal(inicios(epoca)-pre:inicios(epoca)+mini-1, canal);
    rotacao = rotacao+1;
end

time = (-pre:mini-1)/fs;

% Remoçao de artefatos
epocas = rejeitarartefato(epocas, 150);

n_epocas = min(size(epocas));

% Média coerente
mepocas = mean(epocas, 2);


end