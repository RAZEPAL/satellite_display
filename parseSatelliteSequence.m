function keys = parseSatelliteSequence(seq)
% seq: char array like '123'
% keys: cell array of satellite keys

global SatelliteList

keys = {};

if isempty(seq) || isempty(SatelliteList)
    return;
end

for i = 1:length(seq)
    idx = str2double(seq(i));

    % 非数字 or NaN
    if isnan(idx)
        continue;
    end

    % 越界直接跳过
    if idx < 1 || idx > numel(SatelliteList)
        continue;
    end

    keys{end+1} = SatelliteList{idx};
end
end
