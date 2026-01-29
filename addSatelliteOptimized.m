function addSatelliteOptimized(app, key, epoch, inc, raan, ecc_decimal, argP, meanAnom, meanMotion)
    % 优化的添加卫星函数
    
    global Re SatellitesCache SatellitesHandles SatelliteList
    
    % 1. 修正数据单位
    % LoadTLE 解析出来的是小数 (ecc_decimal)，但 getOE_app 期望的是整数
    % 因为 getOE_app 内部会做 *1e-7。为了抵消，我们这里先 *1e7
    ecc_integer = ecc_decimal * 1e7;
    
    % 2. 计算轨道根数
    % 直接调用你的 getOE_app
    OE = getOE_app(epoch, inc, raan, ecc_integer, argP, meanAnom, meanMotion);
    
    % 3. 统一仿真参数 (24小时, 60秒一步)
    t = 0; 
    dt = 60; 
    TotalDuration = 24 * 60 * 60; 
    num_steps = floor(TotalDuration / dt);
    
    x = zeros(num_steps, 1);
    y = zeros(num_steps, 1);
    z = zeros(num_steps, 1);
    
    % 4. 预计算所有位置
    currentOE = OE;
    for j = 1 : num_steps
        t = t + dt;
        [currentOE] = oblatenessEffects(currentOE);
        [x(j), y(j), z(j)] = cal_position_app(t, currentOE);
    end
    
    % 5. 存入缓存
    if isempty(SatellitesCache), SatellitesCache = struct(); end
    SatellitesCache.(key) = struct('x', x, 'y', y, 'z', z, 'len', length(x));
    
    if isempty(SatelliteList), SatelliteList = {}; end
    if ~ismember(key, SatelliteList)
        SatelliteList{end+1} = key;
    end
    
    % 6. 创建图形 (高性能模式)
    ax = app.UIAxes2;
    if isempty(SatellitesHandles), SatellitesHandles = struct(); end
    
    hold(ax, 'on');
    % 只在第一次画地球
    if isempty(findobj(ax, 'Type', 'Surface'))
        load topo topo;
        [xs, ys, zs] = sphere(30); % 降低精度提升性能
        s = surface(ax, xs*Re, ys*Re, zs*Re);
        s.FaceColor = 'texturemap'; s.CData = topo; s.EdgeColor = 'none';
        axis(ax, 'equal');
    end
    
    % 轨迹线 (灰色，半透明，一次画完)
    SatellitesHandles.(key).orbitLine = plot3(ax, x, y, z, ...
        'Color', [0.6 0.6 0.6 0.4], 'LineWidth', 0.5);
        
    % 卫星点 (用点代替圆，红色)
    SatellitesHandles.(key).satDot = plot3(ax, x(1), y(1), z(1), '.', ...
        'MarkerSize', 8, 'Color', 'r');
    
    % 强制不创建覆盖圈 (避免卡顿)
    SatellitesHandles.(key).coveragePatch = []; 
end