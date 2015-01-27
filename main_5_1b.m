clearvars

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% VARIABLE DECLARATION %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%new_frames = zeros(288,352,3*21);
%intra_BinaryTree = importdata('data/huffman_codes/intra_encoding_binarytree.mat');
%intra_BinCode = importdata('data/huffman_codes/intra_encoding_bincode.mat');
%intra_Codelengths = importdata('data/huffman_codes/intra_encoding_codelengths.mat');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% LOADING FRAMES %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start = cputime;
for i = 1:20
    index = 3*i+1;
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
    frames{i} = double(imread(file_path));
%     new_ycbcr_frames(:,:,index:index+2) = ictRGB2YCbCr(new_frames(:,:,index:index+2));
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
%%%%%%% PRODUCE HUFFMAN TABLE %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reference_frame = double(imread('data/images/foreman0020.bmp'));
ycbcr_reference_frame = ictRGB2YCbCr(reference_frame);
[intra_BinaryTree, intra_BinCode, intra_Codelengths] = ProduceIntraEncodeHuffmanTable(Q,ycbcr_lowerbound,upperbound);
%% INTRA CODING OF FIRST FRAME
[decoded_ycbcr_frame,intra_encoded_frame] = IntraEncodeFrame(ycbcr_reference_frame,intra_BinaryTree, intra_BinCode, intra_Codelengths, Q,ycbcr_lowerbound);
psnrs(1) = calculatePSNR(8,(reference_frame),ictYCbCr2RGB(decoded_ycbcr_frame));
bitrates(1) = calculateBitrate(frames{1},intra_encoded_frame);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% INTER ENCODING %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start = cputime;
for i = 1:20
    current_frame = frames{i};
    ycbcr_current_frame = ictRGB2YCbCr(current_frame);
    ycbcr_reference_frame = decoded_ycbcr_frame;
    %% MOTION ESTIMATION
    clear ycbcr_predicted_frame
    [ycbcr_predicted_frame,motion_matrix]=InterEncodeFrame(macroblock_dim,mv_search_range,ycbcr_current_frame,ycbcr_reference_frame);
    %% ERROR CALCULATION
    ycbcr_prediction_error_frame=ycbcr_current_frame-ycbcr_predicted_frame;
    %% HUFFMAN TABLES TRAINING
    if(i == 1)
        [BinaryTree_mv,BinCode_mv,Codelengths_mv] = ProduceHuffmanTable(motion_matrix,mv_lowerbound,mv_upperbound);
        stream = preEncodeIntraProcess(ycbcr_prediction_error_frame,1);
        [BinaryTree_er,BinCode_er,Codelengths_er] = ProduceHuffmanTable(stream,er_lowerbound,upperbound);
    end
    
    %% INTRA CODING OF ERROR FRAME
    [ycbcr_decoded_error_frame,huffman_error_stream] = IntraEncodeFrame(ycbcr_prediction_error_frame,BinaryTree_er,BinCode_er,Codelengths_er, Q,er_lowerbound);
    
    %% HUFFMAN CODING OF MV
    [huffman_mv] = enc_huffman_new(motion_matrix+mv_search_range+1,BinCode_mv,Codelengths_mv);
        
    %% DECODING
    decoded_mv = dec_huffman_new(huffman_mv,BinaryTree_mv,max(size(motion_matrix(:)))) - 4 - 1;
    new_decoded_image_mv_00 = decoded_mv(1:36*44);
    new_decoded_image_mv_01 = decoded_mv(36*44+1:2*36*44);
    reshaped_mv(:,:,1) = reshape (new_decoded_image_mv_00,36,44);
    reshaped_mv(:,:,2) = reshape (new_decoded_image_mv_01,36,44);
    
    %% MOTION COMPENSATION
    
    clear ycbcr_predicted_frame
    ycbcr_predicted_frame = motionCompensation(ycbcr_reference_frame,reshaped_mv,macroblock_dim);
    ycbcr_filtered_frame = ycbcr_predicted_frame;
    %% -------------------- DEBLOCKING FILTERING --------------------------
    for row = 1 : macroblock_dim : dimensions(1)
        for column = 1 : macroblock_dim : dimensions(2)
            if row < height_ - 8 && column < length_ - 8
                block = ycbcr_predicted_frame(row:row+3*macroblock_dim/2,column:column+3*macroblock_dim/2,1:3);
                filtered_block = block;
                %--------------------- HORIZONTAL EDGE --------------------
                for c = 1 : macroblock_dim
                    a_row = 7;
                    b_row = 8;
                    c_row = 9;
                    d_row = 10;
                    A = block(a_row:a_row+3,c,:);
                    B = block(b_row:b_row+3,c,:);
                    C = block(c_row:c_row+3,c,:);
                    D = block(d_row:d_row+3,c,:);
                    [A_new,B_new,C_new,D_new] = smoothEdge(A,B,C,D);
                    filtered_block(a_row,c,:) = A_new;
                    filtered_block(b_row,c,:) = B_new;
                    filtered_block(c_row,c,:) = C_new;
                    filtered_block(d_row,c,:) = D_new;
                end
                %--------------------- VERTICAL EDGE ----------------------
                for r = 1 : macroblock_dim
                    a_col = 7;
                    b_col = 8;
                    c_col = 9;
                    d_col = 10;
                    A = filtered_block(r,a_col:a_col+3,:);
                    B = filtered_block(r,b_col:b_col+3,:);
                    C = filtered_block(r,c_col:c_col+3,:);
                    D = filtered_block(r,d_col:d_col+3,:);
                    [A_new,B_new,C_new,D_new] = smoothEdge(A,B,C,D);
                    filtered_block(r,a_col,:) = A_new;
                    filtered_block(r,b_col,:) = B_new;
                    filtered_block(r,c_col,:) = C_new;
                    filtered_block(r,d_col,:) = D_new;
                end
                ycbcr_filtered_frame(row+macroblock_dim-2:row+3*macroblock_dim/2-1-2,column:column+macroblock_dim-1,1:3) = filtered_block(1+macroblock_dim-2:3*macroblock_dim/2-2,1:macroblock_dim,1:3);
                ycbcr_filtered_frame(row:row+macroblock_dim-1,column+macroblock_dim-2:column+3*macroblock_dim/2-1-2,1:3) = filtered_block(1:macroblock_dim,1+macroblock_dim-2:3*macroblock_dim/2-2,1:3);
            elseif column == length_-8+1 && row ~= height_-8+1
                block = ycbcr_predicted_frame(row:row+3*macroblock_dim/2,column:column+macroblock_dim-1,1:3);
                filtered_block = block;
                %--------------------- HORIZONTAL EDGE --------------------
                for c = 1 : macroblock_dim
                    a_row = 7;
                    b_row = 8;
                    c_row = 9;
                    d_row = 10;
                    A = block(a_row:a_row+3,c,:);
                    B = block(b_row:b_row+3,c,:);
                    C = block(c_row:c_row+3,c,:);
                    D = block(d_row:d_row+3,c,:);
                    [A_new,B_new,C_new,D_new] = smoothEdge(A,B,C,D);
                    filtered_block(a_row,c,:) = A_new;
                    filtered_block(b_row,c,:) = B_new;
                    filtered_block(c_row,c,:) = C_new;
                    filtered_block(d_row,c,:) = D_new;
                end
                ycbcr_filtered_frame(row+macroblock_dim-2:row+3*macroblock_dim/2-1-2,column:column+macroblock_dim-1,1:3) = filtered_block(1+macroblock_dim-2:3*macroblock_dim/2-2,1:macroblock_dim,1:3);
            elseif column ~= length_-8+1 && row == height_-8+1
                block = ycbcr_predicted_frame(row:row+macroblock_dim-1,column:column+3*macroblock_dim/2,1:3);
                filtered_block = block;
                %--------------------- VERTICAL EDGE ----------------------
                for r = 1 : macroblock_dim
                    a_col = 7;
                    b_col = 8;
                    c_col = 9;
                    d_col = 10;
                    A = filtered_block(r,a_col:a_col+3,:);
                    B = filtered_block(r,b_col:b_col+3,:);
                    C = filtered_block(r,c_col:c_col+3,:);
                    D = filtered_block(r,d_col:d_col+3,:);
                    [A_new,B_new,C_new,D_new] = smoothEdge(A,B,C,D);
                    filtered_block(r,a_col,:) = A_new;
                    filtered_block(r,b_col,:) = B_new;
                    filtered_block(r,c_col,:) = C_new;
                    filtered_block(r,d_col,:) = D_new;
                end
                ycbcr_filtered_frame(row:row+macroblock_dim-1,column+macroblock_dim-2:column+3*macroblock_dim/2-1-2,1:3) = filtered_block(1:macroblock_dim,1+macroblock_dim-2:3*macroblock_dim/2-2,1:3);
            end
        end
    end
    
    %
    
    ycbcr_recovered_frame = ycbcr_predicted_frame + ycbcr_decoded_error_frame;
    
    psnrs(i + 1) = calculatePSNR(8,current_frame,ictYCbCr2RGB(ycbcr_recovered_frame));
    bitrates(i + 1) = calculateBitrate(current_frame,[huffman_mv ; huffman_error_stream]);
    decoded_ycbcr_frame = ycbcr_recovered_frame;
    
end
inter_processing_duration = cputime - start
new_mean_bitrate = mean(bitrates)
new_mean_psnr = mean(psnrs)