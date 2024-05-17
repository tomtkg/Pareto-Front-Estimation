function FigD5
% Pareto front estimation of Pareto fronts with different objective value ranges

    N = 153; W = UniformPoint(N,2);
    
    TPF = W ./ repmat(sqrt(sum(W.^2,2)),1,2) .* 1.5;
    Fig(W,TPF(linspace(1,N,5),:),TPF,'D5a');
    TPF(:,2) = TPF(:,2) / 3;
    Fig(W,TPF(linspace(1,N,5),:),TPF,'D5b');
    TPF(:,2) = TPF(:,2) * 9;
    Fig(W,TPF(linspace(1,N,5),:),TPF,'D5c');
end

function Fig(W,P,TPF,name)
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
    legend([p2, p4 p3 p1],str,'FontName','ＭＳ 明朝','Box','off');
    xlim([-0.225 4.725]); xlabel('\it f\rm_1');
    ylim([-0.225 4.725]); ylabel('\it f\rm_2');
    xticks(0:0.5:4.5);
    saveimage(name);
end
