%%% EM Algorithm for Variant Calling - Diploid cells %%%
%%% Pol Villalvilla Ornat i Alba Pages Zamora %%%
close all
clear all
%% Loading and creating parameters
% Load matrix F and Q
% file_F_ini = 'F_matrix_9M.csv';
% f_ini = csvread(file_F_ini);
% 
% file_Q_ini = 'Q_matrix_9M.csv';
% Q_ini = csvread(file_Q_ini);

load('F_full.mat');
load('Q_full.mat');
load('index_full.mat');
disp('matrix loaded');
% [f,Q,maxM]=convert_to_full_instances(f_ini,Q_ini);
[f,Q,maxM]=convert_to_full_instances(F_full,Q_full);
disp('matrix converted');
% Define dimensions
K=10;
L=4;
M=7;
N=size(f);
N=N(2);
Niter=50;

M_ind = find(maxM~=0);

% Create matrix S --> to access s_m(l,n)
% Split the 'f' matrix into the different learners (M=7)
s = zeros(L,N,M);
count = 1;
for m=1:M
    for l=1:L
        s(l,:,m)=sum(f(count:count+maxM(m)-1,:)==l);
    end
    count = count + maxM(m);
end
%% Initial values for p and G (p = a priori prob, G = confusion matrix)
% K = [AA, CC, GG, TT, AC, AG, AT, CG, CT, GT]
% A priori probs - array
p=zeros(Niter,K);
p_same = 0.13;
p_different = 0.08;
p(1,:) = [p_same, p_same, p_same, p_same,p_different,p_different,p_different,p_different,p_different,p_different];


% Confusion matrix - tensor
ini_G = 1; % si es 0 inicialitza totes les G(m) iguals, si es = 1 realitzacio aleatoria



if(ini_G == 1)
    G=ones(L,K,M)/L;
   
    % Posar la maxima a la posicio corresponent
    %...AA,CC,GG,TT
    for m=M_ind
        G(:,:,m)=rand(4,10);
        G(:,:,m)=G(:,:,m)./sum(G(:,:,m),1);
        M1=G(:,:,m);
        for l=1:L
            aux=M1(l,l);
            pos_max=find(M1(:,l)==max(M1(:,l)));
            M1(l,l)=max(M1(:,l));
            M1(pos_max,l)=aux;
        end

        %...AC,AG,AT,CG,CT,GT

        % AC: row 1,2 - col5
        sorted=sort(M1(:,5));
        max1=sorted(end);
        max2=sorted(end-1);
        num=(max1+max2)/2;
        aux=M1(1,5);
        pos_max=find(M1(:,5)==max1);
        M1(1,5)=max1;
        M1(pos_max,5)=aux;

        aux=M1(2,5);
        pos_max=find(M1(:,5)==max2);
        M1(2,5)=max2;
        M1(pos_max,5)=aux;

        M1(1,5)=num;
        M1(2,5)=num;


        % AG: row 1,3 - col6
        sorted=sort(M1(:,6));
        max1=sorted(end);
        max2=sorted(end-1);
        num=(max1+max2)/2;
        aux=M1(1,6);
        pos_max=find(M1(:,6)==max1);
        M1(1,6)=max1;
        M1(pos_max,6)=aux;

        aux=M1(3,6);
        pos_max=find(M1(:,6)==max2);
        M1(3,6)=max2;
        M1(pos_max,6)=aux;

        M1(1,6)=num;
        M1(3,6)=num;


        % AT: row 1,4 - col7 --> 
        sorted=sort(M1(:,7));
        max1=sorted(end);
        max2=sorted(end-1);
        num=(max1+max2)/2;
        aux=M1(1,7);
        pos_max=find(M1(:,7)==max1);
        M1(1,7)=max1;
        M1(pos_max,7)=aux;

        aux=M1(4,7);
        pos_max=find(M1(:,7)==max2);
        M1(4,7)=max2;
        M1(pos_max,7)=aux;

        M1(1,7)=num;
        M1(4,7)=num;


        % CG: row 2,3 - col8
        sorted=sort(M1(:,8));
        max1=sorted(end);
        max2=sorted(end-1);
        num=(max1+max2)/2;
        aux=M1(2,8);
        pos_max=find(M1(:,8)==max1);
        M1(2,8)=max1;
        M1(pos_max,8)=aux;

        aux=M1(3,8);
        pos_max=find(M1(:,8)==max2);
        M1(3,8)=max2;
        M1(pos_max,8)=aux;

        M1(2,8)=num;
        M1(3,8)=num;


        % CT: row 2,4 - col9
        sorted=sort(M1(:,9));
        max1=sorted(end);
        max2=sorted(end-1);
        num=(max1+max2)/2;
        aux=M1(2,9);
        pos_max=find(M1(:,9)==max1);
        M1(2,9)=max1;
        M1(pos_max,9)=aux;

        aux=M1(4,9);
        pos_max=find(M1(:,9)==max2);
        M1(4,9)=max2;
        M1(pos_max,9)=aux;

        M1(2,9)=num;
        M1(4,9)=num;


        % GT: row 3,4 - col10
        sorted=sort(M1(:,10));
        max1=sorted(end);
        max2=sorted(end-1);
        num=(max1+max2)/2;
        aux=M1(3,10);
        pos_max=find(M1(:,10)==max1);
        M1(3,10)=max1;
        M1(pos_max,10)=aux;

        aux=M1(4,10);
        pos_max=find(M1(:,10)==max2);
        M1(4,10)=max2;
        M1(pos_max,10)=aux;

        M1(3,10)=num;
        M1(4,10)=num;     

        G(:,:,m)=M1;
    end
    G_ini = G;
