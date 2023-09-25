function Fig1
% Example of the proposed Pareto front estimation procedure

    P = [0 1; 0.2 0.7; 0.809016994 0.587785252; ...
        0.951056516 0.309016994; 1 0]; % Five sample objective vectors
    Y = vecnorm(P,1,2); % Output: L1 norm
    X = P./Y;           % Input:  L1 unit vector
    model = dacefit(X(:,1),Y,'regpoly0','corrgauss',1,0.001,1000);
    [Yhat,mse] = predictor((0:0.01:1)',model);
    
    Fig1a(P,X);
    Fig1b(X,Y,Yhat,mse);
    Fig1c(P,Yhat,mse);
end

function Fig1a(P,X)
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    plot([0,1],[1,0],'--','LineWidth',1,'Color',[.7 .7 .7]);
    plot([P(2,1),X(2,1)],[P(2,2),X(2,2)],'r:','LineWidth',1);
    for i =1:5
        plot([0,P(i,1)],[0,P(i,2)],'--','Color','r');
    end
    p1 = plot(X(:,1),X(:,2),'ro','MarkerSize',6,'Markerfacecolor','w');
    p2 = plot(P(:,1),P(:,2),'ro','MarkerSize',3,'Markerfacecolor','r');
    plot(0,0,'ok','MarkerSize',3,'Markerfacecolor','k');
    
    legend([p2 p1],{'Sample objective vector','Unit vector'},'Box','off');
    text(-0.035,-0.015,'\bfz','FontSize',12);
    xlim([-0.05 1.17]); xlabel('\it f\rm_1');
    ylim([-0.05 1.17]); ylabel('\it f\rm_2');
    axis square;
    exportgraphics(gcf,'1a.pdf');
    savefig('1a.fig'); close;
end

function Fig1b(X,Y,Yhat,mse)
    W = (0:0.01:1)'; Lo = Yhat-sqrt(mse); Up = Yhat+sqrt(mse);
    
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    p1 = fill([W; flip(W)],[Lo; flip(Up)],[.8 .8 .8],'edgecolor','none');
    plot([0,1],[1,1],'--','LineWidth',1,'Color',[.7 .7 .7]);
    p2 = plot(W,Yhat,'k');
    p3 = plot(X(:,1),Y,'or','MarkerSize',4,'Markerfacecolor','w');
    
    legend([p3 p2 p1],{'(i)   Sample point','(ii)  Kriging interpolation', ...
        '(iii) Confidence intervals'},'Box','off','Location','southeast');
    Min = min(Lo); Max = max(Up); d = (Max-Min)/20;
    xlim([-0.05 1.05]); ylim([Min-d Max+d]);
    xlabel('\it L\rm^1 unit vector element: \ite\rm_1');
    ylabel('\it L\rm^1 norm: ||\bf\itf\rm||');
    axis square;
    exportgraphics(gcf,'1b.pdf');
    savefig('1b.fig'); close;
end

function Fig1c(P,Yhat,mse)
    W = UniformPoint(101,2); EPF = W.*Yhat;
    ER = [EPF-W.*sqrt(mse); flip(EPF+W.*sqrt(mse))];
    
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    p1 = fill(ER(:,1), ER(:,2),[.8 .8 .8],'edgecolor','none');
    plot([0,1],[1,0],'--','LineWidth',1,'Color',[.7 .7 .7]);
    p2 = plot(EPF(:,1),EPF(:,2),'k');
    p3 = plot(P(:,1),P(:,2),'ro','MarkerSize',3,'Markerfacecolor','r');
    
    str = {'(i)   Sample objective vector', ...
        '(ii)  Estimated Pareto front', ...
        '(iii) Estimation range'};
    legend([p3 p2 p1],str,'Box','off');
    xlim([-0.05 1.17]); xlabel('\it f\rm_1');
    ylim([-0.05 1.17]); ylabel('\it f\rm_2');
    axis square;
    exportgraphics(gcf,'1c.pdf');
    savefig('1c.fig'); close;
end
