%close all
clear
clc 


dataset = "s";
tset = "t";
plotset = "plots/";

dinfo = dir(fullfile(dataset));
dinfo([dinfo.isdir]) = [];
nfiles = length(dinfo);
ts = 1.0E-5;

filename = fullfile(dataset, dinfo(1).name);
cdata = load(filename);
cdata = cdata/max(cdata);
filename = fullfile(tset, dinfo(1).name);
tdata = load(filename);
cv = tdata*ts;


figure
for i = 2:nfiles
    fprintf("Processing %d/%d %s\n", i, nfiles, dinfo(i).name);
    filename = fullfile(dataset, dinfo(i).name);
    data = load(filename);
    filename = fullfile(tset, dinfo(i).name);
    tdata = load(filename);
    v = max(data);
    udata = data/v;
    tv = tdata*ts;
        if mean(data,'omitnan') ~= 0
            plot(cv, cdata)
            xlabel('Time (s)')
            ylabel('Normalized amplitude')
            hold on
            plot(tv, udata,'.','MarkerSize',5)
            hold off
            title(dinfo(i).name(1:end-11), 'interpreter', 'none','FontWeight','Normal')
            legend('clock','stat')
            grid on
            box off 
            xlim([0 max(cv)])
            ylim([0 1.2])
            ax = gca;
            exportgraphics(ax,strcat(plotset,dinfo(i).name,'.png'))
        end
end