clear all, close all, clc;


directories(1).name = 'TW-mu-700';
directories(2).name = 'TW-mu-800';
directories(3).name = 'TW-mu-900';
directories(4).name = 'TW-mu-1000';
directories(5).name = 'TW-mu-1100';
directories(6).name = 'TW-mu-1200';

for i = 1:length(directories)

	files = dir(fullfile(directories(i).name, '*.mat'));
	
	nFiles = length(files);
	tVals  = zeros(nFiles,1);
	xth    = zeros(size(tVals));
	
	for j = 1:nFiles
	
	  load([files(j).folder '/' files(j).name]);
	
	  % vthVals(j) = vth;
	  iHalf = nx/2+1:nx;
	  [~,id0] = min(abs(xi-xi0));
	
	  x = x(iHalf);
	  v0 = V(id0,iHalf);
	  [~,iv] = find(v0 < vth);
	  vp = v0(iv(1)-1); xp = x(iv(1)-1);
	  vm = v0(iv(1)); xm = x(iv(1));
	  xth(j) = xm + (vth - vm)/(vp - vm) *(xp-xm);
	  tVals(j) = t;
	
	end
	speed = diff(xth)./diff(tVals)
	
	vVals(i) = speed(end);
	vthVals(i) = vth;
	muVals(i) = mu;

end

gamm =@(v) sqrt((1.0/c+v)/nu);
G = @(vth,v) vth - kappa*0.5*exp(-gamm(v)*xi0)./(2*nu*gamm(v));

vStar = fsolve(@(v) G(vth,v),vVals(end));
err = abs(vVals-vStar);
loglog(muVals,err,'*',muVals,5*10^16*muVals.^(-6),'-');
xlim([650 1250]);
ylim([10^-2 1]);
xlabel('$\mu$');
ylabel('Error');
text(900,1e-1,'$O(\mu^{-6})$');
saveas(gcf,'figure.pdf');
print('figure.pdf','-dpdf');
