function satelliteUpdate(app, key)

    global Re SatellitesCache SatellitesHandles
    global GlobalFrame LinkTable SatelliteList 
    % 引入 LinkTable 和 SatelliteList 是为了控制时间和链路刷新
    
    if ~isfield(SatellitesCache, key)
        return;
    end
    
    sat = SatellitesCache.(key);
    h = SatellitesHandles.(key);
    
    %  安全获取当前帧 
    if isempty(GlobalFrame) || GlobalFrame < 1
        GlobalFrame = 1;
    end
    
    % 获取当前卫星的数据长度（例如 1440）
    maxLen = sat.len; 
    
    % 如果 GlobalFrame 意外超出了当前卫星的数据范围，强制归位
    k = GlobalFrame;
    if k > maxLen
        k = 1;
        % 注意：这里不直接改 GlobalFrame，只改局部变量 k 用于取数
    end
    
    % === 2. 更新绘图 (保持原逻辑) ===
    
    % 卫星坐标
    satPos = [sat.x(k), sat.y(k), sat.z(k)];
    r_sat = norm(satPos);
    hAlt = r_sat - Re;
    % 增加保护：防止 hAlt < 0 导致复数
    if hAlt < 0, hAlt = 0; end 
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
    
    % 更新轨迹线
    h.orbitLine.XData = sat.x(1:k);
    h.orbitLine.YData = sat.y(1:k);
    h.orbitLine.ZData = sat.z(1:k);
    
    % 更新卫星点
    h.satDot.XData = sat.x(k);
    h.satDot.YData = sat.y(k);
    h.satDot.ZData = sat.z(k);
    
    SatellitesHandles.(key) = h;
    
    
    % 修复区
    
    % 逻辑：只有“主控卫星”负责推进时间和刷新链路
    % 防止 N 颗卫星导致 N 倍速更新
    
    isMaster = false;
    if isempty(SatelliteList)
        % 如果没有列表（旧代码兼容），默认大家都是主控
        isMaster = true; 
    elseif strcmp(key, SatelliteList{1})
        % 只有列表里的第一颗卫星才是“时间领主”
        isMaster = true;
    end
    
    if isMaster
        % 只有主控卫星负责将时间 +1
        GlobalFrame = GlobalFrame + 1;
        
        %  循环播放逻辑 
        % 如果跑到底了，重置回开头，防止动画停止
        if GlobalFrame > maxLen
            GlobalFrame = 1;
        end
        
        % 只有主控卫星负责刷新链路
        % 这样每一步只会调用一次 updateLinks，避免闪烁和性能浪费
        if ~isempty(LinkTable)
            try
                updateLinks(); 
            catch
                % 忽略错误
            end
        end
    end

end