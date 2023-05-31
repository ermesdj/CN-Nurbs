function DeBoor (Punti_C,h,t,handles)

%--------------------------------------------------------------------------
% DESCRIZIONE FUNZIONE
%--------------------------------------------------------------------------
% L'algoritmo di DeBoor permette di calcolare la curva B-Spline.
%
% Riassunto funzionamento:
%
% La curva viene calcolata su un insieme di punti contenuti in un vettore
% generato all'interno della funzione stessa e i cui valori saranno  
% interni al range dei nodi.
% Per ognuno di questi punti :
%   -  viene valutata la molteplicità;
%   -  viene trovato il giusto intervallo in cui inserire il punto;
%   -  tramite la funzione Knot_Isertion il punto viene inserito 
%      iterativamente finchè la molteplicità del punto di valutazione 
%      risulta uguale al grado della curva. 
%      Se la molteplicità del punto di valutazione è originariamente uguale
%      al grado della curva non ci sarà alcun inserimento.
%
% Casi di Errore:
%
%   - i nodi inseriti in t non reali;
%   - numero nodi inseriti in t non corretto;
%   - vettore dei nodi t non ordinato;
%--------------------------------------------------------------------------
% INPUT
%--------------------------------------------------------------------------
% La funzione ha in input:
%   - la matrice Punti_C contenente le coordinate dei punti di controllo.
%   - Grado della curva h
%   - Vettore dei nodi t
%--------------------------------------------------------------------------
% OUTPUT
%--------------------------------------------------------------------------
% La funzione restituisce in output il plot della B-Spline.
%--------------------------------------------------------------------------


axis on;
grid on;
hold on;

num_nodi= h+1; %grado della curva bspline
%CONTROLLO ERRORI
num_nodi_corretto= size(Punti_C,2)+h+1; % num_nodi è il numero di nodi da inserire

% verifica che i nodi inseriti siano dei numeri reali
set(handles.errori, 'String', ' I nodi devono essere dei numeri reali.');
validateattributes(t, {'numeric'}, {'real','vector'}); 
set(handles.errori, 'String', ' ');

% verifica che il numero di nodi inseriti sia corretto (uguale a num_nodi_corretto)
if (size(t,2)~=num_nodi_corretto)
    errNodi=sprintf('Il numero di nodi devono essere: %d!',num_nodi_corretto);
    set(handles.errori, 'String', errNodi);
    assert( size(t,2)==num_nodi_corretto);
% verifica che il vettore dei nodi sia ordinato in ordine crescente
elseif (any( t(2:end)-t(1:end-1) < 0))
    set(handles.errori, 'String', 'I nodi devono essere inseriti in ordine crescente');
    assert(not(any( t(2:end)-t(1:end-1) < 0))); % RIPORTA ERRORE SE I NODI NON SONO CRESCENTI 
end

Punti_Calcolo= linspace( t(num_nodi), t(end-h), 10*size(Punti_C,2)); % vettore di punti in cui viene calcolata la curva
C=Algoritmo_DeBoor(Punti_C,Punti_Calcolo,num_nodi,t,h);
line(C(1,:), C(2,:),'LineWidth',2);                                     %la funzione line disegna la curva in base al vettore C costruito.
end     