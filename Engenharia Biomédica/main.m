clc
clear
close all

file = dir('Dados/*.peb');

mc_todos = [];
h =[];

todos_n_rotacao = [];

limiar=100;
limiar2=50;

for volun=1:3:length(file)-1
    disp(['Processando voluntario ' num2str(volun)]);
    
    [Ch_Name,EEG,anot,Fs] = lerPeb(['Dados/' file(volun).name]);
    [~,EEG2,anot2,~] = lerPeb(['Dados/' file(volun+1).name]);
    [~,EEG3,anot3,~] = lerPeb(['Dados/' file(volun+2).name]);
    
    EEG = [EEG; EEG2; EEG3];
    clear EEG2 EEG3 
    anot = [anot; anot2; anot3];
    clear anot2 anot3
    fig_ = figure('Name', strcat('Media Coerente EEG Velocidade Minima ->',file(volun).name,file(volun+1).name));
    fig_max = figure('Name', strcat('Media Coerente EEG Velocidade Maxima ->',file(volun).name,file(volun+1).name));
    qtd_canais = size(EEG, 2);
    
    mediac_ = [];
    mediac2_=[];
   
    for canal=1:qtd_canais
        [mepocas,time,n_epocas] = mediacoerente2(anot, EEG, canal, Fs,limiar);
        [mepocas2,time2,n_epocas2]= mediacoerente2(anot,EEG,canal,Fs,limiar2); 
        
        mediac_ = cat(2, mediac_, mepocas);
        set(0,'CurrentFigure',fig_)
        subplot(5,4,canal) %canal{1;4;5;6;7;8;9;12;13;14;15;16;17;18;19;20});
        plot(time, mepocas);
        title(Ch_Name(canal));
        xlim([-2 12]);
        ylim([-10 10]);
        
        mediac2_ = cat(2, mediac2_, mepocas2);
        set(0,'CurrentFigure',fig_max)
        subplot(5,4,canal) %canal{1;4;5;6;7;8;9;12;13;14;15;16;17;18;19;20});
        plot(time, mepocas2);
        title(Ch_Name(canal));
        xlim([-2 12]);
        ylim([-10 10]);
        
        
       quero=[4;12;1;5;17;13;9;6;18;14;7;19;15;8;20;16];
       local_fig=[2;4;6;7;8;9;10;12;13;14;17;18;19;22;23;24];
       
       for i=1:length(quero) 
       
       
       if canal == quero(i)
       
       figmax=figure(5);
       figmax.Name='Velocidade Max';
       
           
       subplot(5,5,local_fig(i))
       plot(time,mepocas)
       hold on
       %axis([10 12 -10 10]);
       xlim([-2 12]);
       %xlim([10 12]);
       ylim([-10 10]);
       xlabel ('TIME (S)')
       ylabel ('AMPLITUDE (µV)')
       title(Ch_Name(quero(i)))
       hold on
        
       figmin=figure(6);
       figmin.Name='Velocidade Min';
      
        
       subplot(5,5,local_fig(i))
       plot(time,mepocas2)
       hold on
       %axis([-2 0 -10 10]);
       xlim([-2 12]);
       %xlim([-2 0]);
       ylim([-10 10]);
       xlabel ('TIME (S)')
       ylabel ('AMPLITUDE (µV)')
       title(Ch_Name(quero(i)))
       hold on
       
       
       figmax=figure(7);
       figmax.Name='Velocidade Max - Pré Estímulo';
       
           
       subplot(5,5,local_fig(i))
       plot(time,mepocas)
       hold on
       axis([-2 2 -10 15]);
       xlim([-2 2]);
       ylim([-10 15]);
       xlabel ('TIME (S)')
       ylabel ('AMPLITUDE (µV)')
       title(Ch_Name(quero(i)))
       hold on
        
       figmin=figure(8);
       figmin.Name='Velocidade Min - Pré-Estímulo';
      
        
       subplot(5,5,local_fig(i))
       plot(time,mepocas2)
       hold on
       axis([-2 2 -10 15]);
       xlim([-2 2]);
       ylim([-10 15]);
       xlabel ('TIME (S)')
       ylabel ('AMPLITUDE (µV)')
       title(Ch_Name(quero(i)))
       hold on
       
       
       
       figmax=figure(9);
       figmax.Name='Velocidade Max Pós-Estímulo';
       
           
       subplot(5,5,local_fig(i))
       plot(time,mepocas)
       hold on
       axis([8 12 -10 15]);
       xlim([8 12]);
       ylim([-10 15]);
       xlabel ('TIME (S)')
       ylabel ('AMPLITUDE (µV)')
       title(Ch_Name(quero(i)))
       hold on
        
       figmin=figure(10);
       figmin.Name='Velocidade Min Pós-Estímulo';
      
        
       subplot(5,5,local_fig(i))
       plot(time,mepocas2)
       hold on
       axis([8 12 -10 15]);
       xlim([8 12]);
       ylim([-10 15]);
       xlabel ('TIME (S)')
       ylabel ('AMPLITUDE (µV)')
       title(Ch_Name(quero(i)))
       hold on
       
       
       end 
       end
       
       
       

      
       
       
    end   
    
     
   
end


 
