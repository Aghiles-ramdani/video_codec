function [predictedImage] = BidirectionalMotionCompensation(frame_2,frame_0,motionMatrix, block_size)
    sizes = size ( frame_0 );
    predictedImage = zeros(sizes);
    for i = 1 : block_size : sizes(1)
        for j = 1 : block_size : sizes(2)
            row = motionMatrix(ceil(i/block_size),ceil(j/block_size),1);
            column = motionMatrix(ceil(i/block_size) ,ceil(j/block_size),2);
            if motionMatrix(ceil(i/block_size) ,ceil(j/block_size),3) == 0
                predictedImage(i:i+block_size-1,j:j+block_size-1,:) = frame_0(i+row:i+row+block_size-1,j+column:j+column+block_size-1,:);
            else
                predictedImage(i:i+block_size-1,j:j+block_size-1,:) = frame_2(i+row:i+row+block_size-1,j+column:j+column+block_size-1,:);
            end
        end
    end
end