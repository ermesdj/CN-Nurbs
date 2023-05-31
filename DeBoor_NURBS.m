function DeBoor_NURBS (Punti_C, h, t, w, handles)

%--------------------------------------------------------------------------
% DESCRIZIONE FUNZIONE
%--------------------------------------------------------------------------
% La funzione implementa l'algoritmo di De Boor adattato alle NURBS. 
%
% Riassunto funzionamento:
%
% La principale differenza con rispetto al caso delle B-Spline sta nel 
% fatto che per le Nurbs avremo dei pesi per ogni punto di controllo. 
% Per poter applicare l'algoritmo di de Boor dovremo quindi convertire 
% i punti di controllo 2D ,utilizzati per il tracciamento delle B-Spline,
% in punti di controllo a 3 dimensioni, dove:
%   - le prime due dimensioni sono pari alle coordinate moltiplicate per il 
%     peso del punto di controllo stesso 
%   - la terza il peso stesso del punto di controllo
% Infine, dopo aver applicato l'algoritmo di DeBoor sui punti di calcolo a 
% tre dimensioni, si proietteranno quest'ultimi nuovamente in due 
% dimensioni, per il tracciamento delle curve di NURBS.
% 
% Casi di Errore:
% 
% Oltre ai casi d'errore in cui ci si trovava nel caso di DeBoor applicato
% alle B-Spline, l'algoritmo va in errore se:
%   - il numero dei pesi inserito non è pari al numero dei punti di 
%     controllo
%--------------------------------------------------------------------------
% INPUT
%--------------------------------------------------------------------------
% La funzione ha in input:
%   - la matrice Punti_C contenente le coordinate dei punti di controllo.
%   - Grado della curva h
%   - Vettore dei nodi t
%   - Vettore dei pesi w
%--------------------------------------------------------------------------
% OUTPUT
%--------------------------------------------------------------------------
% La funzione restituisce in output il plot della NURBS.
%--------------------------------------------------------------------------

axis on;
grid on;
hold on;

num_nodi= h+1; %grado della curva bspline

num_nodi_corretto= size(Punti_C,2)+h+1; % num_nodi è il numero di nodi da inserire



% verifica che i nodi inseriti siano dei numeri reali
set(handles.errori, 'String', ' I nodi devono essere dei numeri reali.');
validateattributes(t, {'numeric'}, {'real','vector'}); 
set(handles.errori, 'String', ' ');

% verifica che il numero di nodi inseriti sia corretto (uguale a num_nodi_corretto)
if ( size(t,2)~=num_nodi_corretto)
    errNodi=sprintf('Il numero di nodi devono essere: %d!',num_nodi_corretto);
    set(handles.errori, 'String', errNodi);
    assert( size(t,2)==num_nodi_corretto);

% verifica che il vettore dei nodi sia ordinato in ordine crescente
elseif (any( t(2:end)-t(1:end-1) < 0))
    
    set(handles.errori, 'String', 'I nodi devono essere inseriti in ordine crescente');
    assert(not(any( t(2:end)-t(1:end-1) < 0))); % RIPORTA ERRORE SE I NODI NON SONO CRESCENTI 
    
elseif (size(w,2)~=size(Punti_C,2))
    
    set(handles.errori, 'String', 'Il vettore dei pesi deve avere tanti pesi quanti sono i punti di controllo');
    assert(size(w,2)==size(Punti_C,2));
end


Punti_C = [Punti_C(1,:) .* w(1,:); Punti_C(2,:) .* w(1,:); w]; 
% aggiusto la matrice dei punti di controllo aggiungendo i pesi e
% moltiplicando questi ultimi alle coordinate corrispondenti.

Punti_Calcolo= linspace(t(num_nodi), t(end-h), 10*size(Punti_C,2)); % vettore di punti in cui viene calcolata la curva
C=Algoritmo_DeBoor(Punti_C,Punti_Calcolo,num_nodi,t,h);
 
 % proietto nuovamente i punti di controllo 
 % in due dimensioni per ottenere la NURBS
 
 Punti_C(1:2,:) = Punti_C(1:2,:)./Punti_C(3,:);
 C(1:2,:) = C(1:2,:)./C(3,:);

line(C(1,:), C(2,:), 'LineWidth',2); %con la funzione line viene disegnata la curva
end     





