function updateLinks()
global LinkTable SatellitesCache GlobalFrame

for i = 1:numel(LinkTable)
    A = LinkTable(i).satA;
    B = LinkTable(i).satB;

    satA = SatellitesCache.(A);
    satB = SatellitesCache.(B);

    k = min([GlobalFrame, satA.len, satB.len]);

    posA = [satA.x(k), satA.y(k), satA.z(k)];
    posB = [satB.x(k), satB.y(k), satB.z(k)];

    % ===== 球面弧（已经验证可行）=====
    dirA = posA / norm(posA);
    dirB = posB / norm(posB);
    ang  = acos(max(min(dot(dirA,dirB),1),-1));

    t = linspace(0,1,80);
    arc = zeros(80,3);
    for j=1:80
        arc(j,:) = (sin((1-t(j))*ang)*dirA + sin(t(j)*ang)*dirB)/sin(ang);
        arc(j,:) = arc(j,:) * 1.02 * mean([norm(posA),norm(posB)]);
    end

    set(LinkTable(i).handle,...
        'XData',arc(:,1),'YData',arc(:,2),'ZData',arc(:,3));
end
end
