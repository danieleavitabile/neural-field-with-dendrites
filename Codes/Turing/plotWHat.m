%% Close all
close all, clear all, clc;

%% Model parameters
xi0 = 1.0; 
nu  = 6.0; c = 1;
mu  = 25; 

gamm = @(v,nu) sqrt((1.0/c+v)/nu);

SFun      = @(v) 1./(1+exp(-mu*v))-0.5; 
SPrimeFun = @(v) mu*exp(-mu*v)./(1+exp(-mu*v)).^2; 

gamma1 = 1;   b1 = 1;
gamma2 = 1/4; b2 = 1/2;
wFun = @(x) gamma1*exp(-b1*abs(x)) - gamma2*exp(-b2*abs(x));
wHatAn = @(p) 2*b1*gamma1./(b1^2+p.^2) - 2*b2*gamma2./(b2^2+p.^2);

wcrit = 2*gamm(0,nu)*nu/(exp(-gamm(0,nu)*xi0)*SPrimeFun(0));
p = linspace(-10,10,1000);

x = linspace(-10,10,1000); 

figure; plot(x,wFun(x));

figure, hold on;
plot(p,wHatAn(p)-wcrit);
% yline(wcrit);

mu = 30;
SFun      = @(v) 1./(1+exp(-mu*v))-0.5; 
SPrimeFun = @(v) mu*exp(-mu*v)./(1+exp(-mu*v)).^2; 
wcrit = 2*gamm(0,nu)*nu/(exp(-gamm(0,nu)*xi0)*SPrimeFun(0));
plot(p,wHatAn(p)-wcrit);
yline(0);

xlabel('$p$');
ylabel('$\hat w(p) - w_*$');

saveas(gcf,'figure.pdf');
