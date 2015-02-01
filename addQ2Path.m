function[file_path] = addQ2Path(file_path,index,Q,MVDE_enabled)
    Q = num2str(Q,'%02d');
    file_path(index) = Q(1);
    file_path(index+1) = Q(2);
    if MVDE_enabled
        file_path = [file_path(1:index-2) 'de' file_path(index-1:end)];
    end
end