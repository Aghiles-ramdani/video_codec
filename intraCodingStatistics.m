%--------------------------------------------------------------------------
%
% Description: generate statistics for an image saved in the HDD.
%
% Input variables:
%       - file_path: indicates the location of the image to analyze.
%
% Output variables:
%       - summation: summation of counts in histogram bins.
%       - histogram: image histogram
%
%   Authors:    Iepure, Albert
%               Jiménez, Moisés
%
%--------------------------------------------------------------------------

function [summation , histogram] =  intraCodingStatistics(file_path,Q)
    frame = double(imread(file_path));
    ycbcr_frame = ictRGB2YCbCr(frame);
    [new_final_array] = preEncodeIntraProcess(ycbcr_frame, Q);
    histogram = hist(new_final_array,-128:260);
    summation = sum(histogram);
end