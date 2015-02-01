function[] = PerformEncoding(doTrain,Q,GOP_enabled,DEMV_enabled)
    if doTrain
        TrainAllTables(Q);
    end
    EncodeVideo(Q,GOP_enabled,DEMV_enabled);
end