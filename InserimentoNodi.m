function [Pk_new]=InserimentoNodi(Pk,h,k,mol,z,p_c,t)
%--------------------------------------------------------------------------
% DESCRIZIONE FUNZIONE
%--------------------------------------------------------------------------
% La funzione permette di inserire un nodo all'interno del
% vettore di nodi t senza che venga alterata la forma della curva tramite 
% l'algoritmo di Knot Insertion.
%--------------------------------------------------------------------------
% INPUT
%--------------------------------------------------------------------------
% La funzione ha in input:
%   - la matrice Pk contenente le coordinate dei punti di controllo;
%   - il grado h della curva;
%   - l'indice k che indica l'intervallo in cui inserire il nodo;
%   - la molteplicità mol del nodo da inserire;
%   - un indice z per gestire il numero di iterazioni;
%   - il nodo da inserire p_c;
%   - il vettore dei nodi t;
%--------------------------------------------------------------------------
% OUTPUT
%--------------------------------------------------------------------------
% La funzione restituisce in output:
% La matrice contente le coordinate dei nuovi punti di controllo Punti_C
%--------------------------------------------------------------------------

b = k-1;                                                                   %variabile ausiliaria
for i = (b-h+z) : (b-mol)
    a(i+1,z+1) = (p_c-t(i+1)) / (t(i+h-z+1+1)-t(i+1));                     % calcolo dei coefficienti
    Pk(:,i+1,z+1) = (1-a(i+1,z+1)) * Pk(:,i,z) + a(i+1,z+1) * Pk(:,i+1,z); % calcolo dei punti di controllo 
end
    Pk_new=Pk;
end