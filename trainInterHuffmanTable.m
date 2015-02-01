%% Huffman table training for P frames
% 
% This function generates the Huffman table necessaries for a video coder
% for inter prediction with P frames using the motion sequences:
%
% "akiyo"
% "coastguard"
% "foreman"
% "news"
% "silent"
%
function[] = trainInterHuffmanTable(Q)
    %% Variable declaration
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
    intra_accummulated_mv_histogram = 0;
    intra_accummulated_mv_sum = 0;
    intra_accummulated_ef_histogram = 0;
    intra_accummulated_ef_sum = 0;
    intra_accummulated_demv_histogram = 0;
    intra_accummulated_demv_sum = 0;
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
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},false);
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
                [intra_demv_histogram , intra_demv_histogram_sum, ~,~] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},true);
                intra_accummulated_demv_histogram = intra_accummulated_demv_histogram + intra_demv_histogram;
                intra_accummulated_demv_sum = intra_accummulated_demv_sum + intra_demv_histogram_sum;
            case 1

                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_01 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},false);
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
                [intra_demv_histogram , intra_demv_histogram_sum, ~,~] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},true);
                intra_accummulated_demv_histogram = intra_accummulated_demv_histogram + intra_demv_histogram;
                intra_accummulated_demv_sum = intra_accummulated_demv_sum + intra_demv_histogram_sum;
            case 2

                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_02 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},false);
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
                [intra_demv_histogram , intra_demv_histogram_sum, ~,~] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},true);
                intra_accummulated_demv_histogram = intra_accummulated_demv_histogram + intra_demv_histogram;
                intra_accummulated_demv_sum = intra_accummulated_demv_sum + intra_demv_histogram_sum;
            case 3

                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_03 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},false);
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
                [intra_demv_histogram , intra_demv_histogram_sum, ~,~] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},true);
                intra_accummulated_demv_histogram = intra_accummulated_demv_histogram + intra_demv_histogram;
                intra_accummulated_demv_sum = intra_accummulated_demv_sum + intra_demv_histogram_sum;
            case 4
                for j = start_of_sequence : end_of_sequence
                    image_index = num2str(j,'%04d');
                    file_path = [directory_path file_04 image_index file_extension];
                    sequence{j - 19} = ictRGB2YCbCr(double(imread(file_path)));
                end
                [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},false);
                intra_accummulated_mv_histogram = intra_accummulated_mv_histogram + intra_mv_histogram;
                intra_accummulated_mv_sum = intra_accummulated_mv_sum + intra_mv_histogram_sum;
                intra_accummulated_ef_histogram = intra_accummulated_ef_histogram + intra_ef_histogram;
                intra_accummulated_ef_sum = intra_accummulated_ef_sum + intra_ef_histogram_sum;
                [intra_demv_histogram , intra_demv_histogram_sum, ~,~] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,sequence{2},sequence{1},true);
                intra_accummulated_demv_histogram = intra_accummulated_demv_histogram + intra_demv_histogram;
                intra_accummulated_demv_sum = intra_accummulated_demv_sum + intra_demv_histogram_sum;
        end
    end
    mv_histogram = intra_accummulated_mv_histogram / intra_accummulated_mv_sum;
    [inter_binary_tree_mv, inter_huff_code_mv, inter_bin_code_mv, inter_codelengths_mv] = buildHuffman(mv_histogram);
    bt_path = addQ2Path('video_codec/huffman_tables/inter_binary_tree_mv_00.mat',49,Q,false);
    save(bt_path, 'inter_binary_tree_mv');
    hc_path = addQ2Path('video_codec/huffman_tables/inter_huff_code_mv_00.mat',47,Q,false);
    save(hc_path, 'inter_huff_code_mv');
    bc_path = addQ2Path('video_codec/huffman_tables/inter_bin_code_mv_00.mat',46,Q,false);
    save(bc_path, 'inter_bin_code_mv');
    cl_path = addQ2Path('video_codec/huffman_tables/inter_codelengths_mv_00.mat',49,Q,false);
    save(cl_path, 'inter_codelengths_mv');
    ef_histogram = intra_accummulated_ef_histogram / intra_accummulated_ef_sum;
    [inter_binary_tree_ef, inter_huff_code_ef, inter_bin_code_ef, inter_codelengths_ef] = buildHuffman(ef_histogram);
    bt_path = addQ2Path('video_codec/huffman_tables/inter_binary_tree_ef_00.mat',49,Q,false);
    save(bt_path, 'inter_binary_tree_ef');
    hc_path = addQ2Path('video_codec/huffman_tables/inter_huff_code_ef_00.mat',47,Q,false);
    save(hc_path, 'inter_huff_code_ef');
    bc_path = addQ2Path('video_codec/huffman_tables/inter_bin_code_ef_00.mat',46,Q,false);
    save(bc_path, 'inter_bin_code_ef');
    cl_path = addQ2Path('video_codec/huffman_tables/inter_codelengths_ef_00.mat',49,Q,false);
    save(cl_path, 'inter_codelengths_ef');
    end_time = cputime - start_time;
    fprintf('Inter Huffman table training execution time equals: %d seconds.\n',end_time);
    demv_histogram = intra_accummulated_demv_histogram / intra_accummulated_demv_sum;
    [inter_binary_tree_mv, inter_huff_code_mv, inter_bin_code_mv, inter_codelengths_mv] = buildHuffman(demv_histogram);
    bt_path = addQ2Path('video_codec/huffman_tables/inter_binary_tree_mv_00.mat',49,Q,true);
    save(bt_path, 'inter_binary_tree_mv');
    hc_path = addQ2Path('video_codec/huffman_tables/inter_huff_code_mv_00.mat',47,Q,true);
    save(hc_path, 'inter_huff_code_mv');
    bc_path = addQ2Path('video_codec/huffman_tables/inter_bin_code_mv_00.mat',46,Q,true);
    save(bc_path, 'inter_bin_code_mv');
    cl_path = addQ2Path('video_codec/huffman_tables/inter_codelengths_mv_00.mat',49,Q,true);
    save(cl_path, 'inter_codelengths_mv');
end