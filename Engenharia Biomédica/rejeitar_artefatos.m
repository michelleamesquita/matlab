function [epocas_rejeitadas]=rejeitar_artefatos(epocas, tamanho, limiar, percentual)
% [epocas_rejeitadas]=rejeitar_artefatos(epocas, tamanho, limiar, percentual)
%   Recebe as epocas em uma matriz onde cada coluna é uma epoca
%   Retorna as colunas (epocas) que devem ser rejeitadas. Ou seja, uma
%   sequencia maior que o percentual esta acima do limiar

    janela = ceil(tamanho * percentual);
    
    epocas_rejeitadas = [];
    
    for epoca=1:size(epocas, 2)
        aux = find(epocas(:,epoca) > limiar);

        a=diff(aux');
        b=find([a inf]>1);
        c=diff([0 b]); % aqui tem o tamanho das sequencias
        
        if max(c) >= janela
            epocas_rejeitadas = [epocas_rejeitadas epoca];
        end
    end 
end