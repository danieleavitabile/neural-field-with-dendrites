%% Clean
clear all, close all, clc;

%% Model parameters
xi0 = 1.0; eps = 0.005; 
nu  = 0.4; xStar = 20; c = 1;
mu  = 1000; vth = 0.20; kappa = 3;

%% Numerical parameters
nx  = 2^12; Lx  = 24*pi; 
nxi = 2^10; Lxi = 3;
tau = 0.05; nt = 1000; iplot = 20; ihist = iplot;

%% Spatial grid
hx  = 2*Lx/nx;  x  = -Lx +[0:nx-1]*hx;
hxi = 2*Lxi/(nxi-1); xi = -Lxi + [0:nxi-1]'*hxi;
[X,XI] = meshgrid(x,xi);

%% Function handles
wFun      = @(x) kappa*0.5*exp(-abs(x)); 
alphaFun  = @(xi,eps) (eps*sqrt(pi))^-1 * exp( -(xi-xi0).^2/eps^2)...
                 .*(abs(xi - xi0) <= 2*eps);
alphaPFun  = @(xi,eps) (eps*sqrt(pi))^-1 * exp( -xi.^2/eps^2)...  
                 .*(abs(xi) <= 2*eps);
SFun      = @(v) 1./(1+exp(-mu*(v-vth))); 

%% Precomputing vectors
wHat = fft(wFun(x));
alpha  = alphaFun(xi,eps);  J  = find(alpha  ~= 0); alpha  = alpha(J);
alphaP = alphaPFun(xi,eps); JP = find(alphaP ~= 0); alphaP = alphaP(JP);

%% Quadrature weights
sigma = ones(nxi,1); sigma([1 nxi]) = 0.5; sigma = hxi*sigma; sigma = sigma(JP);

%% Differenstiation matrix and linear operator
e = ones(nx,1); D2 = spdiags([e -2*e e], -1:1, nxi, nxi); 
D2(1,2) = 2; D2(nxi,nxi-1) = 2; D2 = D2/hxi^2;
A  = (1+tau/c)*speye(nxi) - tau*nu*D2;
dA = decomposition(A);

%% Initial condition
V = (1 - 1./(1+exp(-5*(X-xStar)))).*(X>0) + (1 - 1./(1+exp(5*(X+xStar)))).*(X<=0);
V = 0.5*V;
% sol = load('waveProfile.mat'); V = 5*sol.V;
t = 0;

%% Plot
subplot(2,2,[1 2]); surf(X,XI,V); shading interp; view([0 90]); 
                    axis tight; caxis([0 1]);
subplot(2,2,[3 4]); [~,id0] = min(abs(xi-xi0)); plot(x,V(id0,:)); ylim([0 1]); pause(1);

!rm -rf Data && mkdir Data;
%% TimeStep 
for it = 1:nt

  % Compute F
  F = zeros(nxi,nx);
  S = (alphaP .* sigma)'*SFun(V(JP,:));
  conv = hx*ifftshift(real(ifft(fft(S) .* wHat)));
  F(J,:) = alpha * conv;

  % Update V
  V = dA\(V + tau*F);
  t = t + tau;

  % Plot
  if mod(it,iplot)== 0  
    subplot(2,2,[1 2]); surf(X,XI,V); shading interp; view([0 90]); axis tight;
    title(['t = ' num2str(t)]); caxis([0 2]); drawnow;
    subplot(2,2,[3 4]);  plot(x,V(id0,:),'.-'); ylim([0 2]);
  end

  % Save
  if mod(it,ihist) == 0
    fileName = sprintf('Data/solution_%07i.mat',it);
    save(fileName,'t','V','xi0','eps','nu','xStar','c','mu','vth', 'kappa',...
                  'nx','Lx','nxi','Lxi','tau','nt','xi','x');
  end

end

% clear dA; save('savedData.mat');
