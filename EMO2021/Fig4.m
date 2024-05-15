function Fig4
% Pareto front estimation of Pareto fronts with different objective value ranges

    N = 153; W = UniformPoint(N,2);
    
    TPF = W ./ repmat(sqrt(sum(W.^2,2)),1,2) .* 1.5;
    Fig(W,TPF(linspace(1,N,5),:),TPF,'4a');
    TPF(:,2) = TPF(:,2) / 3;
    Fig(W,TPF(linspace(1,N,5),:),TPF,'4b');
    TPF(:,2) = TPF(:,2) * 9;
    Fig(W,TPF(linspace(1,N,5),:),TPF,'4c');
end

function Fig(W,P,TPF,name)
    Y = vecnorm(P,1,2); % Output: L1 norm
    X = P./Y;           % Input:  L1 unit vector
    model = dacefit(X(:,1),Y,'regpoly0','corrgauss',1,0.001,1000);
    [Yhat,mse] = predictor(W(:,1),model);
    EPF = W.*Yhat;
    ER = [EPF-W.*sqrt(mse); flip(EPF+W.*sqrt(mse))];
    
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    p1 = fill(ER(:,1), ER(:,2),[.8 .8 .8],'edgecolor','none');
    p0 = plot(TPF(:,1),TPF(:,2),'Color',[0 0.4470 0.7410],'LineWidth',2);
    plot([0,1],[1,0],'--','LineWidth',1,'Color',[.5 .5 .5]);
    p2 = plot(EPF(:,1),EPF(:,2),'k');
    p3 = plot(P(:,1),P(:,2),'ro','MarkerSize',4,'Markerfacecolor','r');
    
    str = {'True Pareto Front','Sample objective vector', ...
        'Estimated Pareto front', 'Estimation range'};
    legend([p0, p3 p2 p1],str,'Box','off');
    xlim([-0.225 4.725]); xlabel('\it f\rm_1');
    ylim([-0.225 4.725]); ylabel('\it f\rm_2');
    xticks(0:0.5:4.5);
    saveimage(name);
end
