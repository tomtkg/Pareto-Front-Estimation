function FigD9toD10
% Pareto front estimation in m = 3 objective case
    
    M = 3; W = UniformPoint(20000,M);
    A = UniformPoint(64,M,'ILD');
    
    P = A;
    Fig(W,P,0.86,'D9a');
    
    P = A./repmat(sqrt(sum(A.^2,2)),1,M);
    Fig(W,P,0.86,'D9b');
    
    temp = sum(sqrt(A(:,1:2)),2) + A(:,M);
    P = A./[repmat(temp.^2,1,size(A,2)-1),temp];
    Fig(W,P,0.86,'D9c');
    
    P = A/2; B = P > 0.25;
    P(B) = 3 * P(B) - 0.5;
    Fig(W,P,0.845,'D10b');
    
    P = (A./repmat(sqrt(sum(A.^2,2)-3/4*max(A.^2,[],2)),1,M))/2;
    Fig(W,P,0.845,'D10c');
end

function Fig(W,P,x,name)
    Y = vecnorm(P,1,2); % Output: L1 norm
    X = P./Y;           % Input:  L1 unit vector
    I = ones(1,3);
    model = dacefit(X,Y,'regpoly0','corrgauss',I,0.001*I,1000*I);
    [Yhat,mse] = predictor(W,model);
    A = W.*Yhat; e = sqrt(mse);

    figure('Position',[100 100 550 400],'Visible','on');
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','Box','on','LooseInset',get(gca,'TightInset'), ...
        'View',[135 30]);
    c = colorbar;
    c.Position = [x 0.05 0.04 0.88];
    
    scatter3(A(:,1)-0.005,A(:,2)-0.005,A(:,3)-0.004,4,e,'filled');
    plot3(P(:,1)+0.005,P(:,2)+0.005,P(:,3)+0.004,'ro', ...
        'MarkerSize',4,'Markerfacecolor','r');
    
    xlim([-0.05 1.05]); xlabel('\it f\rm_1','position',[0.4,1.2,-0.15]);
    ylim([-0.05 1.05]); ylabel('\it f\rm_2','position',[1.3 0.3 -0.2]);
    zlim([-0.05 1.05]); zlabel('\it f\rm_3','position',[0.4,-0.77,0.5],'Rotation',0);
    zticks([0 0.5 1]);
    saveimage(name);
end
