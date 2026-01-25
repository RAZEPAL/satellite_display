function fillDataAndPlot(app, name, te, i, raan, e, w, M, n)
    % 1. 填数据（这部分保持不变）
    app.EpochtimeEditField.Value = te;
    app.InclinationEditField.Value = i;
    app.RAANEditField.Value = raan;
    app.EccentricityEditField.Value = e;
    app.ArgumentofperigeeEditField.Value = w;
    app.MeananomalyEditField.Value = M;
    app.MeanmotionEditField.Value = n;
    app.SatelliteDropdown.Value = name;

    % 2. 修改这里：不再直接点按钮，而是调用我们刚才写的“中转站”
    app.triggerInternalActions(); 
end