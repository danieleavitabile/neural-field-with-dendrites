clear all, close all, clc;

set(0,'defaulttextinterpreter','latex')
set(0,'DefaultTextFontSize', 10)
set(0,'DefaultTextFontname', 'CMU Serif')
set(0,'DefaultAxesFontSize', 10)
set(0,'DefaultAxesFontName','CMU Serif')
% 
% files(1).name = 'PastTuring_mu_30/solution_0000000.mat';
% files(2).name = 'PastTuring_mu_30/solution_0000600.mat';
% files(3).name = 'PastTuring_mu_30/solution_0006000.mat';
files(1).name = 'BeforeTuring_mu_28/solution_0000000.mat';
files(2).name = 'BeforeTuring_mu_28/solution_0000600.mat';
files(3).name = 'BeforeTuring_mu_28/solution_0006000.mat';

load(files(1).name);
[X,XI] = meshgrid(x,xi);
cLim = [-0.05 0.05];
subplot(3,2,[1 2]);
surf(X,XI,V); shading interp; view([0 90]); axis tight; caxis(cLim);
xlabel('$x$'); 
ylabel('$\xi$');
set(gca,'visible','off');

load(files(2).name);
subplot(3,2,[3 4]);
surf(X,XI,V); shading interp; view([0 90]); axis tight; caxis(cLim);
xlabel('$x$'); 
ylabel('$\xi$');
set(gca,'visible','off');

load(files(3).name);
subplot(3,2,[5 6]);
surf(X,XI,V); shading interp; view([0 90]); axis tight; caxis(cLim);
xlabel('$x$'); 
ylabel('$\xi$');
set(gca,'visible','off');

saveas(gcf,'patterns_mu_28.png')
