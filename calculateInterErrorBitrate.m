function [bitrate] = calculateInterErrorBitrate( image, mv_indicators, huffman_stream)
    sizeImage = size(image);
    bits = length(huffman_stream) * 8;
    if length(mv_indicators) > 1
        bits = bits + length(mv_indicators(:));
    end
    bitrate = bits /  sizeImage(1) / sizeImage(2);
end