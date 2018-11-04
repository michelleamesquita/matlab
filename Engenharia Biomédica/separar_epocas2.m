function [inicios]=separar_epocas2(anot, limiar)
%%% Retorna os pontos iniciais onde 'anot' atinge um 'limiar' para cima.

aux = find(anot(:) == limiar);

a=diff([0 aux']);
b=find([a]~=1);
c=diff([0 b]);

cima = zeros(1, 15);
valor = 0;
for k=1:length(b)
    valor = valor + a(b(k)) + c(k) - 1;
    cima(k) = valor;
end

inicios = sort([cima]);%sort é para ordenar

end
