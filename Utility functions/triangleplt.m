function triangleplt(label)
    if nargin == 0
        label = ["\it e\rm_1","\it e\rm_2","\it e\rm_3"];
    end
    figure('Position',[100 100 550 500],'Visible','on');
    set(gca,'Fontname','Times New Roman','FontSize',13,'NextPlot','add', ...
        'Color','none','LooseInset',get(gca, 'TightInset'));
    axis square; axis off;
    
    A = [0 0; sqrt(2) 0; sqrt(1/2) sqrt(3/2)];
    W = nchoosek(1:6,2) - 1; W(:,2) = W(:,2)-1;
    W = ([W,zeros(15,1)+4] - [zeros(15,1),W]) / 4;
    
    d = A/20; d = [d(2,1) 0; -d(3,1) d(3,2); -d(3,1) -d(3,2);];
    s = ["0.0","0.25","0.5","0.75","1.0"];
    lr =["left","right","left"];
    t = [0.01 0.03; -0.04 0.03; 0 -0.04];
    l = [0.25,0.75; 0.63,-0.1; 1.15,0.62];
    
    for j = 1 : 3
        W2 = W(W(:,j)==0,:); s = flip(s);
        for i = 1 : 5
            p = W2(i,:)*A;
            plot([p(1); p(1)+d(j,1)],[p(2);p(2)+d(j,2)],'Color',[.7 .7 .7]);
            text(p(1)+t(j,1),p(2)+t(j,2),s(i),'FontName','Times New Roman',...
                'FontSize',11.7,'HorizontalAlignment',lr(j));
        end
        text(l(j,1),l(j,2),label(j),'FontName','Times New Roman',...
                'FontSize',14);
    end
    triplot(delaunayTriangulation(W*A),'k:');
    plot([A(:,1);0],[A(:,2);0],'k','LineWidth',1);
    colorbar('Position', [0.88,0.25,0.04,0.6]);
end
