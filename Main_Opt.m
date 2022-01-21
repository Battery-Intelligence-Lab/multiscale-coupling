%% Battery parameterization with lock-in thermography data 
% Battery physicochemical properties to be parameterized include:
% Specific heat (Cp), thermal conductivity (k), heat transfer coefficienct (h)
% OCP gradient (ku), diffusion coeffcient (Ds)
% ionic conductivity (kappa), temperature coefficient of kappa (alfa_ka)
% Exchange current density (i0ref), Reaction activation energy (Ei0)

clc
clearvars -except xbest
close all
format short g

global xbest Fobjbest 
Fobjbest = 1e5;
iter = 0;

%% Define initial values, lower and upper bounds
%     Cp          k         h           ku        kappa        alfa_ka     i0ref        Ei0       Ds            
x0 = [1.056    1.1200     12.9000     0.3500     80.0000       5.0000     6.20000     29.7500   4.6000]; % Initial values
lb = [0.500    0.1000     1.00000     0.0200     1.00000       1.0000     0.01000     1.00000   0.0100]; % Lower bound
ub = [2.000    100.00     40.0000     0.6000     60.0000       20.000     30.0000     50.0000   100.00]; % Upper bound

%% Start optimization
% options  = optimset('display','iter','MaxFunEvals',1000,'TolX',1e-4,'FinDiffRelStep',1e-2);
% [x fval] = lsqnonlin(@ObjFunc,x0,lb,ub,options)

[Res,ResT,a_mod] = ObjFunc(x0);
