function [Res,ResT,a_mod] = ObjFunc(x)

global xbest Fobjbest

tf          = 2500;       % Time 
Cp          = x(1)*1e3;   % Specific heat
k           = x(2);       % Thermal conductivity
h           = x(3);       % Heat transfer coefficient   
ku          = x(4);       % OCP gradient
kappa       = x(5);       % Ionic conductivity
alfa_ka     = x(6);       % Temperature coefficient of kappa
i0ref       = x(7);       % Exchange current density
Ei0         = x(8);       % Reaction activation energy
Ds          = x(9)*1e-14; % Diffusion coeffcient
DS          = -0.07;      % Entropy change
Vinit       = 3.2381;      % Initial cell voltage
T0          = 23.85;      % Ambient temperature

%% Run COMSOL Model
[hy,hz]=Battery_model(T0,Cp,k,h,ku,kappa,alfa_ka,i0ref,Ei0,Ds,DS,Vinit);
ym=150-hy; % Simulated hot spot y
zm=hz;     % Simulated hot spot z

%% Load EXPERIMENTAL Data
load Exp.mat 
% Exp.mat contains a matrix RunM for temperatures (hot spot, surface average and cold spot), 
% cell voltage and temperature concavity
RunM(1,:) = [];
tData        = RunM(:,1);
Tavg_data    = RunM(:,3);
Tmax_data    = RunM(:,2);
Tmin_data    = RunM(:,4);
Vcell_data   = RunM(:,6);
a_data       = RunM(:,5);
y0=75;       % Experimental hot spot y
z0=166.6667; % Experimental hot spot x

%% Load SIMULATION Results
Run1 = load('Sim.txt'); 
close all

Run1(1,:) = [];
tModel      = Run1(:,1);
Tavg_mod    = Run1(:,4);
Tmax_mod    = Run1(:,2);
Tmin_mod    = Run1(:,3);
VcellModel  = Run1(:,7);

X=[0 ym 150]/1E3;
T=[Run1(:,5) Tmax_mod Run1(:,6)];
p_mod=zeros(tf,3);
for t=1:tf
    p_mod(t,:)=polyfit(X,T(t,:),2);
end
a_mod=p_mod(:,1); % Simulated concavity


%% Calculate RESIDUALS
amax=max(a_data);
amin=min(a_data);
Tavgmax=max(Tavg_data);
Tavgmin=min(Tavg_data);
Tmaxmax=max(Tmax_data);
Tmaxmin=min(Tmax_data);
Tminmax=max(Tmin_data);
Tminmin=min(Tmin_data);
Vcellmax=max(Vcell_data);
Vcellmin=min(Vcell_data);
Lz=200;
Ly=150;
Res1        = (Tavg_mod-Tavg_data)/(Tavgmax-Tavgmin);
Res2        = (Tmax_mod-Tmax_data)/(Tmaxmax-Tmaxmin);
Res3        = (Tmin_mod-Tmin_data)/(Tminmax-Tminmin);
Res4        = (VcellModel-Vcell_data)/(Vcellmax-Vcellmin);
Res5        = (a_mod-a_data)/(amax-amin);
Res6        = sqrt((ym-y0).^2+(zm-z0).^2)/sqrt(Lz*Ly);
Res         = vertcat(Res1,Res2,Res3,Res4,Res5,Res6);
   
ResT        = Res(:);
Fobj        = sum(ResT.^2);

if Fobj<Fobjbest
    xbest    = x;
    Fobjbest = Fobj;
    save('last_res','xbest','Fobjbest')
end

%% PLOT EXP and SIM Results
figure
plot(tData,Tavg_data,'-g',tData,Tmax_data,'-g',tData,Tmin_data,'-g',...
    tModel,Run1(:,2:4),'-b','linewidth',2)
xlabel('Time (s)','fontsize',16)
ylabel('Temperature (\circC)','fontsize',16)
xlim([0 tf])
title(['x =' num2str(x)],'fontsize',16)
figure('Position', [10, 0, 600, 600])
plot(tModel,VcellModel,'-b',tData,Vcell_data,'-g','linewidth',2)
xlabel('Time (s)','fontsize',16)
ylabel('Cell voltage (V)','fontsize',16)
xlim([0 tf])
title(['Res = ' num2str(Fobj)],'fontsize',16)
figure('Position', [10, 0, 600, 600])
plot(tModel,a_mod,'-b',tData,a_data,'-g','linewidth',2)
xlabel('Time (s)','fontsize',16)
ylabel('Concavity','fontsize',16)
xlim([0 tf])
x
Fobj
pause(0.1)
end