clearvars

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% VARIABLE DECLARATION %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q = 5;
ycbcr_lowerbound = -128;
ef_lowerbound = -255;
ef_upperbound = 260;
upperbound = 260;
mv_lowerbound = -4;
mv_upperbound = 4;
macroblock_dim = 8;
mv_search_range = 4;
gop = ['I' 'P' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B'];
intra_b_mv_histogram = 0;
intra_b_ef_histogram = 0;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% LOADING FRAMES %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start = cputime;
for i = 0:10
    image_index = i + 20;
    file_path = 'data/images/foreman0020.bmp';
    % foreman index0 = 22
    % coastguard index0 = 25
    % silent index0 = 21
    % news index0 = 19
    % akiyo index0 = 20
    path_index = 22;
    image_index = num2str(image_index,'%02d');
    file_path(path_index) = image_index(1);
    file_path(path_index + 1) = image_index(2);
    switch i
        case 0
            frames{1} = double(imread(file_path));
        case 10
            frames{2} = double(imread(file_path));
        otherwise
            frames{i+2} = double(imread(file_path));
    end
end

dimensions = size(frames{1});
length_ = dimensions(2);
height_ = dimensions(1);
image_loading_duration = cputime - start
%% CLEARING OF UNUSED VARIABLES
clear file_path
clear index
clear image_index
clear path_index
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% LOAD HUFFMAN TABLES %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intra_binary_tree = load('video_codec/huffman_tables/intra_binary_tree','-mat');
intra_binary_tree = intra_binary_tree.intra_binary_tree;
intra_bin_code = load('video_codec/huffman_tables/intra_bin_code','-mat');
intra_bin_code = intra_bin_code.intra_bin_code;
intra_codelengths = load('video_codec/huffman_tables/intra_codelengths','-mat');
intra_codelengths = intra_codelengths.intra_codelengths;
inter_binary_tree_ef = load('video_codec/huffman_tables/inter_binary_tree_ef','-mat');
inter_binary_tree_ef = inter_binary_tree_ef.inter_binary_tree_ef;
inter_bin_code_ef = load('video_codec/huffman_tables/inter_bin_code_ef','-mat');
inter_bin_code_ef = inter_bin_code_ef.inter_bin_code_ef;
inter_codelengths_ef = load('video_codec/huffman_tables/inter_codelengths_ef','-mat');
inter_codelengths_ef = inter_codelengths_ef.inter_codelengths_ef;
inter_binary_tree_mv = load('video_codec/huffman_tables/inter_binary_tree_mv','-mat');
inter_binary_tree_mv = inter_binary_tree_mv.inter_binary_tree_mv;
inter_bin_code_mv = load('video_codec/huffman_tables/inter_bin_code_mv','-mat');
inter_bin_code_mv = inter_bin_code_mv.inter_bin_code_mv;
inter_codelengths_mv = load('video_codec/huffman_tables/inter_codelengths_mv','-mat');
inter_codelengths_mv = inter_codelengths_mv.inter_codelengths_mv;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% ENCODING PROCESS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start = cputime;
for i = 1:11
    current_frame = frames{i};
    if gop(i) == 'I'
    %% INTRA CODING
        ycbcr_reference_frame = ictRGB2YCbCr(current_frame);
        [ycbcr_decoded_frame,intra_encoded_frame] = IntraEncodeFrame(ycbcr_reference_frame,intra_binary_tree, intra_bin_code, intra_codelengths, Q,ycbcr_lowerbound);
        ycbcr_i_frame = ycbcr_decoded_frame;
    elseif gop(i) == 'P'
        %% INTER CODING P FRAME
        ycbcr_current_frame = ictRGB2YCbCr(current_frame);
        ycbcr_reference_frame = ycbcr_decoded_frame;
        %% MOTION ESTIMATION
        clear ycbcr_predicted_frame
        [ycbcr_predicted_frame,motion_matrix]=InterEncodeFrame(macroblock_dim,mv_search_range,ycbcr_current_frame,ycbcr_reference_frame);

        %% ERROR CALCULATION
        ycbcr_prediction_error_frame=ycbcr_current_frame-ycbcr_predicted_frame;

        %% INTRA CODING OF ERROR FRAME
        [ycbcr_decoded_error_frame,huffman_error_stream]=IntraEncodeFrame(ycbcr_prediction_error_frame,inter_binary_tree_ef,inter_bin_code_ef,inter_codelengths_ef,Q,ef_lowerbound);

        %% HUFFMAN CODING OF MV
        [huffman_mv]=enc_huffman_new(motion_matrix+mv_search_range+1,inter_bin_code_mv,inter_codelengths_mv);

        %% DECODING
        decoded_mv=dec_huffman_new(huffman_mv,inter_binary_tree_mv,max(size(motion_matrix(:))))-4-1;
        new_decoded_image_mv_00=decoded_mv(1:36*44);
        new_decoded_image_mv_01=decoded_mv(36*44+1:2*36*44);
        reshaped_mv(:,:,1)=reshape(new_decoded_image_mv_00,36,44);
        reshaped_mv(:,:,2)=reshape(new_decoded_image_mv_01,36,44);

        %% MOTION COMPENSATION
        clear ycbcr_predicted_frame
        ycbcr_predicted_frame = motionCompensation(ycbcr_reference_frame,reshaped_mv,macroblock_dim);
        ycbcr_recovered_frame = ycbcr_predicted_frame + ycbcr_decoded_error_frame;
        
        ycbcr_p_frame = ycbcr_recovered_frame;
        ycbcr_decoded_frame = ycbcr_recovered_frame;
    elseif gop(i) == 'B'
        ycbcr_current_frame = ictRGB2YCbCr(current_frame);
        ycbcr_reference_0_frame = ycbcr_i_frame;
        ycbcr_reference_1_frame = ycbcr_p_frame;
        %% MOTION ESTIMATION
        clear ycbcr_predicted_frame
        [ycbcr_predicted_frame,motion_matrix]=BidirectionalInterEncodeFrame(macroblock_dim,mv_search_range,ycbcr_reference_1_frame,ycbcr_current_frame,ycbcr_reference_0_frame);
        
        %% ERROR CALCULATION
        ycbcr_prediction_error_frame=ycbcr_current_frame-ycbcr_predicted_frame;
        
        intra_b_mv_histogram = intra_b_mv_histogram + hist(motion_matrix(:),-mv_search_range:mv_search_range);
        intra_b_ef_histogram = intra_b_ef_histogram + hist(ycbcr_prediction_error_frame,ef_lowerbound:ef_upperbound);
    end
end
inter_processing_duration = cputime - start

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% TABLE SAVING %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

intra_mv_histogram_sum = sum(sum(intra_b_mv_histogram));
intra_b_mv_histogram = intra_b_mv_histogram / intra_mv_histogram_sum;
[inter_b_binary_tree_mv, inter_b_huff_code_mv, inter_b_bin_code_mv, inter_b_codelengths_mv] = buildHuffman(intra_b_mv_histogram);
save('video_codec/huffman_tables/inter_b_binary_tree_mv.mat', 'inter_b_binary_tree_mv');
save('video_codec/huffman_tables/inter_b_huff_code_mv.mat', 'inter_b_huff_code_mv');
save('video_codec/huffman_tables/inter_b_bin_code_mv.mat', 'inter_b_bin_code_mv');
save('video_codec/huffman_tables/inter_b_codelengths_mv.mat', 'inter_b_codelengths_mv');
intra_ef_histogram_sum = sum(intra_b_ef_histogram);
intra_b_ef_histogram = intra_b_ef_histogram / intra_ef_histogram_sum;
[inter_b_binary_tree_ef, inter_b_huff_code_ef, inter_b_bin_code_ef, inter_b_codelengths_ef] = buildHuffman(intra_b_ef_histogram);
save('video_codec/huffman_tables/inter_b_binary_tree_ef.mat', 'inter_b_binary_tree_ef');
save('video_codec/huffman_tables/inter_b_huff_code_ef.mat', 'inter_b_huff_code_ef');
save('video_codec/huffman_tables/inter_b_bin_code_ef.mat', 'inter_b_bin_code_ef');
save('video_codec/huffman_tables/inter_b_codelengths_ef.mat', 'inter_b_codelengths_ef');