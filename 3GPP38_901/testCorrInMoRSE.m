clear all;

M = 6;
Num_grids = 3;
Num_DoAs = 100000;

grid_length = 100;


LSP_seeds = randn(M,Num_grids,Num_DoAs);
correlation_distance = [40;50;50;50;50;50];
%correlation_distance = [10;11;17;7;25;25];
%correlation_distance = [1;1;1;1;1;1];

for DoA_i = 2:Num_DoAs
    for m = 1:M
        theFactor = exp(-1*(pi/36*grid_length)/correlation_distance(m));
        LSP_seeds(m,1,DoA_i) = (1-theFactor)*LSP_seeds(m,1,DoA_i) + theFactor*LSP_seeds(m,1,DoA_i-1);
    end
end
for k = 2:Num_grids
    for m = 1:M
        theFactor = exp(-1*grid_length/correlation_distance(m));
        LSP_seeds(m,k,1) = (1-theFactor)*LSP_seeds(m,k,1) + theFactor*LSP_seeds(m,k-1,1);
    end
end
Filtered_seeds =LSP_seeds;
for DoA_i =1:Num_DoAs
    if DoA_i >1
        for m = 1: M
            for k = 1: Num_grids
                if k >1
                    theFactor_1 = exp(-1*(pi/36*k*grid_length)/correlation_distance(m));
                    theFactor_2 = exp(-1*grid_length/correlation_distance(m));
                    Filtered_seeds(m,k,DoA_i) = theFactor_1*LSP_seeds(m,k,DoA_i-1)+...
                (1-theFactor_1)*(theFactor_2*LSP_seeds(m,k-1,DoA_i)+(1-theFactor_2)*LSP_seeds(m,k,DoA_i));
%                     Filtered_seeds(m,k,DoA_i) =  1/(1+exp(-1*grid_length/correlation_distance(m))+exp(-1*(pi/36*k*grid_length)/correlation_distance(m)))*LSP_seeds(m,k,DoA_i)+...
%                     exp(-1*grid_length/correlation_distance(m))/(1+exp(-1*grid_length/correlation_distance(m))+exp(-1*(pi/36*k*grid_length)/correlation_distance(m)))*LSP_seeds(m,k-1,DoA_i)+...
%                     exp(-1*(pi/36*k*grid_length)/correlation_distance(m))/(1+exp(-1*grid_length/correlation_distance(m))+exp(-1*(pi/36*k*grid_length)/correlation_distance(m)))*LSP_seeds(m,k,DoA_i-1);
                end
            end
        end
    end
end

% Distribution
figure(1); hold on; grid on;
histfit(reshape(Filtered_seeds, 1, []), 100);

figure(2); hold on; grid on;
histfit(reshape(LSP_seeds, 1, []), 100);

% Auto-correlation

