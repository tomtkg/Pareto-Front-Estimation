function saveimage(name)
    axis square;
    exportgraphics(gcf,['Data/pdf/',name,'.pdf']);
    savefig(['Data/fig/',name,'.fig']);
    close;
end
