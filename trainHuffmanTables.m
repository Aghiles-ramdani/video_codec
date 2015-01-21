function trainHuffmanTables
    clearvars
    directory_path = 'data/images/';
    file_extension = '.bmp';
    file_00 = 'akiyo';
    file_01 = 'coastguard';
    file_02 = 'foreman';
    file_03 = 'news';
    file_04 = 'silent';
    intra_accumulated_sum = 0;
    intra_accumulated_pdf = 0;
    mv_accumulated_sum = 0;
    mv_accumulated_pdf = 0;
    error_accumulated_sum = 0;
    error_accumulated_pdf = 0;
    for i = 0:4
        switch i
            case 0
                for j = 20 : 40
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_00 image_index file_extension];
                    [summation , pdf] = readAndGenerateHistogram(file_path);
                    intra_accumulated_sum = intra_accumulated_sum + summation;
                    intra_accumulated_pdf = intra_accumulated_pdf + pdf;
                end
            case 1
                for j = 20 : 40
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_01 image_index file_extension];
                    [summation , pdf] = readAndGenerateHistogram(file_path);
                    intra_accumulated_sum = intra_accumulated_sum + summation;
                    intra_accumulated_pdf = intra_accumulated_pdf + pdf;
                end
            case 2
                for j = 20 : 40
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_02 image_index file_extension];
                    [summation , pdf] = readAndGenerateHistogram(file_path);
                    intra_accumulated_sum = intra_accumulated_sum + summation;
                    intra_accumulated_pdf = intra_accumulated_pdf + pdf;
                end
            case 3
                for j = 20 : 40
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_03 image_index file_extension];
                    [summation , pdf] = readAndGenerateHistogram(file_path);
                    intra_accumulated_sum = intra_accumulated_sum + summation;
                    intra_accumulated_pdf = intra_accumulated_pdf + pdf;
                end
            case 4
                for j = 20 : 40
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_04 image_index file_extension];
                    [summation , pdf] = readAndGenerateHistogram(file_path);
                    intra_accumulated_sum = intra_accumulated_sum + summation;
                    intra_accumulated_pdf = intra_accumulated_pdf + pdf;
                end
        end
    end
    histogram = intra_accumulated_pdf / intra_accumulated_sum;
    [ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman(histogram);
    function [summation , pdf] =  readAndGenerateHistogram(file_path)
        frame = double(imread(file_path));
        frame = ictRGB2YCbCr(frame);
        pdf = hist(frame,-128:255);
        summation = sum(pdf);
    end
end