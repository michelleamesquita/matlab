%            PEB_Read.m
%
%     Função que retorna N amostras de sinal para todos os canais, e a posição atual do
%ponteiro do arquivo. Se o quinto argumento de entrada for 'pula', as amostras não são
%montadas e o ponteiro simplesmente pula para a posição após estas N amostras.
%
%     Uso:
% [sinal,sinalPQ,N]=PEB_Read(fid,N,Cal,NCanais,BitsPorAmostra,NCanPQ,PQ,'pula_ou_não');

%Maurício Cagy - 24/02/05
%Última revisão: 28/04/17

function [sinal,sinalPQ,N_Lidos]=peb_read(fid,N,Cal,NCanais,BitsPorAmostra,NCanPQ,PQ,pula_str);
global UseChunk N_Chunk i_Chunk FPos_Chunk;
%Confere se monta ou não a matriz de sinal:
if nargin==8,
  if pula_str(1)=='p' | nargout==0,
    pula=1;
  else,
    pula=0;
  end;
else,
  pula=0;
end;
if UseChunk,
  pula=0;
  if ftell(fid)~=FPos_Chunk,
    error('Erro de posicionamento no ponteiro do arquivo!');
  end;
end;
if nargin<7, PQ=[0,1]; end;
if nargin<6, NCanPQ=0; end;
if nargin<5, BitsPorAmostra=16; end;
switch BitsPorAmostra,
case 8, prec='int8';
case 16, prec='int16';
case 24, prec='bit24';
case 32, prec='int32';
otherwise, error('Formato de amostras inválido!');
end;
if UseChunk, %Se usa chunk, não pode haver caais PQ (com taxa de amostragem diferente)
  pula=0;
  PQ=[0,1];
  NCanPQ=0;
end;
%Recalcula número de amostras (buffer normal) com base no valor de Q para que haja um número inteiro de blocos:
P=PQ(1); Q=PQ(2);
if isempty(N),
  N=10;
elseif isinf(N),
  pos=ftell(fid);
  fseek(fid,0,'eof');
  N=ftell(fid)*8/BitsPorAmostra/NCanais; %estimativa do número de canais
  fseek(fid,pos,'bof');
end;
%Organiza parâmetros de calibração:
if NCanPQ==0,
  vAng=Cal(1,:);
  vLin=Cal(2,:);
else,
  vAng=Cal(1,1:NCanais);
  vLin=Cal(2,1:NCanais);
  vAPQ=Cal(1,NCanais+1:end);
  vLPQ=Cal(2,NCanais+1:end);
end;
K=ceil(N/Q); N=K*Q; M=P*N/Q;
N_Lidos=0; N_Sobra=0;
sinal=[]; rasc=nan;
while N>0,
  if pula,
    if NCanPQ==0,
      fseek(fid,NCanais*N*2,'cof');
    else,
      fseek(fid,NCanais*N*2+NCanPQ*M*2,'cof');
    end;
    sinal=[]; sinalPQ=[];
    N=0;
  else,
    if NCanPQ==0,
      if UseChunk,
        if i_Chunk==0,
          N_Chunk=fread(fid,1,'uint16'); %Número de amostras do Chunk atual
          TS=tdatetime2date(fread(fid,1,'float64')); %TimeStamp do Chunk atual (converte do formato do Pascal para o do Matlab)
          Flags=fread(fid,1,'uint8'); %Flags de filtros ou parâmetros alterados no chunk atual
        end;
        N_Sobra=N_Chunk-i_Chunk;
        if N_Sobra>N,
          NSmp=N;
          i_Chunk=i_Chunk+NSmp;
        elseif N_Sobra==N,
          NSmp=N;
          i_Chunk=0;
        else,
          NSmp=N_Sobra;
          i_Chunk=0;
        end;
        TSant=TS;
      else,
        NSmp=N;
      end;
      rasc=fread(fid,[NCanais,NSmp],prec)';
      sinal=[sinal;rasc];
      sinalPQ=[];
      N_Lidos=size(rasc,1);
    else,
      sinal=zeros(N,NCanais); sinalPQ=zeros(M,NCanPQ);
      for i=1:K,
        rasc=fread(fid,[NCanais,Q],prec)';
        rascPQ=fread(fid,[NCanPQ,P],prec)';
        QQ=size(rasc,1);
        if QQ==Q,
          sinal((i-1)*Q+1:i*Q,:)=rasc;
          sinalPQ((i-1)*P+1:i*P,:)=rascPQ;
        else,
          PP=size(rascPQ,1);
          if ~isempty(rasc), sinal((i-1)*Q+1:(i-1)*Q+QQ,:)=rasc; end;
          if ~isempty(rascPQ), sinalPQ((i-1)*P+1:(i-1)*P+PP,:)=rascPQ; end;
          sinal=sinal(1:(i-1)*Q+QQ,:);
          sinalPQ=sinalPQ(1:(i-1)*P+PP,:);
          break;
        end;
      end;
    end;
    if UseChunk,
      N=N-N_Lidos;
    else,
      N=0;
    end;
  end;
  if isempty(sinal) | isempty(rasc), break; end;
end;
N_Lidos=size(sinal,1);
M=size(sinalPQ,1);
if ~isempty(sinal),
  if ~any(vAng==0),
    sinal=(sinal-(ones(N_Lidos,1)*vLin)).*(ones(N_Lidos,1)*vAng);
  end;
end;
if ~isempty(sinalPQ),
  if ~any(vAPQ==0),
    sinalPQ=(sinalPQ-(ones(M,1)*vLPQ)).*(ones(M,1)*vAPQ);
  end;
end;
FPos_Chunk=ftell(fid);
