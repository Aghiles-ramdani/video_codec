function [motionVector, SSD] = SSDFullBlockSearch(x,y,block_size,mv_search_range,current_image,previous_image)
    sizes = size(current_image);
    length = sizes(1);
    height = sizes(2);
    SSD = 999999999999;
    motionVector = [ 0 0 ];
    current_block = current_image(x:x+block_size-1,y:y+block_size-1,1);
    for row = -mv_search_range : 1 : mv_search_range
        for column = -mv_search_range: 1 : mv_search_range
            if ((x+row>0) && (x+row+block_size<=length) && (y+column>0) && (y+column+block_size<=height)) 
                previous_block = previous_image(x+row:x+row+block_size-1,y+column:y+column+block_size-1);
                SSDtemp = sum(sum((current_block-previous_block).^2));
                if(SSDtemp < SSD)
                    SSD = SSDtemp;
                    motionVector = [ row column ];
                end
            end
        end
    end
end