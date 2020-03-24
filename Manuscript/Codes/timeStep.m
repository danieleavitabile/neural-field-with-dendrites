%% Model parameters
xi0 = 1.0; epsi = 0.005; nu  = 0.4; xStar = 5; c = 1;
mu  = 1000; vth = 0.01; kappa = 3;

%% Numerical parameters
nx  = 2^12; Lx  = 24*pi; nxi = 2^10; Lxi = 3;
tau = 0.05; nt = 1000; iplot = 10; ihist = iplot;

%% Spatial grid
hx  = 2*Lx/nx;  x  = -Lx +[0:nx-1]*hx;
hxi = 2*Lxi/(nxi-1); xi = -Lxi + [0:nxi-1]'*hxi;
[X,XI] = meshgrid(x,xi);

%% Function handles
wFun      = @(x) kappa*0.5*exp(-abs(x)); 
alphaFun  = @(xi,epsi) (epsi*sqrt(pi))^-1 * exp( -(xi-xi0).^2/epsi^2)...
                 .*(abs(xi - xi0) <= 2*epsi);
alphaPFun  = @(xi,epsi) (epsi*sqrt(pi))^-1 * exp( -xi.^2/epsi^2)...  
                 .*(abs(xi) <= 2*epsi);
SFun      = @(v) 1./(1+exp(-mu*(v-vth))); 

%% Precomputing vectors
wHat = fft(wFun(x));
alpha  = alphaFun(xi,epsi);  J  = find(alpha  ~= 0); alpha  = alpha(J);
alphaP = alphaPFun(xi,epsi); JP = find(alphaP ~= 0); alphaP = alphaP(JP);

%% Quadrature weights
sigma = ones(nxi,1); sigma([1 nxi]) = 0.5; sigma = hxi*sigma; sigma = sigma(JP);

%% Differenstiation matrix and linear operator
e = ones(nx,1); D2 = spdiags([e -2*e e], -1:1, nxi, nxi); 
D2(1,2) = 2; D2(nxi,nxi-1) = 2; D2 = D2/hxi^2;
A  = (1+tau/c)*speye(nxi) - tau*nu*D2;
dA = decomposition(A);

%% Initial condition
t = 0;
V = 0.5*(1 - 1./(1+exp(-5*(X-xStar)))).*(X>0) +...
    0.5*(1 - 1./(1+exp(5*(X+xStar)))).*(X<=0);

%% Plots
subplot(2,2,[1 2]); 
p1 = surf(X,XI,V); p1.ZDataSource = 'V'; 
shading interp; view([0 90]); axis tight; caxis([0 1]); 

subplot(2,2,[3 4]); 
[~,id0] = min(abs(xi-xi0)); VSlice = V(id0,:); 
p2 = plot(x,VSlice,'*-'); p2.YDataSource = 'VSlice'; ylim([0 2.5]); 

%% TimeStep 
for it = 1:nt

  % Compute F
  F = zeros(nxi,nx);
  S = (alphaP .* sigma)'*SFun(V(JP,:));
  convol = hx*ifftshift(real(ifft(fft(S) .* wHat)));
  F(J,:) = alpha * convol;

  % Update V
  V = dA\(V + tau*F);
  t = t + tau;

  % Update plot
  if mod(it,iplot) == 0  
    VSlice = V(id0,:);
    title(['t = ' num2str(t)]); caxis([0 2]); 
    refreshdata, drawnow;
  end

end
