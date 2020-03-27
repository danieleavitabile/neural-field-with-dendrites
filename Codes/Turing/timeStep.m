%% Clean
clear all, close all, clc;

%% Model parameters
xi0 = 1.0; eps = 0.005; 
nu  = 6.0; c = 1;
mu  = 25; % 30 
gamma1 = 1; b1 = 1;
gamma2 = 1/4; b2 = 1/2;

%% Numerical parameters
kCrit = 0.4;
nx  = 2^9; Lx  = 4*pi/kCrit;
nxi = 2^11;  Lxi = pi/kCrit;
tau = 0.01; nt = 10000; iplot = 100; ihist = 2*iplot; 
vLim = [-.1 .1]; vColorLim = vLim;
xLim = [-Lx Lx]; xiLim = [-Lxi Lxi];

%% Spatial grid
hx  = 2*Lx/(nx-1);  x  = -Lx +[0:nx-1]*hx;
hxi = 2*Lxi/(nxi-1); xi = -Lxi + [0:nxi-1]'*hxi;
[X,XI] = meshgrid(x,xi);

%% Function handles
wFun      = @(x) gamma1*exp(-b1*abs(x)) - gamma2*exp(-b2*abs(x));
alphaFun  = @(xi,eps) (eps*sqrt(pi))^-1 * exp( -(xi-xi0).^2/eps^2)...
                 .*(abs(xi - xi0) <= 2*eps);
alphaPFun = @(xi,eps) (eps*sqrt(pi))^-1 * exp( -xi.^2/eps^2)...  
                 .*(abs(xi) <= 2*eps);
SFun      = @(v) 1./(1+exp(-mu*v))-0.5; 
% plot(x,wFun(x));
% pause

%% Precomputing vectors
wHat = fft(wFun(x));
alpha  = alphaFun(xi,eps);  J  = find(alpha  ~= 0); alpha  = alpha(J);
alphaP = alphaPFun(xi,eps); JP = find(alphaP ~= 0); alphaP = alphaP(JP);

%% Quadrature weights
sigma = ones(nxi,1); sigma([1 nxi]) = 0.5; sigma = hxi*sigma; sigma = sigma(JP);

%% Differenstiation matrix and linear operator
e = ones(nxi,1); D2 = spdiags([e -2*e e], -1:1, nxi, nxi); 
D2(1,nxi) = 1; D2(nxi,1) = 1; D2 = D2/hxi^2;
A  = (1+tau/c)*speye(nxi) - tau*nu*D2;
dA = decomposition(A);

%% Initial condition
V = 0.01*cos(kCrit*X);% + 10*sin(kCrit*X);
t = 0;

%% Plot
subplot(2,2,[1 2]); surf(X,XI,V); shading interp; view([0 90]); 
                    xlabel('X');ylabel('XI');
                    axis tight; 
subplot(2,2,[3 4]); [~,id0] = min(abs(xi-xi0)); 
                    [~,id0P] = min(abs(xi)); 
		    plot(x,[V(id0,:); V(id0P,:)]);
		    xlim(xLim);
		    ylim(vLim);
                     

% figure; surf(X,XI,SFun(V)); shading interp; pause

!rm -rf Data && mkdir Data;

fileName = sprintf('Data/solution_%07i.mat',0);
save(fileName,'t','V','xi0','eps','nu','c','mu', ...
          'gamma1','gamma2',...
          'b1','b2',...
          'nx','Lx','nxi','Lxi','tau','nt','xi','x',...
	  'id0','id0P');

%% TimeStep 
for it = 1:nt

  % Compute F
  F = zeros(nxi,nx);
  S = (alphaP .* sigma)'*SFun(V(JP,:));
  conv = hx*ifftshift(real(ifft(fft(S) .* wHat)));
  F(J,:) = alpha * conv;

  % figure; surf(X,XI,F); shading interp; pause

  % Update V
  V = dA\(V + tau*F);
  t = t + tau;

  % Plot
  if mod(it,iplot)== 0  
    subplot(2,2,[1 2]); surf(X,XI,V); shading interp; view([0 90]); 
    axis tight; caxis(vColorLim);
    title(['t = ' num2str(t)]); 
    subplot(2,2,[3 4]);  plot(x,[V(id0,:); V(id0P,:)]); 
    xlim(xLim); ylim(vLim);
    drawnow;
  end

  % Save
  if mod(it,ihist) == 0
    fileName = sprintf('Data/solution_%07i.mat',it);
    save(fileName,'t','V','xi0','eps','nu','c','mu', ...
	          'gamma1','gamma2',...
	          'b1','b2',...
                  'nx','Lx','nxi','Lxi','tau','nt','xi','x',...
		  'id0','id0P');
  end

end

% clear dA; save('savedData.mat');
