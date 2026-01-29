function GlobalUpdateManager(app)
    global SatellitesCache SatellitesHandles GlobalFrame LinkTable SatelliteList
    
    % 1. 推进时间
    if isempty(GlobalFrame), GlobalFrame = 1; end
    GlobalFrame = GlobalFrame + 1;
    
    % 2. 循环保护 (假设所有卫星长度一致)
    if ~isempty(SatelliteList)
        firstKey = SatelliteList{1};
        if isfield(SatellitesCache, firstKey) && GlobalFrame > SatellitesCache.(firstKey).len
            GlobalFrame = 1; 
        end
    end
    
    k = GlobalFrame;
    
    % 3. 批量刷新点
    if isempty(SatelliteList), return; end
    keys = SatelliteList;
    
    for i = 1:numel(keys)
        key = keys{i};
        if ~isfield(SatellitesHandles, key), continue; end
        
        h = SatellitesHandles.(key);
        sat = SatellitesCache.(key);
        
        try
            % 只更新点的位置
            set(h.satDot, 'XData', sat.x(k), 'YData', sat.y(k), 'ZData', sat.z(k));
        catch
        end
    end
    
    % 4. 刷新链路
    if ~isempty(LinkTable)
        try, updateLinks(); catch, end
    end
    
    drawnow limitrate; % 高性能刷新
end