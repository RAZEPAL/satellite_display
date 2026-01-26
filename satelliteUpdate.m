function satelliteUpdate(app, key)

global Re SatellitesCache SatellitesHandles
if ~isfield(SatellitesCache, key)
    return;
end

sat = SatellitesCache.(key);
h = SatellitesHandles.(key);

% 帧计数器
global GlobalFrame
k = GlobalFrame;
if k > sat.len
    k = 1;
end



% 卫星坐标
satPos = [sat.x(k), sat.y(k), sat.z(k)];
r_sat = norm(satPos);
hAlt = r_sat - Re;
val = min(max(Re / (Re + hAlt), -1), 1);
theta_c = acos(val);
satDir = satPos / r_sat;
subpoint = satDir * Re;

% 覆盖圈
[cx, cy, cz] = sphereCircle3D(subpoint, satDir, Re, theta_c, 60);
if isempty(h.coveragePatch) || ~isvalid(h.coveragePatch)
    h.coveragePatch = fill3(app.UIAxes2, cx, cy, cz, 'r', ...
        'FaceAlpha', 0.3, 'EdgeColor', 'y');
    SatellitesHandles.(key).coveragePatch = h.coveragePatch;
else
    h.coveragePatch.XData = cx;
    h.coveragePatch.YData = cy;
    h.coveragePatch.ZData = cz;
end

% 更新轨迹线和卫星点
h.orbitLine.XData = sat.x(1:k);
h.orbitLine.YData = sat.y(1:k);
h.orbitLine.ZData = sat.z(1:k);
h.satDot.XData = sat.x(k);
h.satDot.YData = sat.y(k);
h.satDot.ZData = sat.z(k);




% 帧数更新

GlobalFrame = GlobalFrame + 1;
SatellitesHandles.(key) = h;
updateLinks();
end


