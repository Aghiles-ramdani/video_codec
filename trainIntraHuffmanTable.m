%% Huffman table training for I frames
% 
% This function generates the Huffman table necessaries for a video coder
% for intra prediction using the motion sequences:
%
% "akiyo"
% "coastguard"
% "foreman"
% "news"
% "silent"
%
start_time = cputime;
directory_path = 'data/images/';
file_extension = '.bmp';
file_00 = 'akiyo';
file_01 = 'coastguard';
file_02 = 'foreman';
file_03 = 'news';
file_04 = 'silent';
intra_accumulated_sum = 0;
intra_accumulated_pdf = 0;
start_of_sequence = 20;
end_of_sequence = 40;
Q = 5;
%% 
% Read all the frames, calculate their histogram and accumulate the
% calculate all the histograms while simultaneously generating a
% summation of histogram bin values accross all the frames. Finally
% produce the global pdf and generate the Huffman table.
%
for i = 0:4
    switch i
        case 0
            for j = start_of_sequence : end_of_sequence
                image_index = num2str(j,'%04d');
                file_path = [directory_path file_00 image_index file_extension];
                [summation , pdf] = intraCodingStatistics(file_path,Q);
                intra_accumulated_sum = intra_accumulated_sum + summation;
                intra_accumulated_pdf = intra_accumulated_pdf + pdf;
            end
        case 1
            for j = start_of_sequence : end_of_sequence
                image_index = num2str(j,'%04d');
                file_path = [directory_path file_01 image_index file_extension];
                [summation , pdf] = intraCodingStatistics(file_path,Q);
                intra_accumulated_sum = intra_accumulated_sum + summation;
                intra_accumulated_pdf = intra_accumulated_pdf + pdf;
            end
        case 2
            for j = start_of_sequence : end_of_sequence
                image_index = num2str(j,'%04d');
                file_path = [directory_path file_02 image_index file_extension];
                [summation , pdf] = intraCodingStatistics(file_path,Q);
                intra_accumulated_sum = intra_accumulated_sum + summation;
                intra_accumulated_pdf = intra_accumulated_pdf + pdf;
            end
        case 3
            for j = start_of_sequence : end_of_sequence
                image_index = num2str(j,'%04d');
                file_path = [directory_path file_03 image_index file_extension];
                [summation , pdf] = intraCodingStatistics(file_path,Q);
                intra_accumulated_sum = intra_accumulated_sum + summation;
                intra_accumulated_pdf = intra_accumulated_pdf + pdf;
            end
        case 4
            for j = start_of_sequence : end_of_sequence
                image_index = num2str(j,'%04d');
                file_path = [directory_path file_04 image_index file_extension];
                [summation , pdf] = intraCodingStatistics(file_path,Q);
                intra_accumulated_sum = intra_accumulated_sum + summation;
                intra_accumulated_pdf = intra_accumulated_pdf + pdf;
            end
    end
end
histogram = intra_accumulated_pdf / intra_accumulated_sum;
[intra_binary_tree, intra_huffman_code, intra_bin_code, intra_codelengths] = buildHuffman(histogram);
save('video_codec/huffman_tables/intra_binary_tree.mat', 'intra_binary_tree');
save('video_codec/huffman_tables/intra_huff_code.mat', 'intra_huffman_code');
save('video_codec/huffman_tables/intra_bin_code.mat', 'intra_bin_code');
save('video_codec/huffman_tables/intra_codelengths.mat', 'intra_codelengths');
end_time = cputime - start_time;
fprintf('Intra Huffman table training execution time equals: %d seconds.\n',end_time);