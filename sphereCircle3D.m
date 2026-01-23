function [X, Y, Z] = sphereCircle3D(center, normal, Re, theta, N)
% 生成地球表面上的圆，用于表示卫星覆盖范围
% center - 圆心坐标（地表投影点）
% normal - 法向量（卫星方向）
% Re     - 地球半径
% theta  - 圆的地心角半径
% N      - 圆的分段数

normal = normal / norm(normal);
% 找到一个与normal垂直的向量
if abs(normal(1)) < 0.9
    v = cross(normal, [1 0 0]);
else
    v = cross(normal, [0 1 0]);
end
v = v / norm(v);
u = cross(normal, v);

phi = linspace(0, 2*pi, N);
X = zeros(1, N);
Y = zeros(1, N);
Z = zeros(1, N);

for i = 1:N
    point = cos(theta)*normal + sin(theta)*(cos(phi(i))*v + sin(phi(i))*u);
    point = point * (Re + 1e3); % 把覆盖圈抬高 1 km

    X(i) = point(1);
    Y(i) = point(2);
    Z(i) = point(3);
end
end
