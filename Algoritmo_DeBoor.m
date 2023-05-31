function [C]=Algoritmo_DeBoor(Punti_C,Punti_Calcolo,num_nodi,t,h)
%--------------------------------------------------------------------------
% DESCRIZIONE
%--------------------------------------------------------------------------
% L'algoritmo è utilizzato come alternativa più rapida per il calcolo delle
% B-Spline e delle NURBS.
% L’idea alla base dell’algoritmo è quella di andare ad inserire più volte 
% uno stesso nodo u per fare in modo che la sua molteplicità raggiunga il 
% valore h, ovvero il grado della curva.
% L'algoritmo fa uso dell' algoritmo di knot insertion per inserire
% ripetutamente il nodo all'interno di un vettore.
% Supponendo che il nodo da inserire sia contenuto in [uk, uk+1),i punti 
% di controllo che lo influenzano sono h − mol + 1, e in particolare vanno 
% da Pk−h a Pk−mol mentre i punti calcolati nell’iterazione della 
% Knot Insertion sono h − mol, diminuendo quindi di 1 a causa dell’aumento 
% di molteplicità di u.
% L’algoritmo termina quindi quando avremo un solo punto di controllo
% risultante, che è proprio il punto per il quale passa la curva.
%--------------------------------------------------------------------------
% INPUT
%--------------------------------------------------------------------------
% L'algoritmo prende in input:
%   - La matrice Punti_C dei punti di controllo
%   - Il linespace equidistanziato Punti_Calcolo dei punti di calcolo
%   - Il numero di nodi num_nodi
%   - Il vettore dei nodi t
%   - Il grado della funzione h
%--------------------------------------------------------------------------
% OUTPUT
%--------------------------------------------------------------------------
% L'algoritmo restituisce in uscita la matrice di punti C in cui passerà il
% grafico.
%--------------------------------------------------------------------------

m = size(Punti_C,1);
Pk = zeros(m, num_nodi, num_nodi);%Pk contiene un numero di matrici pari all'ordine della curva.

% 2 righe, n colonne, n dimensioni

a = zeros(num_nodi, num_nodi);     %a è una matrice NXN che contiene i coefficienti dei punti.

 for i=1: size(Punti_Calcolo,2)                                            %Algoritmo da seguire per ogni punto di calcolo per plottare la B-spline
     
     a(:)=0; 
     Pk(:)=0; 
     p_c= Punti_Calcolo(i); 
     mol=0;
     
%Calcolo della molteplicità dei punti di calcolo:                          %sereve a determinare numero di Knot Insertion che devono essere effettuate.

     for j=1: size(t,2)                                                    %per ogni punto di calcolo effettua un confonto con tutti i nodi del vettore t
         if p_c==t(j)                                                      %se riscontra una corrispondenza con un nodo 
             mol=mol+1;                                                    %incrementa la molteplicità del punto di calcolo
         end
     end
    
     %{
     Adesso è necessario calcolare i'intervallo giusto in cui andare ad
     inserire il punto di valutazione.
     Si calcola quindi i'indice k: u € [tk, tk+1]
     %}
     
     [~,k]=histc(p_c,t);                                              %La funzione histcounts permette di calcolare i'intervallo del vettore dei
                                                                           %nodi in cui andare ad inserire il punto p_c. Visto che a noi interessa solo il
                                                                           %secondo valore restituito dalla funzione, inseriamo una ~ per ignorare il primo.
     num_inserimenti= h-mol;                                               %La il punto di controllo viene inserito tante volte quanto la differenta tra il 
                                                                           %grado della curva e la molteplicità del punto
     
    
     %{
     A causa della proprietà del controllo locale, i punti di controllo che
     vengono influenzati dall'algoritmo non sono tutti, ma in generale sono
     k-p (indice dell'intervallo - il grado della curva). Considerando
     anche la molteplicità del punto di valutazione che stiamo inserendo, i
     punti di controllo influenzati sono quelli che vanno da k-p fino a
     k-s.
    %}
      
     Pk(:,(k-h):(k-mol),1) = Punti_C(:,(k-h):(k-mol));
     
     %{
     Se num_inserimenti >0, allora vi saranno inserimenti da effettuare.
     Altrimenti si procede secondo due operazioni diverse possibili:
     1)il nodo va inserito nell'ultimo intervallo;
     2)la molteplicità del nodo è già pari al grado della curva e quindi
     già ne conosciamo il valore.
     %}
                                                        
     if num_inserimenti>0                 
            for z=1:num_inserimenti
              Pk=InserimentoNodi(Pk,h,k,mol,z,p_c,t);
            end
            C(:,i) = Pk(:,k-mol,h-mol+1);                                  %il punto viene inserito nel vettore da plottare
    
     elseif  k==size(t,2)
       
         C(:,i) = Punti_C(:,end);
    
     else
        C(:,i) = Punti_C(:,k-h);
     
     end
     C;
 end
  C;
end

