close all
clear
clc

dataset = "../C1/0x7e";
dataout = "0x7e";

freq = load(dataset + "/system.cpu_cluster.clk_domain.clock.csv");

d = freq > 2e4;
n = length(freq);
traces = zeros(2,2);
tix = 1;

for i = 2:n
    if d(i-1) == 0 && d(i) == 1
        traces(tix, 1) = i;
    end
    if d(i-1) == 1 && d(i) == 0
        traces(tix, 2) = i;
        tix = tix + 1;
    end
end

s = max(traces(:,2) - traces(:,1));

dinfo = dir(fullfile(dataset));
dinfo([dinfo.isdir]) = [];
nfiles = length(dinfo);
for j = 1 : length(dinfo)

  disp(j)

  filename = fullfile(dataset, dinfo(j).name);

  data = load(filename);
  
  if length(data) >= n

      if length(data) > n
          disp("This file is larger! " + filename)
      end

      data_cut = nan(s, tix - 1);
    
      for t = 1:tix-1
        lix = traces(t,1);
        hix = traces(t,2);
        ns = hix - lix;
        data_cut(1:ns,t) = data(lix:hix-1);
      end

      m = mean(mean(data_cut,'omitnan'),'omitnan');
    
      if m ~= 0
          filename = fullfile(dataout, dinfo(j).name);
          writematrix(data_cut, filename);
      else
          disp('Yo thats full zeros...')
      end
  else

      disp("Skipping, too short... ")

  end

end