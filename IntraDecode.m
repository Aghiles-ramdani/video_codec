function new_image = IntraDecode( bytestream , BinaryTree, boundaries,sizes,imageDimensions,Q, lowerbound)
    dehuffmanized_stream = dec_huffman_new(bytestream, BinaryTree,  sizes) + lowerbound - 1;
    final_arrayY = dehuffmanized_stream(1:boundaries(1));
    final_arrayCb = dehuffmanized_stream(boundaries(1) + 1 : boundaries(1) + boundaries(2));
    final_arrayCr = dehuffmanized_stream(boundaries(1) + boundaries(2) + 1: boundaries(1) + boundaries(2) + boundaries(3));
    deZeroRanArrayY = ZeroRunDec(final_arrayY);
    deZeroRanArrayCb = ZeroRunDec(final_arrayCb);
    deZeroRanArrayCr = ZeroRunDec(final_arrayCr);
    new_image = zeros(imageDimensions);
    for i = 1 :8: imageDimensions(1)
        for j = 1 :8: imageDimensions(2)
            dzzBlock(:,:,1) = DeZigZag8x8(deZeroRanArrayY((j - 1) *8 + (i - 1) * imageDimensions(2) + 1:(j - 1)*8 + (i - 1) * imageDimensions(2) + 64));
            dzzBlock(:,:,2) = DeZigZag8x8(deZeroRanArrayCb((j - 1)*8 + (i - 1) * imageDimensions(2) + 1:(j - 1)*8 + (i - 1) * imageDimensions(2) + 64));
            dzzBlock(:,:,3) = DeZigZag8x8(deZeroRanArrayCr((j - 1)*8 + (i - 1) * imageDimensions(2) + 1:(j - 1)*8 + (i - 1) * imageDimensions(2) + 64));
            deQuantBlock = DeQuant8x8(dzzBlock,Q);
            ddctBlock(:,:,1) = IDCT8x8(deQuantBlock(:,:,1));
            ddctBlock(:,:,2) = IDCT8x8(deQuantBlock(:,:,2));
            ddctBlock(:,:,3) = IDCT8x8(deQuantBlock(:,:,3));
            new_image(i:i+7,j:j+7,1) = ddctBlock(:,:,1);
            new_image(i:i+7,j:j+7,2) = ddctBlock(:,:,2);
            new_image(i:i+7,j:j+7,3) = ddctBlock(:,:,3);
        end
    end
end