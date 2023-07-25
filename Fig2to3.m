function Fig2to3
% Pareto front estimation in m = 2 objective case

    N = 153; W = UniformPoint(N,2); TPF = W;
    
    Fig(W,TPF(linspace(1,N,5),:),TPF,'northeast','2a');
    
    temp = sum(sqrt(W(:,1)),2) + W(:,2);
    TPF = W./[temp.^2 temp];
    Fig(W,TPF(linspace(1,N,5),:),TPF,'northeast','2b');
    Fig(W,TPF(linspace(1,N,20),:),TPF,'northeast','2c');
    
    TPF = W./repmat(sqrt(sum(W.^2,2)),1,2);
    Fig(W,TPF(linspace(1,N,5),:),TPF,'southwest','2d');
    
    TPF = 1 - TPF;
    Fig(W,TPF(linspace(1,N,5),:),TPF,'northeast','2e');
    Fig(W,TPF(linspace(1,N,20),:),TPF,'northeast','2f');
    
    A = W < 0.5;
    TPF(A) = 2/3 * W(A);
    TPF(~A) = 1 - 4/3 * (1 - W(~A));
    Fig(W,TPF(linspace(1,N,9),:),TPF,'northeast','3b');
    
    temp = sqrt(sum(W.^2,2) - 3/4 * max(W.^2,[],2));
    TPF = (W ./ [temp temp]) / 2;
    Fig(W,TPF(linspace(1,N,9),:),TPF,'northeast','3c');
end

function Fig(W,P,TPF,pos,name)
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
    legend([p0, p3 p2 p1],str,'Box','off','Location',pos);
    xlim([-0.05 1.05]); xlabel('\it f\rm_1');
    ylim([-0.05 1.05]); ylabel('\it f\rm_2');
    axis square;
    exportgraphics(gcf,[name,'.pdf']);
    savefig([name,'.fig']); close;
end
