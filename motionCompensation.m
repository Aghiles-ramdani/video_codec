function [predictedImage] = motionCompensation(image,motionMatrix, block_size)
    sizes = size ( image );
    predictedImage = zeros(sizes);
    for i = 1 : block_size : sizes(1)
        for j = 1 : block_size : sizes(2)
            row = motionMatrix(ceil(i/block_size),ceil(j/block_size),1);
            column = motionMatrix(ceil(i/block_size) ,ceil(j/block_size),2);
            predictedImage(i:i+block_size-1,j:j+block_size-1,:) = image(i+row:i+row+block_size-1,j+column:j+column+block_size-1,:);
        end
    end
end