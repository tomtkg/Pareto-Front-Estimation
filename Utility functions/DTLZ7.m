function DTLZ7
    Fig3a();
    Fig9a();
end

function P = Get(N,M)
    X = linspace(0,1,N)';
    if M == 3
        X = [repelem(X,N,1) repmat(X,N,1)];
    end
    a = [0 0.251412 0.631627 0.859401];
    b = a(2) / (a(4)-a(3)+a(2));
    X(X<=b) = X(X<=b) * (a(2)-a(1)) / b;
    X(X>b)  = (X(X>b)-b) * (a(4)-a(3)) / (1-b) + a(3);
    P = normalize([X,2*(M-sum(X/2.*(1+sin(3*pi.*X)),2))],'range');
end

function Fig3a()
    W = UniformPoint(200,2);
    TPF = Get(200,2);
    x = [0;0.083;0.166;0.251412;0.631627;0.7;0.745;0.79;0.859401];
    P = normalize([x,2*(2-sum(x/2.*(1+sin(3*pi.*x)),2))],'range');
    
    Y = vecnorm(P,1,2); % Output: L1 norm
    X = P./Y;           % Input:  L1 unit vector
    model = dacefit(X(:,1),Y,'regpoly0','corrgauss',1,0.001,1000);
    [Yhat,mse] = predictor(W(:,1),model);
    EPF = W.*Yhat;
    ER = [EPF-W.*sqrt(mse); flip(EPF+W.*sqrt(mse))];

    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    p1 = fill(ER(:,1), ER(:,2),[.8 .8 .8],'edgecolor','none');
    p0 = plot(TPF(1:105,1),TPF(1:105,2),'Color',[0 0.4470 0.7410], 'LineWidth',2); 
    plot(TPF(106:end,1),TPF(106:end,2),'Color', [0 0.4470 0.7410], 'LineWidth',2);
    plot([0,1],[1,0],'--','LineWidth',1,'Color',[.5 .5 .5]);
    p2 = plot(EPF(:,1),EPF(:,2),'k');
    p3 = plot(P(:,1),P(:,2),'ro','MarkerSize',4,'Markerfacecolor','r');
    
    str = {'True Pareto Front','Sample objective vector', ...
        'Estimated Pareto front', 'Estimation range'};
    legend([p0, p3 p2 p1],str,'Box','off','Location','southwest');
    xlim([-0.05 1.05]); xlabel('\it f\rm_1');
    ylim([-0.05 1.05]); ylabel('\it f\rm_2');
    saveimage('3a');
end

function Fig9a()
    W = UniformPoint(20000,3); P = Get(8,3);
    Y = vecnorm(P,1,2); % Output: L1 norm
    X = P./Y;           % Input:  L1 unit vector
    model = dacefit(X(:,1:2),Y,'regpoly0','corrgauss', ...
        [1 1], [0.001 0.001], [1000 1000]);
    [Yhat,mse] = predictor(W(:,1:2),model);
    A = W.*Yhat; e = sqrt(mse);

    figure('Position',[100 100 550 400],'Visible','on');
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'), ...
        'View',[135 30]);
    c = colorbar;
    c.Label.String = 'Estimation error';
    c.Position = [0.86 0.05 0.04 0.88];
    
    scatter3(A(:,1)-0.005,A(:,2)-0.005,A(:,3)-0.004,4,e,'filled');
    p = plot3(P(:,1)+0.005,P(:,2)+0.005,P(:,3)+0.004, ...
        'ro','MarkerSize',4,'Markerfacecolor','r');
    pos = [0.53 0.93 0.360714277678303 0.054761903413704];
    legend(p,'Sample objective vector','Box','off','Position',pos);
    
    xlim([-0.1 1.63]); xlabel('\it f\rm_1','position',[0.35 1.4 -0.27]);
    ylim([-0.1 1.63]); ylabel('\it f\rm_2','position',[1.4 0.35 -0.27]);
    zlim([-0.05 1.05]); zlabel('\it f\rm_3','position',[0.65 -1.2 0.54],'Rotation',0);
    zticks([0 0.5 1]);
    saveimage('9a');
end
