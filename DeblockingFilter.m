%--------------------------------------------------------------------------
%
% Description: Filters macroblock edges in a frame
%
% Input variables:
%       - ycbcr_filtered_frame: frame to filter
%       - macroblock_dim: macroblock dimension
%       - Q: quantizing parameter
%
% Output variables:
%       - ycbcr_filtered_frame: filtered_frame
%
%   Authors:    Iepure, Albert
%               Jiménez, Moisés
%
%--------------------------------------------------------------------------

function [ycbcr_filtered_frame] = DeblockingFilter(ycbcr_predicted_frame,macroblock_dim,Q)
    ycbcr_filtered_frame = ycbcr_predicted_frame;
    dimensions = size(ycbcr_predicted_frame);
    length_ = dimensions(2);
    height_ = dimensions(1);
    %% ---------------------- INDEX DECLARATIONS --------------------------
    a_col = 6;
    b_col = 7;
    c_col = 8;
    d_col = 9;
    e_col = 10;
    f_col = 11;
    a_row = 6;
    b_row = 7;
    c_row = 8;
    d_row = 9;
    e_row = 10;
    f_row = 11;
    %%
    for row = 1 : macroblock_dim : dimensions(1)
        for column = 1 : macroblock_dim : dimensions(2)
            if row < height_ - 8 && column < length_ - 8
                block = ycbcr_predicted_frame(row:row+3*macroblock_dim/2+1,column:column+3*macroblock_dim/2+1,1:3);
                filtered_block = block;
                %--------------------- HORIZONTAL EDGE --------------------
                for c = 1 : macroblock_dim
                    A = block(a_row:a_row+3,c,:);
                    B = block(b_row:b_row+3,c,:);
                    C = block(c_row:c_row+3,c,:);
                    D = block(d_row:d_row+3,c,:);
                    E = block(e_row:e_row+3,c,:);
                    F = block(f_row:f_row+3,c,:);
                    [A_new,B_new,C_new,D_new,E_new,F_new] = smoothEdge(A,B,C,D,E,F,'H');
                    filtered_block(a_row,c,:) = A_new;
                    filtered_block(b_row,c,:) = B_new;
                    filtered_block(c_row,c,:) = C_new;
                    filtered_block(d_row,c,:) = D_new;
                    filtered_block(e_row,c,:) = E_new;
                    filtered_block(f_row,c,:) = F_new;
                end
                %--------------------- VERTICAL EDGE ----------------------
                for r = 1 : macroblock_dim
                    A = filtered_block(r,a_col:a_col+3,:);
                    B = filtered_block(r,b_col:b_col+3,:);
                    C = filtered_block(r,c_col:c_col+3,:);
                    D = filtered_block(r,d_col:d_col+3,:);
                    E = filtered_block(r,e_col:e_col+3,:);
                    F = filtered_block(r,f_col:f_col+3,:);
                    [A_new,B_new,C_new,D_new,E_new,F_new] = smoothEdge(A,B,C,D,E,F,'V');
                    filtered_block(r,a_col,:) = A_new;
                    filtered_block(r,b_col,:) = B_new;
                    filtered_block(r,c_col,:) = C_new;
                    filtered_block(r,d_col,:) = D_new;
                    filtered_block(r,e_col,:) = E_new;
                    filtered_block(r,f_col,:) = F_new;
                end
                ycbcr_filtered_frame(row+macroblock_dim-2:row+3*macroblock_dim/2-1-1,column:column+macroblock_dim-1,1:3) = filtered_block(1+macroblock_dim-2:3*macroblock_dim/2-1,1:macroblock_dim,1:3);
                ycbcr_filtered_frame(row:row+macroblock_dim-1,column+macroblock_dim-2:column+3*macroblock_dim/2-1-1,1:3) = filtered_block(1:macroblock_dim,1+macroblock_dim-2:3*macroblock_dim/2-1,1:3);
            elseif column == length_-8+1 && row ~= height_-8+1
                block = ycbcr_predicted_frame(row:row+3*macroblock_dim/2+1,column:column+macroblock_dim-1,1:3);
                filtered_block = block;
                %--------------------- HORIZONTAL EDGE --------------------
                for c = 1 : macroblock_dim
                    A = block(a_row:a_row+3,c,:);
                    B = block(b_row:b_row+3,c,:);
                    C = block(c_row:c_row+3,c,:);
                    D = block(d_row:d_row+3,c,:);
                    E = block(e_row:e_row+3,c,:);
                    F = block(f_row:f_row+3,c,:);
                    [A_new,B_new,C_new,D_new,E_new,F_new] = smoothEdge(A,B,C,D,E,F,'H');
                    filtered_block(a_row,c,:) = A_new;
                    filtered_block(b_row,c,:) = B_new;
                    filtered_block(c_row,c,:) = C_new;
                    filtered_block(d_row,c,:) = D_new;
                    filtered_block(e_row,c,:) = E_new;
                    filtered_block(f_row,c,:) = F_new;
                end
                ycbcr_filtered_frame(row+macroblock_dim-2:row+3*macroblock_dim/2-1-1,column:column+macroblock_dim-1,1:3) = filtered_block(1+macroblock_dim-2:3*macroblock_dim/2-1,1:macroblock_dim,1:3);
            elseif column ~= length_-8+1 && row == height_-8+1
                block = ycbcr_predicted_frame(row:row+macroblock_dim-1,column:column+3*macroblock_dim/2+1,1:3);
                filtered_block = block;
                %--------------------- VERTICAL EDGE ----------------------
                for r = 1 : macroblock_dim
                    A = filtered_block(r,a_col:a_col+3,:);
                    B = filtered_block(r,b_col:b_col+3,:);
                    C = filtered_block(r,c_col:c_col+3,:);
                    D = filtered_block(r,d_col:d_col+3,:);
                    E = filtered_block(r,e_col:e_col+3,:);
                    F = filtered_block(r,f_col:f_col+3,:);
                    [A_new,B_new,C_new,D_new,E_new,F_new] = smoothEdge(A,B,C,D,E,F,'V');
                    filtered_block(r,a_col,:) = A_new;
                    filtered_block(r,b_col,:) = B_new;
                    filtered_block(r,c_col,:) = C_new;
                    filtered_block(r,d_col,:) = D_new;
                    filtered_block(r,e_col,:) = E_new;
                    filtered_block(r,f_col,:) = F_new;
                end
                ycbcr_filtered_frame(row:row+macroblock_dim-1,column+macroblock_dim-2:column+3*macroblock_dim/2-1-1,1:3) = filtered_block(1:macroblock_dim,1+macroblock_dim-2:3*macroblock_dim/2-1,1:3);
            end
        end
    end
end