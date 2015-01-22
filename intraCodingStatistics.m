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

function [summation , histogram] =  intraCodingStatistics(file_path)
    frame = double(imread(file_path));
    frame = ictRGB2YCbCr(frame);
    histogram = hist(frame,-128:255);
    summation = sum(histogram);
end