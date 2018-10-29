
function interface
fig = figure('color','c');
movegui(fig,'center');
button= uicontrol('Parent',fig,'Style','pushbutton','String','Azul', 'Position', [20 30 60 30]);
set(button,'Callback',@azul);
button2= uicontrol('Parent',fig,'Style','pushbutton','String','Verde', 'Position', [100 30 60 30]);
set(button2,'Callback',@verde);
button3= uicontrol('Parent',fig,'Style','pushbutton','String','Vermelho', 'Position', [180 30 60 30]);
set(button3,'Callback',@vermelho);
button4= uicontrol('Parent',fig,'Style','pushbutton','String','Cinza', 'Position', [260 30 60 30]);
set(button4,'Callback',@cinza);
button5= uicontrol('Parent',fig,'Style','pushbutton','String','Histograma', 'Position', [340 30 60 30]);
set(button5,'Callback',@hist);
button6= uicontrol('Parent',fig,'Style','pushbutton','String','Filtro Amarelo', 'Position', [420 30 80 30]);
set(button6,'Callback',@filtam);



[im map] = imread('dory.jpg');
imshow(im);
title('Edição de Imagem');

function b = azul(hObject,event)
      
    imb=im;
    imb(:,:,1)=0; %preto
    imb(:,:,2)=0; %azul
    b=imshow(imb);
    
    title('Azul');    
    
end
function v = verde(hObject,event)
    
    img=im;
    img(:,:,1)=0; %preto
    img(:,:,3)=0; %verde
    v=imshow(img);
    title('Verde');   
    
end

function ve = vermelho(hObject,event)
    imgve=im;
    imgve(:,:,2)=0; %azul
    imgve(:,:,3)=0; %verde
    ve=imshow(imgve);
    title('Vermelho');
    
end

function c = cinza(hObject,event)
    imGrayM=rgb2gray(im);
    c=imshow(imGrayM);
    title('Imagem Cinza');
end

function h=hist(hObject,event)
    Red = im(:,:,1);
    Green = im(:,:,2);
    Blue = im(:,:,3);
    
    [yRed, x] = imhist(Red);
    [yGreen, x] = imhist(Green);
    [yBlue, x] = imhist(Blue);
    
     h=plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');

    h=imhist(im, map)
end
    
    function filtroam= filtam(hObject,event)
        tmp=acharCor(im, [60 60 200], [1 1 1]);
        filtroazul=imshow(tmp)
    end

        

    function img = acharCor(img,tresholds,map)
        for k = 1:size(img,1)
            for kk =1:size(img,2)
                    if map(1)*img(k,kk,1)>map(1)*tresholds(1) && map(2)*img(k,kk,2)>map(2)*tresholds(2) &&img(k,kk,3)*map(3)<map(3)*tresholds(3)

                    else
                         img(k,kk,:) = [0 0 0];
                    end

            end
        end
     end


end