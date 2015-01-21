function [decoded_stream,encoded_image] = IntraEncodeFrame(image,BinaryTree, BinCode, Codelengths, Q,lowerbound)
    [encoded_image, boundaries] = IntraEncode(image,BinCode,Codelengths,Q,lowerbound);
    decoded_stream = IntraDecode(encoded_image, BinaryTree,boundaries,sum(sum(boundaries)),size(image),Q,lowerbound);
end