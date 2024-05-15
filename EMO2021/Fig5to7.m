function Fig5to7
% Pareto front estimation with three objective vector samplers

    M = 3; W = UniformPoint(20000,M);
    for method = ["SLD","ILD","UDH"]
        P = UniformPoint(10,M,method);
        P = P ./ repmat(sqrt(sum(P.^2,2)),1,M);
        Y = vecnorm(P,1,2); % Output: L1 norm
        X = P./Y;           % Input:  L1 unit vector
        
        model = dacefit(X(:,1:2),Y,'regpoly0','corrgauss', ...
            [1 1], [0.001 0.001], [1000 1000]);
        [Yhat,mse] = predictor(W(:,1:2),model);
        e = sqrt(mse);
        
        Fig5(P,W.*Yhat,e,method);
        Fig6(X(:,1:2),W(:,1:2),Yhat,method);
        Fig7(X(:,1:2),W(:,1:2),e,method);

        fprintf('%s:',method);
        disp([model.theta mean(Y) min(Yhat) max(Yhat) mean(e) max(e)]);
    end
end

function Fig5(P,A,e,name)
% Pareto front estimation with three objective vector samplers (objective space)

    figure('Position',[100 100 550 400],'Visible','on');
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'), ...
        'View',[135 30]);
    c = colorbar; clim([0 0.16]);
    c.Label.String = 'Estimation error';
    c.Position = [0.86 0.05 0.04 0.88];
    
    scatter3(A(:,1)-0.005,A(:,2)-0.005,A(:,3)-0.004,4,e,'filled');
    p = plot3(P(:,1)+0.005,P(:,2)+0.005,P(:,3)+0.004, ...
        'ro','MarkerSize',4,'Markerfacecolor','r');
    pos = [0.53 0.93 0.360714277678303 0.054761903413704];
    legend(p,'Sample objective vector','Box','off','Position',pos);
    
    xlim([0 1.3]); xlabel('\it f\rm_1','position',[0.3 1.3 -0.2]);
    ylim([0 1.3]); ylabel('\it f\rm_2','position',[1.3 0.3 -0.2]);
    zlim([0 1.3]); zlabel('\it f\rm_3','position',[0.5 -0.9 0.55],'Rotation',0);
    zticks([0 0.5 1]);
    saveimage(char('5'+name));
end

function Fig6(X,W,Yhat,name)
% Estimated L1 norm ||^f|| with three objective vector samplers (model space)

    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    c = colorbar; clim([1 1.75]);
    c.Label.String = '\it L\rm^1 norm: ||\bf\itf\rm||';
    
    scatter(W(:,1),W(:,2),4,Yhat,'filled');
    p = plot(X(:,1),X(:,2),'ro','MarkerSize',4,'Markerfacecolor','r');
    legend(p,'Sample objective vector','Box','off');
    
    xlim([0 1]); xlabel('\it L\rm^1 unit vector element: \ite\rm_1'); 
    ylim([0 1]); ylabel('\it L\rm^1 unit vector element: \ite\rm_2');
    saveimage(char('6'+name));
end

function Fig7(X,W,e,name)
% Estimated error with three objective vector samplers (model space)

    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'));
    c = colorbar; clim([0 0.16]);
    c.Label.String = 'Estimation error';
    
    scatter(W(:,1),W(:,2),4,e,'filled');
    p = plot(X(:,1),X(:,2),'ro','MarkerSize',4,'Markerfacecolor','r');
    legend(p,'Sample objective vector','Box','off');
    
    xlim([0 1]); xlabel('\it L\rm^1 unit vector element: \ite\rm_1');
    ylim([0 1]); ylabel('\it L\rm^1 unit vector element: \ite\rm_2');
    saveimage(char('7'+name));
end
