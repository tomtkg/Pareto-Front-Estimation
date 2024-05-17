function FigD1toD2
    FigD1(); % Example of response surface methodology
    
    P = [0 1; 0.2 0.7; 0.809016994 0.587785252; ...
        0.951056516 0.309016994; 1 0]; % Five sample objective vectors
    Y = vecnorm(P,1,2); % Output: L1 norm
    X = P./Y;           % Input:  L1 unit vector
    W = UniformPoint(101,2);
    I = ones(1,2);
    model = dacefit(X,Y,'regpoly0','corrgauss',I,0.001*I,1000*I);
    [Yhat,mse] = predictor(W,model);
    
    FigD2a(P);
    FigD2b(P,X);
    FigD2c(X,Y,Yhat,mse);
    FigD2d(P,Yhat,mse);
end

function FigD1
    X = [0.05 0.25 0.45 0.65 0.95];
    Y = [0.7  0.85 0.8  0.76 0.65];
    
    model = dacefit(X',Y','regpoly0','corrgauss',1,1e-3,1e3);
    x = (0:0.001:1)';
    [y,mse] = predictor(x,model);
    
    set(gca,'Fontname','ＭＳ 明朝','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset', get(gca, 'TightInset'));
    p1 = fill([x;flip(x)], [y+sqrt(mse);flip(y-sqrt(mse))], ...
        [.8 .8 .8],'edgecolor','none');
    
    yline(mean(Y),'--','LineWidth',1,'Alpha',1,'Color',[.5 .5 .5]);
    text(0.93,0.765,'\mu','FontSize',16,'Fontname','Times New Roman',...
        'Color',[.5 .5 .5]);
    for i = 1 : 5
         plot([X(i),X(i)],[0,Y(i)+0.02],':k');
         text(X(i)+0.01,0.625,['\it\bfe^{\rm',num2str(i),'}'], ...
             'FontSize',16,'Fontname','Times New Roman');
    end
    p2 = plot(x,y,'k');
    p3 = plot(X',Y','or','MarkerSize',8,'Markerfacecolor','w');
    
    legend([p3 p2 p1],{'サンプル点','推定値','信用区間'},'Box','off');
    Min = min(y-sqrt(mse)); Max = max(y+sqrt(mse)); D = (Max-Min)/20;
    xlim([0 1]); ylim([Min-D Max+D]);
    xlabel('入力 {\fontname{Times New Roman}\fontsize{16}\it\bfe}');
    ylabel('出力 {\fontname{Times New Roman}\fontsize{16}\itn\rm(\it\bfe\rm)}');
    xticks([]); yticks([]);
    saveimage('D1')
end

function FigD2a(P)
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    plot(P(:,1),P(:,2),'ro','MarkerSize',3,'Markerfacecolor','r');
    
    legend('目的ベクトル','Fontname','ＭＳ 明朝','Box','off');
    xlim([-0.05 1.17]); xlabel('\it f\rm_1');
    ylim([-0.05 1.17]); ylabel('\it f\rm_2');
    saveimage('D2a');
end

function FigD2b(P,X)
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    plot([0,1],[1,0],'--','LineWidth',1,'Color',[.7 .7 .7]);
    plot([P(2,1),X(2,1)],[P(2,2),X(2,2)],'r:','LineWidth',1);
    for i =1:5
        plot([0,P(i,1)],[0,P(i,2)],'r--');
    end
    plot([0,0],[1,0],'b:');
    for i =1:5
        plot([P(i,1),P(i,1)],[0,P(i,2)],'b:');
    end

    p1 = plot(X(:,1),X(:,2),'ro','MarkerSize',6,'Markerfacecolor','w');
    p2 = plot(P(:,1),P(:,2),'ro','MarkerSize',3,'Markerfacecolor','r');
    plot(0,0,'ok','MarkerSize',3,'Markerfacecolor','k');
    
    legend([p2 p1],{'目的ベクトル','単位ベクトル'},'Fontname','ＭＳ 明朝','Box','off');
    xlim([-0.05 1.17]); xlabel('\it f\rm_1');
    ylim([-0.05 1.17]); ylabel('\it f\rm_2');
    saveimage('D2b');
end

function FigD2c(X,Y,Yhat,mse)
    W = (0:0.01:1)'; Lo = Yhat-sqrt(mse); Up = Yhat+sqrt(mse);
    
    set(gca,'Fontname','ＭＳ 明朝','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    p1 = fill([W; flip(W)],[Lo; flip(Up)],[.8 .8 .8],'edgecolor','none');

    plot([0,1],[1,1],'--','LineWidth',1,'Color',[.7 .7 .7]);
    text(0.64,1.03,'\mu','FontSize',16,'Fontname','Times New Roman',...
        'Color',[.3 .3 .3]);
    for i = 1 : 5
         plot([X(i),X(i)],[0,Y(i)+0.05],'--k');
         text(X(i)+0.01,0.86,['\it\bfe^{\rm',num2str(i),'}'], ...
             'FontSize',16,'Fontname','Times New Roman');
    end
    p2 = plot(W,Yhat,'k');
    p3 = plot(X(:,1),Y,'or','MarkerSize',4,'Markerfacecolor','w');
    
    legend([p3 p2 p1],{'目的ベクトル','推定値','信用区間'}, ...
        'Box','off','Location','northwest');
    Min = min(Lo); Max = max(Up); d = (Max-Min)/20;
    xlim([-0.05 1.05]); ylim([Min-d Max+d]);
    xlabel('入力 {\fontname{Times New Roman}\fontsize{16}\it\bfe}');
    ylabel('出力 {\fontname{Times New Roman}\fontsize{16}\itn\rm(\it\bfe\rm)}');
    saveimage('D2c');
end

function FigD2d(P,Yhat,mse)
    W = UniformPoint(101,2); EPF = W.*Yhat;
    ER = [EPF-W.*sqrt(mse); flip(EPF+W.*sqrt(mse))];
    
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    p1 = fill(ER(:,1), ER(:,2),[.8 .8 .8],'edgecolor','none');
    plot([0,1],[1,0],'--','LineWidth',1,'Color',[.7 .7 .7]);
    p2 = plot(EPF(:,1),EPF(:,2),'k');
    p3 = plot(P(:,1),P(:,2),'ro','MarkerSize',3,'Markerfacecolor','r');
    
    legend([p3 p2 p1],{'目的ベクトル','推定値','信用区間'}, ...
        'Fontname','ＭＳ 明朝','Box','off');
    xlim([-0.05 1.17]); xlabel('\it f\rm_1');
    ylim([-0.05 1.17]); ylabel('\it f\rm_2');
    saveimage('D2d');
end