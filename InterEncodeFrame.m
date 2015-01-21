function [frame_01_prediction, motion_matrix] = InterEncodeFrame(macroblock_dim,motion_search_range,frame_01,frame_00)
motion_matrix = SSDFBSearch(macroblock_dim,motion_search_range,frame_01(:,:,1),frame_00(:,:,1));
frame_01_prediction = motionCompensation( frame_00, motion_matrix, macroblock_dim);