function[] = EncodeVideo(Q,GOP_enabled)
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%% VARIABLE DECLARATION %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ycbcr_lowerbound = -128;
    ef_lowerbound = -255;
    macroblock_dim = 8;
    mv_search_range = 4;
    bitrates = zeros(21,1);
    psnrs = zeros(21,1);
    gop = ['I' 'B' 'B' 'P' 'B' 'B' 'P' 'B' 'B' 'P' 'B' 'B' 'P' 'B' 'B' 'P' 'B' 'B' 'P' 'B' 'P'];
    sequence_length = length(gop);
    progress_marker = '=====';
    progress_bar = '';
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% LOADING FRAMES %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    loading_start = cputime;
    i_count = 0;
    p_count = 0;
    b_count = 0;
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
            if gop(i+1) == 'I'
                i_count = i_count + 1;
                i_frames{i_count} = double(imread(file_path));
                i_tags{i_count} = gop(i+1);
            elseif gop(i+1) == 'P'
                p_count = p_count + 1;
                p_frames{p_count} = double(imread(file_path));
                p_tags{p_count} = gop(i+1);
            elseif gop(i+1) == 'B'
                b_count = b_count + 1;
                b_frames{b_count} = double(imread(file_path));
                b_tags{b_count} = gop(i+1);
            end
        else
            frames{i+1} = double(imread(file_path));
        end
    end

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% REORDERING FRAMES %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    frames = interweave(i_frames,p_frames,b_frames);
    tags = interweave(i_tags,p_tags,b_tags);
    dimensions = size(frames{1});
    length_ = dimensions(2);
    height_ = dimensions(1);
    image_loading_duration = cputime - loading_start;
    fprintf('Image loading time: %fs.\n',image_loading_duration);
    %% CLEARING OF UNUSED VARIABLES
    clear file_path
    clear index
    clear image_index
    clear path_index
    clear i_count
    clear p_count
    clear b_count
    clear i_frames
    clear p_frames
    clear b_frames

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% INTRA HUFFMAN LOAD %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bt_path = addQ2Path('video_codec/huffman_tables/intra_binary_tree_00',46,Q);
    intra_binary_tree = load(bt_path,'-mat');
    intra_binary_tree = intra_binary_tree.intra_binary_tree;
    bc_path = addQ2Path('video_codec/huffman_tables/intra_bin_code_00',43,Q);
    intra_bin_code = load(bc_path,'-mat');
    intra_bin_code = intra_bin_code.intra_bin_code;
    cl_path = addQ2Path('video_codec/huffman_tables/intra_codelengths_00',46,Q);
    intra_codelengths = load(cl_path,'-mat');
    intra_codelengths = intra_codelengths.intra_codelengths;
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% INTER HUFFMAN LOAD %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bt_path = addQ2Path('video_codec/huffman_tables/inter_binary_tree_ef_00',49,Q);
    inter_binary_tree_ef = load(bt_path,'-mat');
    inter_binary_tree_ef = inter_binary_tree_ef.inter_binary_tree_ef;
    bc_path = addQ2Path('video_codec/huffman_tables/inter_bin_code_ef_00',46,Q);
    inter_bin_code_ef = load(bc_path,'-mat');
    inter_bin_code_ef = inter_bin_code_ef.inter_bin_code_ef;
    cl_path = addQ2Path('video_codec/huffman_tables/inter_codelengths_ef_00',49,Q);
    inter_codelengths_ef = load(cl_path,'-mat');
    inter_codelengths_ef = inter_codelengths_ef.inter_codelengths_ef;
    bt_path = addQ2Path('video_codec/huffman_tables/inter_binary_tree_mv_00',49,Q);
    inter_binary_tree_mv = load(bt_path,'-mat');
    inter_binary_tree_mv = inter_binary_tree_mv.inter_binary_tree_mv;
    bc_path = addQ2Path('video_codec/huffman_tables/inter_bin_code_mv_00',46,Q);
    inter_bin_code_mv = load(bc_path,'-mat');
    inter_bin_code_mv = inter_bin_code_mv.inter_bin_code_mv;
    cl_path = addQ2Path('video_codec/huffman_tables/inter_codelengths_mv_00',49,Q);
    inter_codelengths_mv = load(cl_path,'-mat');
    inter_codelengths_mv = inter_codelengths_mv.inter_codelengths_mv;
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% BINTER HUFFMAN LOAD %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bt_path = addQ2Path('video_codec/huffman_tables/inter_b_binary_tree_mv_00',51,Q);
    inter_b_binary_tree_mv = load(bt_path,'-mat');
    inter_b_binary_tree_mv = inter_b_binary_tree_mv.inter_b_binary_tree_mv;
    bc_path = addQ2Path('video_codec/huffman_tables/inter_b_bin_code_mv_00',48,Q);
    inter_b_bin_code_mv = load(bc_path,'-mat');
    inter_b_bin_code_mv = inter_b_bin_code_mv.inter_b_bin_code_mv;
    cl_path = addQ2Path('video_codec/huffman_tables/inter_b_codelengths_mv_00',51,Q);
    inter_b_codelengths_mv = load(cl_path,'-mat');
    inter_b_codelengths_mv = inter_b_codelengths_mv.inter_b_codelengths_mv;
    bt_path = addQ2Path('video_codec/huffman_tables/inter_b_binary_tree_ef_00',51,Q);
    inter_b_binary_tree_ef = load(bt_path,'-mat');
    inter_b_binary_tree_ef = inter_b_binary_tree_ef.inter_b_binary_tree_ef;
    bc_path = addQ2Path('video_codec/huffman_tables/inter_b_bin_code_ef_00',48,Q);
    inter_b_bin_code_ef = load(bc_path,'-mat');
    inter_b_bin_code_ef = inter_b_bin_code_ef.inter_b_bin_code_ef;
    cl_path = addQ2Path('video_codec/huffman_tables/inter_b_codelengths_ef_00',51,Q);
    inter_b_codelengths_ef = load(cl_path,'-mat');
    inter_b_codelengths_ef = inter_b_codelengths_ef.inter_b_codelengths_ef;


    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% INTER ENCODING %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inter_start = cputime;
    for i = 1:21
        sub_start = cputime;
        current_frame = frames{i};
        ycbcr_current_frame = ictRGB2YCbCr(current_frame);
        if tags{i} == 'I'
        %% I FRAME
            [ycbcr_decoded_frame,intra_encoded_frame] = IntraEncodeFrame(ycbcr_current_frame,intra_binary_tree, intra_bin_code, intra_codelengths, Q,ycbcr_lowerbound);
            psnrs(1) = calculatePSNR(8,current_frame,ictYCbCr2RGB(ycbcr_decoded_frame));
            bitrates(1) = calculateBitrate(current_frame,intra_encoded_frame);
            ycbcr_reference_frame_0 = ycbcr_decoded_frame;
        elseif tags{i} == 'P'
            %% P FRAMES
            %% MOTION ESTIMATION
            [ycbcr_predicted_frame,motion_matrix]=InterEncodeFrame(macroblock_dim,mv_search_range,ycbcr_current_frame,ycbcr_reference_frame_0);

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
            ycbcr_predicted_frame = motionCompensation(ycbcr_reference_frame_0,reshaped_mv,macroblock_dim);

            ycbcr_recovered_frame = ycbcr_predicted_frame + ycbcr_decoded_error_frame;

            psnrs(i) = calculatePSNR(8,current_frame,ictYCbCr2RGB(ycbcr_recovered_frame));
            bitrates(i) = calculateInterErrorBitrate(current_frame,0,[huffman_error_stream ; huffman_mv]);
            ycbcr_reference_frame_1=ycbcr_recovered_frame;
        elseif tags{i} == 'B'
            %% MOTION ESTIMATION
            [ycbcr_predicted_frame,motion_matrix]=BidirectionalInterEncodeFrame(macroblock_dim,mv_search_range,ycbcr_reference_frame_1,ycbcr_current_frame,ycbcr_reference_frame_0);

            %% ERROR CALCULATION
            ycbcr_prediction_error_frame=ycbcr_current_frame-ycbcr_predicted_frame;

            %% INTRA CODING OF ERROR FRAME
            [ycbcr_decoded_error_frame,huffman_error_stream] = IntraEncodeFrame(ycbcr_prediction_error_frame,inter_b_binary_tree_ef,inter_b_bin_code_ef,inter_b_codelengths_ef,4+Q,ef_lowerbound);

            %% HUFFMAN CODING OF MV
            [huffman_mv] = enc_huffman_new(motion_matrix(:,:,1:2)+mv_search_range+1,inter_b_bin_code_mv,inter_b_codelengths_mv);
            mm_length = motion_matrix(:,:,1:2);
            mm_length = length(mm_length(:));
            %% DECODING
            decoded_mv = dec_huffman_new(huffman_mv,inter_b_binary_tree_mv,mm_length) - 4 - 1;
            new_decoded_image_mv_00 = decoded_mv(1:36*44);
            new_decoded_image_mv_01 = decoded_mv(36*44+1:2*36*44);
            reshaped_mv(:,:,1) = reshape (new_decoded_image_mv_00,36,44);
            reshaped_mv(:,:,2) = reshape (new_decoded_image_mv_01,36,44);
            reshaped_mv(:,:,3) = motion_matrix(:,:,3);

            %% MOTION COMPENSATION
            ycbcr_predicted_frame = BidirectionalMotionCompensation(ycbcr_reference_frame_1,ycbcr_reference_frame_0,reshaped_mv,macroblock_dim);
            ycbcr_recovered_frame = ycbcr_predicted_frame + ycbcr_decoded_error_frame;

            psnrs(i) = calculatePSNR(8,current_frame,ictYCbCr2RGB(ycbcr_recovered_frame));
            bitrates(i) = calculateInterErrorBitrate(current_frame,motion_matrix(:,:,3),[huffman_error_stream ; huffman_mv]);
            if i + 1 <= sequence_length
                if tags{i+1} == 'P'
                    ycbcr_reference_frame_0 = ycbcr_reference_frame_1;
                end
            end
        end
        clc
        fprintf('Image loading time: %fs.\n',image_loading_duration);
        progress_bar = strcat(progress_bar,progress_marker);
        clear current_progress_bar
        if i < 21
            current_progress_bar = strcat(progress_bar,'>\n');
        else
            current_progress_bar = strcat(progress_bar,'|\n');
        end
        fprintf(current_progress_bar);
        progress = 100*i/21;
        fprintf('%f%%\n',progress);
        frame_processing_duration = cputime - sub_start;
        fprintf('Frame processing time: %fs.\n',frame_processing_duration);
        inter_processing_duration = cputime - inter_start;
        fprintf('Process duration: %fs.\n',inter_processing_duration);
    end
    mean_bitrate = mean(bitrates);
    mean_psnr = mean(psnrs);
    fprintf('Mean bit rate: %fbpp.\n',mean_bitrate);
    fprintf('Mean PSNR: %fdB.\n',mean_psnr);
end