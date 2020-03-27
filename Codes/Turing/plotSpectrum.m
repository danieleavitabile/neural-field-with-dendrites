close all, clear all, clc;
xi0 = 2.0; eps = 0.005; 
nu  = 1.0; c = 1;
mu  = 1000; kappa = 1;
gamma1 = 16; gamma2 = 4; 

gamm = @(v,nu) sqrt((1.0/c+v)/nu);

SFun      = @(v) 1./(1+exp(-mu*v))-0.5; 
SPrimeFun = @(v) mu*exp(-mu*v)./(1+exp(-mu*v)).^2; 

wFun = @(x) kappa*(-gamma1*exp(-gamma1*x.^2)+gamma2*exp(-gamma2*x.^2));
wHatAn = @(p) -sqrt(pi*gamma1).*exp(-p.^2/(4*gamma1))...
              +sqrt(pi*gamma2).*exp(-p.^2/(4*gamma2));

EFun = @(lambda,p) ...
    1-SPrimeFun(0)*kappa*exp(-gamm(lambda,nu)*xi0) .* wHatAn(p)./(2*gamm(lambda,nu)*nu);

lambdaR = linspace(-100,100,1000);
lambdaI = linspace(-100,100,1000);
p      = 4;
[LR,LI] = meshgrid(lambdaR,lambdaI);

figure, hold on;
E = EFun(LR + 1i*LI,p);
contour(LR,LI,real(E),[0,0],'b');
contour(LR,LI,imag(E),[0,0],'r');
xline(0,'k');
grid on;
