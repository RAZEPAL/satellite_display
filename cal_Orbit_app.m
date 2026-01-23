function [r,nu] = cal_Orbit_app(t,Orbital_Elements)
%%% get r(Distance) & nu(True Anomaly)
global mu

% Orbital_Elements = [a,e,i,Omega,w,T0,Period,epocTime_sec]
a = Orbital_Elements(1);  %获取半长轴
e =  Orbital_Elements(2); %获取离心率
n = sqrt(mu/a^3);
T0 = Orbital_Elements(6);

M = n*(t - T0);                           % 平均近点角
E = M + e*sin(M);                         % 应使用迭代法，高斯方程的一阶近似
nu = 2*atan(sqrt((1+e)/(1-e))*tan(E/2));  % 真近点角
r = a.*(1-e^2)./(1+e.*cos(nu));           % 椭圆极坐标公式计算极径

end