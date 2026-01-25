
% function pairs = buildLinkPairs(keys)
% % keys: cell array {'sat1','sat2','sat3'}
% % pairs: struct array with fields satA, satB
% 
% pairs = struct('satA',{},'satB',{});
% 
% if numel(keys) < 2
%     return;
% end
% 
% for i = 1:numel(keys)-1
%     pairs(end+1).satA = keys{i};
%     pairs(end).satB   = keys{i+1};
% end
% end
