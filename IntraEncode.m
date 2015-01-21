function [bytestream , boundaries] = IntraEncode( stream , BinCode, Codelengths , Q, lowerbound)
    %stream_ycbcr = ictRGB2YCbCr(stream);
    sizes = size ( stream );
    final_arrayY = [ 0 ];
    final_arrayCb = [ 0 ];
    final_arrayCr = [ 0 ];
    for i = 1 :8: sizes(1)
        for j = 1 :8: sizes(2)
                block(:,:,1) = stream(i:i+7,j:j+7,1);
                block(:,:,2) = stream(i:i+7,j:j+7,2);
                block(:,:,3) = stream(i:i+7,j:j+7,3);
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
                final_arrayY = [final_arrayY , zrBlockY];
                final_arrayCb = [final_arrayCb , zrBlockCb];
                final_arrayCr = [final_arrayCr , zrBlockCr];
        end
    end
    final_arrayY = final_arrayY(2:end);
    final_arrayCb = final_arrayCb(2:end);
    final_arrayCr = final_arrayCr(2:end);
    boundaries = [ max(max(size(final_arrayY))) max(max(size(final_arrayCb))) max(max(size(final_arrayCr))) ];
    new_final_array = [final_arrayY , final_arrayCb, final_arrayCr];
    bytestream = enc_huffman_new((new_final_array) - lowerbound + 1, BinCode, Codelengths);
end