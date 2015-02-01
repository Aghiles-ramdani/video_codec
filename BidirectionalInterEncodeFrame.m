function [frame_01_prediction, motion_matrix] = BidirectionalInterEncodeFrame(macroblock_dim,motion_search_range,frame_02,frame_01,frame_00)
motion_matrix = BidirectionalSSDFBSearch(macroblock_dim,motion_search_range,frame_02(:,:,1),frame_01(:,:,1),frame_00(:,:,1));
frame_01_prediction = BidirectionalMotionCompensation( frame_02,frame_00, motion_matrix, macroblock_dim);