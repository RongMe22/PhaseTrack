%music with DoA (antennas) & ToF (subcarriers)

function [P, V]=mymusic(R,d_norm,phs)
if nargin<3,  phs=[0:180]*(pi/180);  end
tao=[4/4:4000/4]*(0.04);
if nargin<2,  d_norm=0.5;   end
M = size(R,1); mm = [0:M-1].'; % Number of antennas and Index vector
if max(phs)>6.3,  phs_deg=phs; phs=pi/180*phs;  
 else phs_deg=180/pi*phs; 
end
% Eigendecomposition or Spectral decomposition
[V,Lam] = eig(R);      % Eq.(7.29)
[lambdas,idx] = sort(abs(diag(Lam)));
[dmax,Nn] = max(diff(log10(lambdas+1e-3)));
Nn=26;
Vn=V(:,idx(1:Nn)); % MxNn matrix made of presumed noise eigenvectors (7.30)
% for i=1:length(phs)
%    a = exp(j*2*pi*d_norm*cos(phs(i))*mm); % Steering vector
%    P(i) = 1/(a'*Vn*Vn'*a+eps);  % Eq.(7.31)
% end
%need new steering vector for comb Doa & Tof
%  Mn=30-28;
%  Xn=V(:,idx(end-Mn+1:end));
for i=1:length(phs)
    for k=1:length(tao)
       %b=exp(2j*pi*tao(k)*(0:14));
       b=exp(-2j*pi*tao(k)/300*(40/29)*(0:14));
       %b=exp(2j*pi*tao(k)/300)*exp(2j*pi*tao(k)/300*(40/29)*(0:14));
      % c = exp(-2j*pi*d_norm*cos(phs(i))*((5.3 * 10/3))*(0:1)); %d Steering vector
       c = exp(-2j*pi*d_norm*cos(phs(i))*(0:1)); %d Steering vector
       a=b.'*c;
       a= reshape(a,[30 1]);
       P(i,k) = 1/(a'*Vn*Vn'*a+eps);  % Eq.(7.31)
       %P(i,k) = (a'*Xn*Xn'*a);  % Eq.(7.31)
    end
end
%%
%test
% calcA;
% Pn=ba'*(Xn*Xn')*ba
% %Pnn=

%%
[xx, yy]=meshgrid(tao,phs_deg);
figure
mesh(xx,yy,10*log10(abs(P)));
drawnow
% if nargout==0
%   P_dB=10*log10(abs(P)); P_dB=p_dB-max(P_dB);
%   plot(phs_deg,P_dB), axis([min(phs_deg) max(phs_deg) -50 0]), grid on
% end