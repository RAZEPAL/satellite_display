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

% % 通信链路更新
% 
% otherNames = setdiff(fieldnames(SatellitesCache), key);
% if ~isfield(h, 'linkArcs')
%     h.linkArcs = struct();
% end
% 
% allKeys = sort(fieldnames(SatellitesCache)); % 确保顺序一致
% thisIndex = find(strcmp(allKeys, key));
% 
% for i = 1:numel(otherNames)
%     otherKey = otherNames{i};
%     otherIndex = find(strcmp(allKeys, otherKey));
%     if thisIndex >= otherIndex
%         continue; % 只让字母序小的卫星画一次
%     end
% 
%     otherSat = SatellitesCache.(otherKey);
%     if k <= min(otherSat.len, sat.len)
%         posA = [sat.x(k), sat.y(k), sat.z(k)];
%         posB = [otherSat.x(k), otherSat.y(k), otherSat.z(k)];
% 
%         % 转为单位向量（方向）
%         dirA = posA / norm(posA);
%         dirB = posB / norm(posB);
% 
%         % 球面角度
%         cosang = dot(dirA, dirB);
%         cosang = max(min(cosang, 1), -1);
%         ang = acos(cosang);
% 
%         % 生成球面弧（nSeg点）
%         nSeg = 80;
%         t = linspace(0, 1, nSeg);
%         arcDirs = zeros(nSeg, 3);
%         for j = 1:nSeg
%             % 球面插值 (Slerp)
%             arcDirs(j,:) = (sin((1-t(j))*ang)*dirA + sin(t(j)*ang)*dirB) / sin(ang);
%             arcDirs(j,:) = arcDirs(j,:) / norm(arcDirs(j,:));
%         end
% 
%         % 弧半径略高于卫星轨道平均半径，确保不穿球
%         rA = norm(posA);
%         rB = norm(posB);
%         rMean = (rA + rB) / 2;
%         arcPts = arcDirs * (rMean * 1.02);
% 
%         % 绘制或更新
%         linkID = sprintf('%s_%s', key, otherKey);
%         if ~isfield(h.linkArcs, linkID) || ~isvalid(h.linkArcs.(linkID))
%             h.linkArcs.(linkID) = plot3(app.UIAxes2, ...
%                 arcPts(:,1), arcPts(:,2), arcPts(:,3), ...
%                 'Color', [0.1 1 0.1], 'LineWidth', 1.5, 'LineStyle', '--');
%         else
%             set(h.linkArcs.(linkID), ...
%                 'XData', arcPts(:,1), ...
%                 'YData', arcPts(:,2), ...
%                 'ZData', arcPts(:,3));
%         end
%     end
% end
% 


% 帧数更新

GlobalFrame = GlobalFrame + 1;
SatellitesHandles.(key) = h;
updateLinks();
end


