%--------------------------------------------------------------
%
%
%
%           %%%    %%%       %%%      %%%%%%%%
%           %%%    %%%      %%%     %%%%%%%%%            
%           %%%    %%%     %%%    %%%%
%           %%%    %%%    %%%    %%%
%           %%%    %%%   %%%    %%%
%           %%%    %%%  %%%    %%%
%           %%%    %%% %%%    %%%
%           %%%    %%%%%%    %%%
%           %%%    %%%%%     %%% 
%           %%%    %%%%       %%%%%%%%%%%%
%           %%%    %%%          %%%%%%%%%   ENCODE.M
%
%
% organises the encoding process of the image
%
% input:        number of actual ParameterSet to use
%
% returnvalue:  success          - 0: some error occured
%                                - 1: bitstream written
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Moises Jimenez
%               21.10.2014 (created)
%
%-----------------------------------------------------------------------------------

function [YCbCrImage] = ictRGB2YCbCr( image )

YCbCrImage(:,:,1) = 0.299 * image(:,:,1) + 0.587 * image(:,:,2) + 0.114 * image(:,:,3);
YCbCrImage(:,:,2) = - 0.169 * image(:,:,1) - 0.331 * image(:,:,2) + 0.5 * image(:,:,3);
YCbCrImage(:,:,3) = 0.5 * image(:,:,1) - 0.419 * image(:,:,2) - 0.081 * image(:,:,3);

return ;