else
    p1 = 0.4;
    p2 = 0.2;
    p3 = 0.3;
    Mem = [p2*ones(L,L)+(p1-p2)*eye(L), [p3;p3;p2;p2],[p3;p2;p3;p2],[p3;p2;p2;p3], [p2;p3;p3;p2],[p2;p3;p2;p3],[p2;p2;p3;p3]];
    G_ini=ones(L,K,M).*Mem;
    G=G_ini;
end
    
% Save initial value of G
% save(G,'G'); % ....
disp('ini OK');
alpha=zeros(N,K);
fl=ones(K,M);   % Inicialitzat a 1 per evitar problemes amb learners que no etiqueten
%% Iterations

for i=1:Niter
    
    for n=1:N
        for k=1:K
            % likelihood
            for m=M_ind
                fl(k,m)=prod((G(:,k,m).^s(:,n,m)))*10; % APZ: Multipliquem per 10 per evitar problemes num?rics
                end
        end
        % Calculate alpha (a)
        norm=0;
        fl_vec = prod(fl,2);
        norm = p(i,:)*fl_vec;
        if (norm == 0)
            disp('Ojo'); keyboard;
        end;
        alpha(n,:) = (fl_vec'.*p(i,:))/norm;
                
    end
    
    % Afegir un warning si la suma de alpha(n,:) no es 1 per a tot n.
%     if (sum(alpha(n,:)) ~= 1)
%                 disp('Sum of alpha is not 1 !!!!'); keyboard;
%     end;

    % Calculate G(t+1) and p(t+1) from a(t)
    for m=M_ind
        norm2 = s(:,:,m)*alpha;
        if (all(sum(norm2,1)) == 0)
            disp('Ojo 2'); keyboard;
        end;
        G(:,:,m) = norm2./sum(norm2,1);
    end
    
  
    p(i+1,:) = sum(alpha,1)/N;
    % sum(p) = 1 !! (check) 
%     if (sum(p(i+1,:)) ~= 1)
%                 disp('Sum of p is not 1 !!!!'); keyboard;
%     end;



    % Evaluate Q (convergence)


end
disp('iter done');
%% Once finished calculate y = argmax(a)
class=zeros(N,1);
for i=1:N
    class(i)=find(alpha(i,:)==max(alpha(i,:)));
end

save('test_EM_full');

disp('finished');
