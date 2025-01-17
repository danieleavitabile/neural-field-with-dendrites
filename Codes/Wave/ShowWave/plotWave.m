clear all, close all, clc;

set(0,'defaulttextinterpreter','latex')
set(0,'DefaultTextFontSize', 10)
set(0,'DefaultTextFontname', 'CMU Serif')
set(0,'DefaultAxesFontSize', 10)
set(0,'DefaultAxesFontName','CMU Serif')

files(1).name = 'TW/solution_0000010.mat';
files(2).name = 'TW/solution_0000050.mat';
files(3).name = 'TW/solution_0000100.mat';
files(4).name = 'TW/solution_0000150.mat';
files(5).name = 'TW/solution_0000200.mat';

vLim = [0 .5];

load(files(1).name);
subplot(5,4,[1 2]);
[X,XI] = meshgrid(x,xi);
surf(X,XI,V); shading interp; view([0 90]); axis tight; caxis([0 2]);
xlh = xlabel('$x$'); 
ylabel('$\xi$');
title('(a)');

subplot(5,4,[3 4]);
[~,id0] = min(abs(xi));
plot(x,V(id0,:),'-','lineWidth',2);
xlim([min(x) max(x)]); ylim(vLim);
xlabel('$x$'); ylabel('$V(x,\xi_0,t)$'); 
% text(50,2,['t=' num2str(t)]);
title('(b)');

load(files(2).name);
subplot(5,4,[5 6]);
surf(X,XI,V); shading interp; view([0 90]); axis tight; caxis([0 2]);
xlabel('$x$'); ylabel('$\xi$');

subplot(5,4,[7 8]);
plot(x,V(id0,:),'-','lineWidth',2);
xlim([min(x) max(x)]); ylim(vLim); 
xlabel('$x$'); ylabel('$V(x,\xi_0,t)$'); 

load(files(3).name);
subplot(5,4,[9 10]);
surf(X,XI,V); shading interp; view([0 90]); axis tight; caxis([0 2]);
xlabel('$x$'); ylabel('$\xi$');

subplot(5,4,[11 12]);
plot(x,V(id0,:),'-','lineWidth',2);
xlim([min(x) max(x)]); ylim(vLim);
xlabel('$x$'); ylabel('$V(x,\xi_0,t)$'); 

load(files(4).name);
subplot(5,4,[13 14]);
surf(X,XI,V); shading interp; view([0 90]); axis tight; caxis([0 2]);
xlabel('$x$'); ylabel('$\xi$');

subplot(5,4,[15 16]);
plot(x,V(id0,:),'-','lineWidth',2);
xlim([min(x) max(x)]); ylim(vLim);
xlabel('$x$'); ylabel('$V(x,\xi_0,t)$'); 

load(files(5).name);
subplot(5,4,[17 18]);
surf(X,XI,V); shading interp; view([0 90]); axis tight; caxis([0 2]);
xlabel('$x$'); ylabel('$\xi$');

subplot(5,4,[19 20]);
plot(x,V(id0,:),'-','lineWidth',2);
xlim([min(x) max(x)]); ylim(vLim);
xlabel('$x$'); ylabel('$V(x,\xi_0,t)$'); 

% saveas(gcf,'figure.pdf');
