function [motionMatrix] = BidirectionalSSDFBSearch(block_size,mv_search_range,frame_02,frame_01,frame_00)
    sizes = size(frame_01);
    motionMatrix = zeros (sizes(1) / 8 ,sizes(2) / 8,2);
    sizes = size(frame_01);
    for i = 1 : block_size : sizes(1)
        for j = 1 : block_size : sizes(2)
            [motionVector_0,SSD_0] = SSDFullBlockSearch(i,j,block_size,mv_search_range,frame_01,frame_00);
            [motionVector_2,SSD_2] = SSDFullBlockSearch(i,j,block_size,mv_search_range,frame_01,frame_02);
            if SSD_0 < SSD_2
                motionMatrix(ceil(i/block_size),ceil(j/block_size),1) = motionVector_0(1);
                motionMatrix(ceil(i/block_size),ceil(j/block_size),2) = motionVector_0(2);
                motionMatrix(ceil(i/block_size),ceil(j/block_size),3) = 0;
            else
                motionMatrix(ceil(i/block_size),ceil(j/block_size),1) = motionVector_2(1);
                motionMatrix(ceil(i/block_size),ceil(j/block_size),2) = motionVector_2(2);
                motionMatrix(ceil(i/block_size),ceil(j/block_size),3) = 1;
            end
        end
    end
end