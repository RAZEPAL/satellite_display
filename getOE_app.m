function OE = getOE_app(t,i,Omega,e,w,M,n)
%%% get Orbital Elements
% TLEdata = [ t,i,Omega,e,w,M,n ] 
% OE = [a,e,i,Omega,w,T0,Period,epoch_sec]
global mu D2R

%%% get TLE data
e_float = e*1e-7;            %离心率格式转换
M_rad = M*D2R;               % rad
n_rad = n*2*pi/(24*60*60);   % 单位转换，从rev/day到rad/s

%%% calculate Orbital Elements
a = (mu./(n_rad.^2)).^(1/3);  %根据开普勒第三定律计算半长轴
Period = 2*pi./n_rad;         %根据开普勒第三定律计算周期
epoch_sec = rem(t,1000)*(24*60*60);   % 先对历元时间取余数，得出天数，转化成秒
T0 = epoch_sec - M_rad./n_rad;%根据平均近点角计算上一次经过近地点的时刻

OE = [a,e_float,i,Omega,w,T0,Period,epoch_sec];

end