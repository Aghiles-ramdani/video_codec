function [ BinaryTree, BinCode, Codelengths] = ProduceIntraEncodeHuffmanTable(Q,lowerbound,upperbound)
    image_small = double(imread('data/images/lena_small.tif'));
    image_small_ycbcr = ictRGB2YCbCr(image_small);
    %image_small_ycbcr = rgb2ycbcr(image_small);
    final_arrayY = [ 0 ];
    final_arrayCb = [ 0 ];
    final_arrayCr = [ 0 ];
    for i = 1 : 8
        for j = 1 : 8
                block(:,:,1) = image_small_ycbcr(i:i+7,j:j+7,1);
                block(:,:,2) = image_small_ycbcr(i:i+7,j:j+7,2);
                block(:,:,3) = image_small_ycbcr(i:i+7,j:j+7,3);
                dctBlock(:,:,1) = DCT8x8(block(:,:,1));
                dctBlock(:,:,2) = DCT8x8(block(:,:,2));
                dctBlock(:,:,3) = DCT8x8(block(:,:,3));
                quantBlock = Quant8x8(dctBlock,Q);
                zzBlock(:,:,1) = ZigZag8x8(quantBlock(:,:,1));
                zzBlock(:,:,2) = ZigZag8x8(quantBlock(:,:,2));
                zzBlock(:,:,3) = ZigZag8x8(quantBlock(:,:,3));
                zrBlockY = ZeroRunEnc(zzBlock(:,:,1));
                zrBlockCb = ZeroRunEnc(zzBlock(:,:,2));
                zrBlockCr = ZeroRunEnc(zzBlock(:,:,3));
                array = [zrBlockY , zrBlockCb , zrBlockCr];
                final_arrayY = [final_arrayY , zrBlockY];
                final_arrayCb = [final_arrayCb , zrBlockCb];
                final_arrayCr = [final_arrayCr , zrBlockCr];
        end
    end
    final_arrayY = final_arrayY(2:end);
    final_arrayCb = final_arrayCb(2:end);
    final_arrayCr = final_arrayCr(2:end);
    new_final_array = [final_arrayY , final_arrayCb, final_arrayCr];
    H = hist(new_final_array,lowerbound:upperbound);
    H = H/sum(H);
    [ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( H );
end