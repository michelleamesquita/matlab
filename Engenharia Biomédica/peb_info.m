%                PEB_Info.m
%
%   Função que pega algumas informações do arquivo identificado pelo manipulador <fid> com formato PEB.
%
%   Uso: [fid,tamanho,NCanais,NCanPQ,Fs,BitsPorAmostra,Ch_Name,Ch_Units,Cal,tam_header,N_Stim,PQ,nDeriv,Derivacoes,TimeExame,TipoDeExame]=peb_info(fid);

%Maurício Cagy - 23/02/05
%Última revisão: 24/02/17

function [fid,tamanho,NCanais,NCanPQ,Fs,BitsPorAmostra,Ch_Name,Ch_Units,Cal,tam_header,N_Stim,PQ,nDeriv,Derivacoes,TimeExame,TipoDeExame]=peb_info(fid);
global UseChunk N_Chunk i_Chunk FPos_Chunk;
UseChunk=0; N_Chunk=0; i_Chunk=0;
if nargin==0,
  [File,Pth]=uigetfile('*.peb','Selecione o arquivo de dados');
  if File==0, return; end;
  fid=fopen([Pth,File]);
end;
%Vê o tamanho do arquivo em Bytes:
fseek(fid,0,'eof');
tamanho=ftell(fid);
fseek(fid,0,'bof');
%Inicializa índice do canal de estimulação:
N_Stim=[];
%Confere versão, se for a partir da 2.0:
NChar=fread(fid,1,'uint8');
if NChar==0,
  MajorV=fread(fid,1,'uint8');
  MinorV=fread(fid,1,'uint8');
  NChar=fread(fid,1,'uint8');
else,
  MajorV=1;
  MinorV=0;
end;
Versao=MajorV+0.1*MinorV;
%Lê o cabeçalho:
TipoDeExame=setstr(fread(fid,NChar,'uchar')');
Corrige=0; NIErro=0;
if MajorV<2,
  if strcmp(lower(TipoDeExame),'eletroencefalografia') | strcmp(lower(TipoDeExame(1:9)),'neuroling')...
    | strcmp(lower(TipoDeExame),'p300 - tiro'),
    Corrige=1; %Correção da polaridade invertida dos equipamentos EMSA, que não era prevista nas versões anteriores dos programas de aquisição
  end;
  if strcmp(lower(TipoDeExame(1:8)),'ni-daqmx'),
    NIErro=1;
  end;
end;
Fs=fread(fid,1,'float32');
if Versao>2.0,
  BitsPorAmostra=fread(fid,1,'uint8'); %Versão 2.1 em diante
else,
  BitsPorAmostra=16;
end;
if Versao>2.1,
  UseChunk=fread(fid,1,'uint8'); %Versão 2.2 em diante
end;
NChar=fread(fid,1,'uint8');
TimeUnit=setstr(fread(fid,NChar,'uchar')');
NCanais=fread(fid,1,'uint8');
if Versao>2.0,
  NCanPQ=fread(fid,1,'uint8');
  P=fread(fid,1,'uint16');
  Q=fread(fid,1,'uint16');
else,
  NCanPQ=0; P=0; Q=1;
end;
PQ=[P,Q];
if NIErro, NCanais=NCanais-1; end;
NCanTot=NCanais+NCanPQ;
cAng=fread(fid,[1,NCanTot],'float64');
if Corrige,
  cAng(1:20)=-cAng(1:20);
end;
cLin=fread(fid,[1,NCanTot],'float64');
for i=1:NCanTot,
  NChar=fread(fid,1,'uint8');
  Ch_Name{i}=setstr(fread(fid,NChar,'uchar')');
end;
for i=1:NCanTot,
  NChar=fread(fid,1,'uint8');
  Ch_Units{i}=setstr(fread(fid,NChar,'uchar')');
end;
if NIErro, NCanais=NCanais+1; cAng(NCanais)=1; cLin(NCanais)=0; Ch_Name{NCanais}='DI'; Ch_Units{NCanais}='bin'; end;
TemEstim=fread(fid,1,'uint8');
if TemEstim>0,
  for i=1:TemEstim,
    Ch_Name{i+NCanais}=sprintf('Est%d',i);
    Ch_Units{i+NCanais}='';
  end;
  NCanais=NCanais+TemEstim;
  N_Stim=NCanais;
end;
if Versao>2.1,
  nDeriv=fread(fid,1,'uint16');
  Derivacoes=fread(fid,[2,nDeriv],'int16')'+1;
else,
  nDeriv=0;
  Derivacoes=[];
end;
cAng=[cAng,ones(1,TemEstim)];
cLin=[cLin,zeros(1,TemEstim)];
HighCutOff=fread(fid,1,'float32');
LowCutOff=fread(fid,1,'float32');
AnoExame=fread(fid,1,'uint16');
MesExame=fread(fid,1,'uint8');
DiaExame=fread(fid,1,'uint8');
HoraExame=fread(fid,1,'uint8');
MinExame=fread(fid,1,'uint8');
if Versao>2.0,
  SegExame=fread(fid,1,'uint16')/1000;
else
  SegExame=0;
end;
TimeExame=[AnoExame,MesExame,DiaExame,HoraExame,MinExame,SegExame];
NChar=fread(fid,1,'uint8');
Comments=setstr(fread(fid,NChar,'uchar')');
tam_header=ftell(fid); %tamanho do cabeçalho
Cal=[cAng;cLin];
FPos_Chunk=tam_header;