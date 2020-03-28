close all, clear all, clc;

dirName = 'BeforeTuring_mu_28'; 
files = dir(fullfile(dirName, '*.mat'));

nFiles = length(files);
tVals  = zeros(nFiles,1);
vMaxVals  = zeros(size(tVals));

for k = 1:nFiles

  load([files(k).folder '/' files(k).name]);
  tVals(k) = t;
  vMaxVals(k) = max(abs(V(id0P,:)));

end
plot(tVals,vMaxVals,'-');

hold on;

dirName = 'PastTuring_mu_30'; 
files = dir(fullfile(dirName, '*.mat'));

nFiles = length(files);
tVals  = zeros(nFiles,1);
vMaxVals  = zeros(size(tVals));

for k = 1:nFiles

  load([files(k).folder '/' files(k).name]);
  tVals(k) = t;
  vMaxVals(k) = max(abs(V(id0P,:)));

end
plot(tVals,vMaxVals,'-');

xlim([0 100]);
xlabel('$t$');
ylabel('$\max_x |V(x,0,t)|$');

saveas(gcf,'figure.pdf');
