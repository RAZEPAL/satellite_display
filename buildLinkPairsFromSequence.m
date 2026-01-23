function pairs = buildLinkPairsFromSequence(seq, nameMap)
% seq: 例如 "213"
% nameMap: containers.Map('1'->'satellite1', ...)

pairs = struct('satA',{},'satB',{});

for i = 1:length(seq)-1
    a = seq(i);
    b = seq(i+1);

    if ~isKey(nameMap,a) || ~isKey(nameMap,b)
        continue
    end

    pairs(end+1).satA = nameMap(a);
    pairs(end).satB   = nameMap(b);
end
end
