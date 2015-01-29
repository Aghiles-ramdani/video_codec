clearvars

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% VARIABLE DECLARATION %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GOP_enabled = true;
Q = 5;
ycbcr_lowerbound = -128;
er_lowerbound = -255;
upperbound = 260;
mv_lowerbound = -4;
mv_upperbound = 4;
macroblock_dim = 8;
mv_search_range = 4;
bitrates = zeros(21,1);
psnrs = zeros(21,1);
gop = ['I' 'P' 'P' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B' 'B'];

%new_frames = zeros(288,352,3*21);
%intra_BinaryTree = importdata('data/huffman_codes/intra_encoding_binarytree.mat');
%intra_BinCode = importdata('data/huffman_codes/intra_encoding_bincode.mat');
%intra_Codelengths = importdata('data/huffman_codes/intra_encoding_codelengths.mat');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% LOADING FRAMES %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start = cputime;
for i = 0:20
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
    if GOP_enabled
        switch i
            case 0
                frames{1} = double(imread(file_path));
            case 10
                frames{2} = double(imread(file_path));
            case 20
                frames{3} = double(imread(file_path));
            otherwise
                if i < 10
                    frames{i+3} = double(imread(file_path));
                else
                    frames{i+2} = double(imread(file_path));
                end
        end
    else
        frames{i} = double(imread(file_path));
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
%%%%%%%%% LOAD HUFFMAN TABLE %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Intra matrices
intra_binary_tree = load('video_codec/huffman_tables/intra_binary_tree','-mat');
intra_binary_tree = intra_binary_tree.intra_binary_tree;
intra_bin_code = load('video_codec/huffman_tables/intra_bin_code','-mat');
intra_bin_code = intra_bin_code.intra_bin_code;
intra_codelengths = load('video_codec/huffman_tables/intra_codelengths','-mat');
intra_codelengths = intra_codelengths.intra_codelengths;
% P inter matrices
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
% P inter matrices
inter_b_binary_tree_ef = load('video_codec/huffman_tables/inter_b_binary_tree_ef','-mat');
inter_b_binary_tree_ef = inter_b_binary_tree_ef.inter_b_binary_tree_ef;
inter_b_bin_code_ef = load('video_codec/huffman_tables/inter_b_bin_code_ef','-mat');
inter_b_bin_code_ef = inter_b_bin_code_ef.inter_b_bin_code_ef;
inter_b_codelengths_ef = load('video_codec/huffman_tables/inter_b_codelengths_ef','-mat');
inter_b_codelengths_ef = inter_b_codelengths_ef.inter_b_codelengths_ef;
inter_b_binary_tree_mv = load('video_codec/huffman_tables/inter_b_binary_tree_mv','-mat');
inter_b_binary_tree_mv = inter_b_binary_tree_mv.inter_b_binary_tree_mv;
inter_b_bin_code_mv = load('video_codec/huffman_tables/inter_b_bin_code_mv','-mat');
inter_b_bin_code_mv = inter_b_bin_code_mv.inter_b_bin_code_mv;
inter_b_codelengths_mv = load('video_codec/huffman_tables/inter_b_codelengths_mv','-mat');
inter_b_codelengths_mv = inter_b_codelengths_mv.inter_b_codelengths_mv;
%% INTRA CODING OF FIRST FRAME


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% INTER ENCODING %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start = cputime;
for i = 1:21
    current_frame = frames{i};
    if gop(i) == 'I'
    %% I FRAME
        ycbcr_reference_frame = ictRGB2YCbCr(current_frame);
        [ycbcr_decoded_frame,intra_encoded_frame] = IntraEncodeFrame(ycbcr_reference_frame,intra_binary_tree, intra_bin_code, intra_codelengths, Q,ycbcr_lowerbound);
        psnrs(1) = calculatePSNR(8,current_frame,ictYCbCr2RGB(ycbcr_decoded_frame));
        bitrates(1) = calculateBitrate(frames{1},intra_encoded_frame);
        ycbcr_i_frame = ycbcr_decoded_frame;
    elseif gop(i) == 'P'
        %% P FRAMES
        ycbcr_current_frame = ictRGB2YCbCr(current_frame);
        ycbcr_reference_frame = ycbcr_decoded_frame;
        %% MOTION ESTIMATION
        clear ycbcr_predicted_frame
        [ycbcr_predicted_frame,motion_matrix]=InterEncodeFrame(macroblock_dim,mv_search_range,ycbcr_current_frame,ycbcr_reference_frame);
        
        %% ERROR CALCULATION
        ycbcr_prediction_error_frame=ycbcr_current_frame-ycbcr_predicted_frame;

        %% INTRA CODING OF ERROR FRAME
        [ycbcr_decoded_error_frame,huffman_error_stream]=IntraEncodeFrame(ycbcr_prediction_error_frame,inter_binary_tree_ef,inter_bin_code_ef,inter_codelengths_ef,Q,er_lowerbound);

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
        if i == 2
            ycbcr_p_0_frame = ycbcr_recovered_frame;
            psnrs(2) = calculatePSNR(8,current_frame,ictYCbCr2RGB(ycbcr_recovered_frame));
            bitrates(2) = calculateBitrate(current_frame,[huffman_mv ; huffman_error_stream]);
        elseif i == 3
            ycbcr_p_1_frame = ycbcr_recovered_frame;
            psnrs(3) = calculatePSNR(8,current_frame,ictYCbCr2RGB(ycbcr_recovered_frame));
            bitrates(3) = calculateBitrate(current_frame,[huffman_mv ; huffman_error_stream]);
        end
        ycbcr_decoded_frame = ycbcr_recovered_frame;
    elseif gop(i) == 'B'
        %% B FRAMES
        ycbcr_current_frame = ictRGB2YCbCr(current_frame);
        if i <= 12
            ycbcr_reference_0_frame = ycbcr_i_frame;
            ycbcr_reference_1_frame = ycbcr_p_0_frame;
        else
            ycbcr_reference_0_frame = ycbcr_p_0_frame;
            ycbcr_reference_1_frame = ycbcr_p_1_frame;
        end
        %% MOTION ESTIMATION
        clear ycbcr_predicted_frame
        [ycbcr_predicted_frame,motion_matrix]=BidirectionalInterEncodeFrame(macroblock_dim,mv_search_range,ycbcr_reference_1_frame,ycbcr_current_frame,ycbcr_reference_0_frame);
        
        %% ERROR CALCULATION
        ycbcr_prediction_error_frame=ycbcr_current_frame-ycbcr_predicted_frame;

        %% INTRA CODING OF ERROR FRAME
        [ycbcr_decoded_error_frame,huffman_error_stream] = IntraEncodeFrame(ycbcr_prediction_error_frame,inter_b_binary_tree_ef,inter_b_bin_code_ef,inter_b_codelengths_ef, Q,er_lowerbound);

        %% HUFFMAN CODING OF MV
        [huffman_mv] = enc_huffman_new(motion_matrix+mv_search_range+1,inter_b_bin_code_mv,inter_b_codelengths_mv);

        %% DECODING
        decoded_mv = dec_huffman_new(huffman_mv,inter_b_binary_tree_mv,max(size(motion_matrix(:)))) - 4 - 1;
        new_decoded_image_mv_00 = decoded_mv(1:36*44);
        new_decoded_image_mv_01 = decoded_mv(36*44+1:2*36*44);
        new_decoded_image_mv_02 = decoded_mv(2*36*44+1:3*36*44);
        reshaped_mv(:,:,1) = reshape (new_decoded_image_mv_00,36,44);
        reshaped_mv(:,:,2) = reshape (new_decoded_image_mv_01,36,44);
        reshaped_mv(:,:,3) = reshape (new_decoded_image_mv_02,36,44);

        %% MOTION COMPENSATION
        clear ycbcr_predicted_frame
        ycbcr_predicted_frame = BidirectionalMotionCompensation(ycbcr_reference_1_frame,ycbcr_reference_0_frame,reshaped_mv,macroblock_dim);
        ycbcr_recovered_frame = ycbcr_predicted_frame + ycbcr_decoded_error_frame;
        
        psnrs(i) = calculatePSNR(8,current_frame,ictYCbCr2RGB(ycbcr_recovered_frame));
        bitrates(i) = calculateBitrate(current_frame,[huffman_mv ; huffman_error_stream]);
        ycbcr_decoded_frame = ycbcr_recovered_frame;
    end
end
inter_processing_duration = cputime - start
new_mean_bitrate = mean(bitrates)
new_mean_psnr = mean(psnrs)