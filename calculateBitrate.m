function [bitrate] = calculateBitrate( image, bytestream)
    sizeImage = size(image);
    bitrate = length(bytestream) * 8 /  sizeImage(1) / sizeImage(2);
end