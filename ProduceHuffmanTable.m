function [BinaryTree,BinCode,Codelengths] = ProduceHuffmanTable(image,lowerbound,upperbound)
    stream = image(:);
    H = hist(stream,lowerbound:upperbound);
    H = H/sum(H);
    [ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( H );