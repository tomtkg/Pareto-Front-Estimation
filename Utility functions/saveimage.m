function saveimage(name)
    axis square;
    exportgraphics(gcf,['Data/png/',name,'.png']);
    savefig(['Data/fig/',name,'.fig']);
    close;
end
