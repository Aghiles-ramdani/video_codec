%--------------------------------------------------------------------------
%
% Description: generate motion estimation statistics for a couple of
% frames.
%
% Input variables:
%       - macroblock_dim: N dimension of NxN macroblocks.
%       - Q: quantization parameter for intra coding.
%       - mv_search_range: search range for motion estimation.
%       - frame_00: Matrix containing the previous frame of the sequence.
%       - frame_01: Matrix containing the current frame of the sequence.
%
% Output variables:
%       - intra_mv_histogram: histogram of the motion vector generated.
%       - intra_mv_histogram_sum: summation of the bin counts of the motion
%       vector histogram.
%       - intra_ef_histogram: histogram of the error frame.
%       - intra_ef_histogram_sum: summation of the bin counts of the error
%       frame histogram.
%
%   Authors:    Iepure, Albert
%               Jiménez, Moisés
%
%--------------------------------------------------------------------------

function [intra_mv_histogram , intra_mv_histogram_sum, intra_ef_histogram,intra_ef_histogram_sum] =  interCodingStatistics(macroblock_dim,Q,mv_search_range,frame_01,frame_00)
    ef_lowerbound = -128;
    ef_upperbound = 255 - (-128);
    [ycbcr_predicted_frame,motion_matrix]=InterEncodeFrame(macroblock_dim,mv_search_range,frame_01,frame_00);
    ycbcr_prediction_error_frame = frame_01 - ycbcr_predicted_frame;
    ycbcr_intra_encoded_error_frame = preEncodeIntraProcess(ycbcr_prediction_error_frame,Q);
    intra_mv_histogram = hist(motion_matrix(:),-mv_search_range:mv_search_range);
    intra_mv_histogram_sum = sum(sum(intra_mv_histogram));
    intra_ef_histogram = hist(ycbcr_intra_encoded_error_frame,ef_lowerbound:ef_upperbound);
    intra_ef_histogram_sum = sum(intra_ef_histogram);
end