function W = UniformPoint(N,M,method)
    if nargin < 3
        method = 'SLD';
    end
    W = feval(method,N,M);
    W = max(W,1e-6);
end

function W = SLD(N,M) % Simplex-Lattice Design
    H1 = 1;
    while nchoosek(H1+M,M-1) <= N
        H1 = H1 + 1;
    end
    W = nchoosek(1:H1+M-1,M-1) - repmat(0:M-2,nchoosek(H1+M-1,M-1),1) - 1;
    W = ([W,zeros(size(W,1),1)+H1]-[zeros(size(W,1),1),W])/H1;
end

function W = ILD(N,M) % Incremental Lattice Design
    I = M * eye(M);
    W = zeros(1,M);
    edgeW = W;
    while size(W) < N
        edgeW = repmat(edgeW,M,1) + repelem(I,size(edgeW,1),1);
        edgeW = unique(edgeW,'rows');
        edgeW(min(edgeW,[],2)~=0,:) = [];
        W = [W+1;edgeW];
    end
    W = W./sum(W,2);
end

function W = UDH(~,~) % Uniform Design using Hammersley
    W = [
        0.776393202250021 0.111803398874989 0.111803398874989;
        0.612701665379258 0.290473750965556 0.096824583655185;
        0.500000000000000 0.125000000000000 0.375000000000000;
        0.408392021690038 0.517656981021216 0.073950997288745;
        0.329179606750063 0.251557647468726 0.419262745781211;
        0.258380151290434 0.463512405443479 0.278107443266087;
        0.193774225170145 0.100778221853732 0.705447552976123;
        0.133974596215561 0.811898816047911 0.054126587736527;
        0.078045554270711 0.403355070006564 0.518599375722725;
        0.025320565519104 0.670092111205616 0.304587323275280];
end
