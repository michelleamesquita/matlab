function [ temp ] = rejeitarartefato(epocas, limiar)
%REJEITARARTEFATO Retorna as epocas dps da remoçao por um limiar
%   Detailed explanation goes here

temp = [];
for epoca=1:size(epocas, 2)
    aux1 = find(epocas(:,epoca) > limiar);
    aux2 = find(epocas(:,epoca) < -limiar);
    if isempty(aux1) && isempty(aux2)
        temp = [temp epocas(:,epoca)];
    end
end

end

