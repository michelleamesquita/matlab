function[Ch_Name,EEG,anot,Fs] = lerPeb(file)

%file='Matheus 4 direito.peb';

fid = fopen(file);

[fid,tamanho,NCanais,NCanPQ,Fs,BitsPorAmostra,Ch_Name,Ch_Units,Cal,tam_header,N_Stim,PQ,nDeriv,Derivacoes,TimeExame,TipoDeExame]=peb_info(fid);

%Acessa amostras dos sinals:
NAmostras=inf; %"inf" significa ler todas amostras no arquivo
[sinal,kinect,N_Lidos]=peb_read(fid,NAmostras,Cal,NCanais,BitsPorAmostra,NCanPQ,PQ);

%figure;
%Desenha EEG:
EEG=sinal(:,1:20);
tempo=[0:N_Lidos-1]/Fs;
subplot(5,1,1); 
plot(tempo,EEG);
ylabel('EEG');

%Procura os canais AC (EMG), DC (Plataforma), NI (AcelerŸmetro) e Anota¡?o:
ChEMG=[]; ChPlt=[]; ChAce=[]; ChAno=[];
for i=1:length(Ch_Name),
    if ~isempty(findstr(Ch_Name{i},'AC')),
        ChEMG=[ChEMG,i];
    elseif ~isempty(findstr(Ch_Name{i},'DC')) | ~isempty(findstr(Ch_Name{i},'Plt')),
        ChPlt=[ChPlt,i];
    elseif ~isempty(findstr(Ch_Name{i},'NI')),
        ChAce=[ChAce,i];
    elseif ~isempty(findstr(Ch_Name{i},'Est')),
        ChAno=[ChAno,i];
    end;
end;



if ~isempty(ChAno),
    anot=sinal(:,ChAno(1)); %primeiro canal de anota¡?o » o que cont»m os c€digos
    subplot(5,1,5); 
    plot(tempo,anot);
    ylabel('Anota¡?o');
end

xlabel('Tempo (s)');



fclose(fid);
end