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

function [ycbcr_filtered_frame] = DeblockingFilter(ycbcr_recovered_frame,macroblock_dim,Q)
    ycbcr_filtered_frame = zeros(dimensions);
    for row = 1 : macroblock_dim : dimensions(1)
        for column = 1 : macroblock_dim : dimensions(2)
            block = ycbcr_recovered_frame(row:row+macroblock_dim-1,column:column+macroblock_dim-1,:);
            filtered_block = block;
            % For any non-corner block
            if(row > 1 && row < height_ && column > 1 && column < length_)
                for c = column : column + macroblock_dim - 1
                    A_top = block(row - 2,column,:);
                    B_top = block(row - 1,column,:);
                    C_top = block(row,column,:);
                    D_top = block(row + 1,column,:);
                    [A,B,C,D] = smoothEdge(A_top,B_top,C_top,D_top,Q);
                    filtered_block(row - 2,column,:) = A;
                    filtered_block(row - 1,column,:) = B;
                    filtered_block(row,column,:) = C;
                    filtered_block(row + 1,column,:) = D;
                    bot_row = row + macroblock_dim - 1;
                    A_bot= block(bot_row - 1,column,:);
                    B_bot = block(bot_row,column,:);
                    C_bot = block(bot_row + 1,column,:);
                    D_bot = block(bot_row + 2,column,:);
                    [A,B,C,D] = smoothEdge(A_bot,B_bot,C_bot,D_bot,Q);
                    filtered_block(bot_row - 1,column,:) = A;
                    filtered_block(bot_row,column,:) = B;
                    filtered_block(bot_row + 1,column,:) = C;
                    filtered_block(bot_row + 2,column,:) = D;
                end
            end
            %
            ycbcr_filtered_frame(row:row+macroblock_dim-1,column:column+macroblock_dim-1,:) = filtered_block;
        end
    end
end