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

function [RGBImage] = ictYCbCr2RGB( image )

RGBImage(:,:,1) = image(:,:,1) + 1.402 * image(:,:,3);
RGBImage(:,:,2) = image(:,:,1) - 0.344 * image(:,:,2) - 0.714 * image(:,:,3);
RGBImage(:,:,3) = image(:,:,1) + 1.772 * image(:,:,2);

return ;