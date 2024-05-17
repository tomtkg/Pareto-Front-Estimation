function FigD3toD4
% Pareto front estimation in m = 2 objective case

    N = 153; W = UniformPoint(N,2); TPF = W;
    
    Fig(W,TPF(linspace(1,N,5),:),TPF,'northeast','D3a');
    
    temp = sum(sqrt(W(:,1)),2) + W(:,2);
    TPF = W./[temp.^2 temp];
    Fig(W,TPF(linspace(1,N,5),:),TPF,'northeast','D3b');
    Fig(W,TPF(linspace(1,N,20),:),TPF,'northeast','D3c');
    
    TPF = W./repmat(sqrt(sum(W.^2,2)),1,2);
    Fig(W,TPF(linspace(1,N,5),:),TPF,'southwest','D3d');
    
    TPF = 1 - TPF;
    Fig(W,TPF(linspace(1,N,5),:),TPF,'northeast','D3e');
    Fig(W,TPF(linspace(1,N,20),:),TPF,'northeast','D3f');
    
    A = W < 0.5;
    TPF(A) = 2/3 * W(A);
    TPF(~A) = 1 - 4/3 * (1 - W(~A));
    Fig(W,TPF(linspace(1,N,9),:),TPF,'northeast','D4b');
    
    temp = sqrt(sum(W.^2,2) - 3/4 * max(W.^2,[],2));
    TPF = (W ./ [temp temp]) / 2;
    Fig(W,TPF(linspace(1,N,9),:),TPF,'northeast','D4c');
end

function Fig(W,P,TPF,pos,name)
    Y = vecnorm(P,1,2); % Output: L1 norm
    X = P./Y;           % Input:  L1 unit vector
    I = ones(1,2);
    model = dacefit(X,Y,'regpoly0','corrgauss',I,0.001*I,1000*I);
    [Yhat,mse] = predictor(W,model);
    EPF = W.*Yhat;
    ER = [EPF-W.*sqrt(mse); flip(EPF+W.*sqrt(mse))];
    
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    p1 = fill(ER(:,1), ER(:,2),[.8 .8 .8],'edgecolor','none');
    p2 = plot(TPF(:,1),TPF(:,2),'Color',[0 0.4470 0.7410],'LineWidth',1);
    p3 = plot(EPF(:,1),EPF(:,2),'k','LineWidth',1.5);
    p4 = plot(P(:,1),P(:,2),'ro','MarkerSize',4,'Markerfacecolor','r');
    
    str = {'真のパレートフロント','目的ベクトル','推定パレートフロント','信用区間'};
    legend([p2, p4 p3 p1],str,'FontName','ＭＳ 明朝','Box','off','Location',pos);
    xlim([-0.05 1.05]); xlabel('\it f\rm_1');
    ylim([-0.05 1.05]); ylabel('\it f\rm_2');
    saveimage(name);
end
