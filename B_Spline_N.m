function N = B_Spline_N(h,k,num_p)
%--------------------------------------------------------------------------
% DESCRIZIONE
%--------------------------------------------------------------------------
% La funzione B_Spline calcola i valori delle funzioni di base a partire 
% dal vettore dei nodi. 
%--------------------------------------------------------------------------
% INPUT
%--------------------------------------------------------------------------
% La funzione ha in input:
%       h: grado della curva
%       k: vettore dei nodi
%       num_p: intero, numero dei punti di controllo
%--------------------------------------------------------------------------
% OUTPUT
%--------------------------------------------------------------------------
% La funzione restituisce:
%       N: vettore bidimensionale contenente le size(k) funzioni di base
%--------------------------------------------------------------------------
% DATI UTILIZZATI PER IL TESTING
%--------------------------------------------------------------------------
%h=3;
%k=[0,0,0.25,0.32,0.5,0.81,1];
%num_p=3;
%--------------------------------------------------------------------------


Z= linspace( k(1), k(end), 10*num_p);                                      % vettore di punti in cui viene calcolata la curva

% N deve avere dimensione (size(Z),num_p), per ottenere la dimensione del 
% linespace, si utilizza la funzione size che restituisce numero di righe e
% colonne di Z, essendo Z un vettore avrà 1 riga e 10*num_p colonne.
% quindi size(Z)= [1 10*num_p], stessa cosa per le dimensioni di k.

N=zeros(size(Z,2),num_p);                                                  % Inizzializzazione del vettore bidimensionale che contiene le funzioni di base
N_h=zeros(size(Z,2),size(k,2));                                            % Matrice di supporto al calcolo delle funzioni di base.

%Formula di ricorsione di Cox-De Boor

for i=1:size(Z,2)                                                          
    z = Z(i);                                                              % z è uno dei punti in cui viene calcolata la curva.
    
%   Funzioni di base grado 0
    for j=1:size(k,2)-1                                                    % ripete il ciclo per tutti i numeri di nodi-1 poichè l'ultimo nodo non avrà un valore successivo su cui costruire un intervallo 
        if z>=k(j)&&z<k(j+1)                                               % se il punto del linespace è maggiore del j-esimo nodo e minore del j+1esimo
            N_h(i,j) = 1;                                                  % setta il valore ad 1 nella jesima colonna della matrice di supporto
        else
            N_h(i,j) = 0;                                                  % altrimenti lo setta a 0
        end
    end

    
%   Funzioni di base di grado successivo
    for t=2:h                                                              %iterazione per i gradi successivi
        for j=1:size(k,2)-t                                                
            if N_h(i,j)==0
                add1 = 0;
            else
                add1 = (((z-k(j))/(k(j+t-1)-k(j)))*N_h(i,j));
            end
            if N_h(i,j+1)==0
                add2 = 0;
            else
                add2 =(((k(j+t)-z)/(k(j+t)-k(j+1)))* N_h(i,j+1));
            end
            N_h(i,j)=add1+add2;
        end
    end
            
end

N = N_h(:,1:num_p);

