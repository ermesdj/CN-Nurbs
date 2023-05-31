function R = NURBS_R(N,w)
%--------------------------------------------------------------------------
% DESCRIZIONE
%--------------------------------------------------------------------------
% La funzione NURBS_R genera i valori delle funzioni di base
% della NURBS a partire dalle funzioni di base N della B-Spline.
%--------------------------------------------------------------------------
% INPUT
%--------------------------------------------------------------------------
% La funzione ha in input:
%   - Le Funzioni N di base B-Spline
%   - il vettore dei pesi w
%--------------------------------------------------------------------------
% OUTPUT
%--------------------------------------------------------------------------
% La funzione restituisce in output il vettore R bidimensionale contenente 
% le n+1 funzioni di base della NURBS
%--------------------------------------------------------------------------
R = (N.*w)./sum(N.*w);                                                      % Applicazione dell'algoritmo per il calcolo della funzione di base