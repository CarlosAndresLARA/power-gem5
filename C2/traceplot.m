%close all
clear
clc

dataset = "0x7e";
plotset = "0x7e_plot/";

dinfo = dir(fullfile(dataset));
dinfo([dinfo.isdir]) = [];
nfiles = length(dinfo);
ts = 4.0E-7;

for i = 1:nfiles
    fprintf("Processing %d/%d %s\n", i, nfiles, dinfo(i).name);
    filename = fullfile(dataset, dinfo(i).name);
    data = load(filename);

    [~, traces] = size(data);
    lengths = zeros(1,traces);
    for j = 1:traces
        trace = data(:,j);
        trace(isnan(trace)) = [];
        lengths(j) = length(trace);
    end

    m = mean(lengths);
    s = std(lengths);
    uthr = m+s;
    lthr = m-s;
    fprintf("Thresholds are %d and %d !\n", round(lthr), round(uthr))
    if m ~= 0
        g = 0;
        for j = 1:traces
            if (lengths(j) > lthr) && (lengths(j) < uthr)
                plot(data(:,j))
                hold on
                g = g + 1;
            end
        end
        hold off
        title(dinfo(i).name(1:end-4), 'interpreter', 'none','FontWeight','Normal')
        grid on
        box off 
        xlim([0 m])
        ylim([0 max(max(data))*1.05])
        xlabel('Samples (n)')
        ylabel('Amplitude')
        axis square
        ax = gca;
        exportgraphics(ax,strcat(plotset,dinfo(i).name,'.png'))
        fprintf("%d/%d traces added to the plot !\n\n", g,traces);
    else
        fprintf("Anomaly, skipping !\n")
    end
end
