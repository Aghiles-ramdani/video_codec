function[] = PerformEncoding(doTrain,Q,GOP_enabled)
    if doTrain
        TrainAllTables(Q);
    end
    EncodeVideo(Q,GOP_enabled);
end