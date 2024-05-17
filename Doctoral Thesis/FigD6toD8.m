function FigD6toD8
% Pareto front estimation with three objective vector samplers

    M = 3; W = UniformPoint(20000,M);
    for method = ["SLD","ILD","UDH"]
        P = UniformPoint(10,M,method);
        P = P ./ repmat(sqrt(sum(P.^2,2)),1,M);
        Y = vecnorm(P,1,2); % Output: L1 norm
        X = P./Y;           % Input:  L1 unit vector
        I = ones(1,3);
        model = dacefit(X,Y,'regpoly0','corrgauss',I,0.001*I,1000*I);
        [Yhat,mse] = predictor(W,model);
        e = sqrt(mse);
        
        A = [0 0; sqrt(2) 0; sqrt(1/2) sqrt(3/2)];
        FigD6(P,W.*Yhat,e,method);
        Fig6(X*A,W*A,Yhat,method);
        Fig7(X*A,W*A,e,method);
        
        t = W./repmat(sqrt(sum(W.^2,2)),1,3);
        err = abs(vecnorm(t,1,2)-Yhat);
        fprintf('%s:',method);
        disp([min(Y) mean(Y) max(Y) model.Ysc(2) model.theta ]);
        disp([min(Yhat) mean(Yhat) max(Yhat) mean(e) max(e) mean(err) max(err)]);
    end
end

function FigD6(P,A,e,name)
% Pareto front estimation with three objective vector samplers (objective space)

    figure('Position',[100 100 550 400],'Visible','on');
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'), ...
        'View',[135 30]);
    
    c = colorbar;
    c.Position = [0.86,0.04,0.038095238095238,0.88];
    scatter3(A(:,1)-0.005,A(:,2)-0.005,A(:,3)-0.004,4,e,'filled');
    plot3(P(:,1)+0.005,P(:,2)+0.005,P(:,3)+0.004,'ro', ...
        'MarkerSize',4,'Markerfacecolor','r');

    xlim([-0.06,1.1]);  xlabel('\it f\rm_1','position',[0.4,1.2,-0.15]);
    ylim([-0.06,1.1]);  ylabel('\it f\rm_2','position',[1.2,0.4,-0.15]);
    zlim([-0.05,1.15]); zlabel('\it f\rm_3','position',[0.4,-0.83,0.54],'Rotation',0);
    zticks([0 0.5 1]);
    saveimage(char('D6'+name));
end

function Fig6(X,W,Yhat,name)
% Estimated L1 norm ||^f|| with three objective vector samplers (model space)
    
    triangleplt();
    scatter(W(:,1),W(:,2),4,Yhat,'filled');
    plot(X(:,1),X(:,2),'ro','MarkerSize',8,'Markerfacecolor','r');
    saveimage(char('D7'+name));
end

function Fig7(X,W,e,name)
% Estimated error with three objective vector samplers (model space)

    triangleplt();
    scatter(W(:,1),W(:,2),4,e,'filled');
    plot(X(:,1),X(:,2),'ro','MarkerSize',8,'Markerfacecolor','r');
    saveimage(char('D8'+name));
end
