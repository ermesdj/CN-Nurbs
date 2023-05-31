function [Punti_C,num_p] = Selezione_Punti(handles)

%--------------------------------------------------------------------------
%DESCRIZIONE FUNZIONE
%--------------------------------------------------------------------------
%Questa funzione permette di selezionare i punti di controllo dal grafico.
%Ogni inserimento avviene cliccando sul grafico con il tasto sinistro del
%mouse. 
%L'inserimento termina premendo il tasto esc sulla tastiera.
%--------------------------------------------------------------------------
%OUTPUT
%--------------------------------------------------------------------------
%La funzione restituisce:
%- la matrice Punti_C contenente le coordinate dei punti di controllo.
%- il numero num_p di punti di controllo.
%--------------------------------------------------------------------------

axis on; %Abilita l'asse
grid on; %Abilita la griglia
hold on; %Mantiene tutte le modifiche successive sugli assi

%Inizializzazione
num_p=0; 
x=[];
y=[];
exit_click=false; %condizione di uscita
set(handles.axes2,'HitTest','off');
set(handles.axes3,'HitTest','off');
set(handles.axes4,'HitTest','off');

%Il ciclo permette di acquisire una serie di punti di controllo, il ciclo
%termina quando viene premuto il tasto esc sulla tastiera.
%I punti raccolti saranno inseriti poi all'interno della matrice restituita
%in output.


while exit_click==false
    [x_t,y_t,esc]= ginput(1);                                              %Aziona il puntatore sul grafico per la selezione dei punti di controllo.
     xlim= get(gca,'XLim');                                                % Prenede i limiti degli assi in modo da ignorare i punti presi al difuori del grafico
     ylim= get(gca,'YLim');                                                % Prenede i clear alllimiti degli assi in modo da ignorare i punti presi al difuori del grafico
    if esc==27                                                             %il tasto Esc restituisce il valore 27 nel ginput.
        exit_click=true;
    elseif (x_t<xlim(1) | x_t>xlim(2) | y_t<ylim(1) | y_t>ylim(2))         %Controlla se il valore acquisito è nei limiti
          set(handles.errori, 'String', 'Puoi inserire punti solo dentro il primo asse');      
    else
        plot(x_t,y_t,'bo');                                                % il punto di controllo selezionato viene mostrato sul grafico
        x=[x,x_t];                                                         % la nuova coordinata x viene posta nel vettore delle coordinate x     
        y=[y,y_t];                                                         % la nuova coordinata y viene posta nel vettore delle coordinate y
        num_p=num_p+1;                                                     % viene incrementato il numero dei punti di controllo inseriti
        set(handles.numpuntic,'String',num_p);                                   % viene aggiornato sull'interfaccia il numero dei punti di controllo inseriti
    end
end

Punti_C=zeros(num_p,2);                                                    % creazione della matrice dei punti di controllo 
[Punti_C]=[x;y];                                                           % inserimento dei vettori x e y nella matrice
set(handles.errori, 'String', ' ');
hold off;                                                                  % disattiva il mantenimento dei dati sul grafico in caso di nuovi inserimenti. 

end