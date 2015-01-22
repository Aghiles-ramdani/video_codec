%% Huffman table training for P frames
% 
% This function generates the Huffman table necessaries for a video coder
% for inter prediction using the motion sequences:
%
% "akiyo"
% "coastguard"
% "foreman"
% "news"
% "silent"
%

function[ mv_BinaryTree, mv_HuffCode, mv_BinCode, mv_Codelengths, ef_BinaryTree, ef_HuffCode, ef_BinCode, ef_Codelengths] = trainInterHuffmanTable
    %% Variable declaration
    clearvars
    directory_path = 'data/images/';
    file_extension = '.bmp';
    file_00 = 'akiyo';
    file_01 = 'coastguard';
    file_02 = 'foreman';
    file_03 = 'news';
    file_04 = 'silent';
    start_of_sequence = 20;
    end_of_sequence = 21;
    macroblock_dim = 8;
    mv_search_range = 4;
    Q = 1;
    intra_accummulated_mv_histogram = 0;
    intra_accummulated_mv_sum = 0;
    intra_accummulated_ef_histogram = 0;
    intra_accummulated_ef_sum = 0;
    %% 
    % Read the first two frames of each sequence. Perform motion estimation
    % and obtain motion vectors and error images. Calculate and accumulate
    % the statistics of each mv and each error image and finally generate
    % common Huffman table and store it.
    start_time = cputime;
    for i = 0:4
        switch i
            case 0
                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_00 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1});
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
                
            case 1

                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_01 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1});
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
            case 2
                
                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_02 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1});
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
            case 3
                
                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_03 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1});
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
            case 4
                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_04 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1});
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
        end
    end
    mv_histogram = intra_accummulated_mv_histogram / intra_accummulated_mv_sum;
    [ mv_BinaryTree, mv_HuffCode, mv_BinCode, mv_Codelengths] = buildHuffman(mv_histogram);
    save('video_codec/huffman_tables/inter_binary_tree.mat', 'mv_BinaryTree');
    save('video_codec/huffman_tables/inter_huff_code.mat', 'mv_HuffCode');
    save('video_codec/huffman_tables/inter_bin_code.mat', 'mv_BinCode');
    save('video_codec/huffman_tables/inter_codelengths.mat', 'mv_Codelengths');
    ef_histogram = intra_accummulated_ef_histogram / intra_accummulated_ef_sum;
    [ ef_BinaryTree, ef_HuffCode, ef_BinCode, ef_Codelengths] = buildHuffman(ef_histogram);
    save('video_codec/huffman_tables/inter_binary_tree.mat', 'ef_BinaryTree');
    save('video_codec/huffman_tables/inter_huff_code.mat', 'ef_HuffCode');
    save('video_codec/huffman_tables/inter_bin_code.mat', 'ef_BinCode');
    save('video_codec/huffman_tables/inter_codelengths.mat', 'ef_Codelengths');
    end_time = cputime - start_time;
    fprintf('Inter Huffman table training execution time equals: %d seconds.\n',end_time);
end