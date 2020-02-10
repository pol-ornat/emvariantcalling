function [fnew,Qnew,maxM] = convert_to_full_instances(f,Q)
%
%   This function converts matrix f into a matritx with instances ordered
%   according to the values of Q groupd into values of group_size
%
%

M=size(f,1);
N=size(f,2);

% Group values of Q matrix into Qmax/group_size groups.
% Q = ceil(Q/group_size);

edges = [0 1 10 20 25 30 35 40 50];
Q = discretize(Q,edges) -1;
% Trobar maxims de cada classe per columna.
% Els valors guardats a maxM em diu quin nombre de individual learners de
% cada classe necessito generar. 
maxGroup = 7;
Mem_max = zeros(N,maxGroup);
for n=1:N
    for m=1:maxGroup
        Mem_max(n,m)=length(find(Q(:,n) == m)); 
    end;
end;
maxM = max(Mem_max);

% Lo seguent sera generar una matriu f extesa amb amb sum(maxM) columnes que afegeixi 0
fnew = zeros(sum(maxM),N);
Qnew = zeros(sum(maxM),N);
pos_ini = 1;
for m=1:maxGroup  
    for n=1:N
        [rows,mem]=find(Q(:,n) == m);
        lmem = length(rows);      
        fnew(pos_ini:pos_ini+lmem-1,n)= f(rows,n);
        Qnew(pos_ini:pos_ini+lmem-1,n)= Q(rows,n);
    end;
    pos_ini = sum(maxM(1:m))+1;
end;
