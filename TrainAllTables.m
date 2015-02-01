function [] = TrainAllTables(Q)
    start_time = cputime;
    trainIntraHuffmanTable(Q);
    intra_time = cputime - start_time;
    fprintf('Huffman table training lasted: %fs.\n',intra_time);
    trainInterHuffmanTable(Q);
    inter_time = cputime - start_time - intra_time;
    fprintf('Huffman table training lasted: %fs.\n',inter_time);
    trainBidirectionalInterHuffmanTable(Q);
    binter_time = cputime - start_time - intra_time - inter_time;
    fprintf('Huffman table training lasted: %fs.\n',binter_time);
    end_time = cputime - start_time;
    fprintf('Huffman table training lasted: %fs.\n',end_time);
end