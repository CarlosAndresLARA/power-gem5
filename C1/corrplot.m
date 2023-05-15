%close all
clear
clc

dataset1 = '0x2b';
dataset2 = '0x7e';

ntraces = 10;

dinfo = dir(dataset1);
dinfo([dinfo.isdir]) = [];
nfiles1 = length(dinfo);

filename = fullfile(dataset1, dinfo(1).name);
data = load(filename);
nsamples1 = length(data);

mdata1 = zeros(ntraces,nsamples1);
mdata1(1,:) = data;
gfiles1 = 1;

for i = 2:50

  fprintf("Processing file %d : %s\n",i,dinfo(i).name);

  filename = fullfile(dataset1, dinfo(i).name);

  data = load(filename);

  if length(data) ~= nsamples1
      disp('Skipping, too short !')
  else 
      %data(isnan(data)) = 0;
      if mean(data,'omitnan') == 0
          disp('Skipping, all zeros !')
      else
          disp('Good file!')
          gfiles1 = gfiles1 + 1;
          mdata1(gfiles1,:) = data;
      end
  end

end  

dinfo = dir(dataset2);
dinfo([dinfo.isdir]) = [];
nfiles2 = length(dinfo);

filename = fullfile(dataset2, dinfo(1).name);
data = load(filename);
nsamples2 = length(data);

mdata2 = zeros(ntraces,nsamples2);
mdata2(1,:) = data;
gfiles2 = 1;

for i = 2:50

  fprintf("Processing file %d : %s\n",i,dinfo(i).name);

  filename = fullfile(dataset2, dinfo(i).name);

  data = load(filename);

  if length(data) ~= nsamples2
      disp('Skipping, too short !')
  else 
      %data(isnan(data)) = 0;
      if mean(data,'omitnan') == 0
          disp('Skipping, all zeros !')
      else
          disp('Good file!')
          gfiles2 = gfiles2 + 1;
          mdata2(gfiles2,:) = data;
      end
  end

end  

if gfiles1 == gfiles2 
    disp('Preprocessing complete...')
else
    disp('Not enough good files!')
    stop
end

disp('Computing correlation vector...')
gfiles = max(gfiles1, gfiles2);
nsamples = min(nsamples1, nsamples2);

vcorr = zeros(1,gfiles);
for i = 1:gfiles
    row = mdata1(i,1:nsamples);
    col = mdata2(i,1:nsamples);
    [cc, pp] = corrcoef(row,col);
    vcorr(1,i) = cc(2);
    if cc(2) < 0.3
        fprintf("Low correlation at index %d\n", i)
    end
end

figure;
stem(vcorr)

disp('Computing correlation matrix...')
gfiles = max(gfiles1, gfiles2);
nsamples = min(nsamples1, nsamples2);

mcorr = zeros(gfiles);
for i = 1:gfiles
    row = mdata1(i,1:nsamples);
    for j = 1:gfiles
        col = mdata2(j,1:nsamples);
        [cc, pp] = corrcoef(row,col);
        mcorr(i,j) = cc(2);
    end
end

disp('Creating plot...')

figure
hold on
cmap = hot(200);
for ii=0:gfiles-1
    for jj=0:gfiles-1
        if isnan(mcorr(ii+1,jj+1))
            color = [0 0 0];
        else
            color = cmap(round(mcorr(ii+1,jj+1)*100)+100,:);
        end
        rectangle('Position',[ii,jj*-1,1,1],'Facecolor',color,'edgecolor','none')
        if isnan(mcorr(ii+1,jj+1))
            tcolor = [1 1 1];
        else
            tcolor = [0 0 0];
        end
        text(ii+0.2,((jj-1)*-1)-0.5, num2str(round(mcorr(ii+1,jj+1),2)), 'color', tcolor, 'fontsize', 8)
    end
end


margin=0.05;
axis([0-margin gfiles+margin -1*(gfiles+margin) 1+margin])
axis off
axis square
