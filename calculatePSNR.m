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
%           %%%    %%%          %%%%%%%%%   calculatePSNR.M
%
%
% organises the encoding process of the image
%
% input:        img_resolution number of bits per color plane pixel
%               original_image original version of reconstructed image
%               reconstructed_image reconstructed image
%
% returnvalue:  PSNR        
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Moises Jimenez
%               14.10.2014 (created)
%
%-----------------------------------------------------------------------------------

function peak_to_signal_noise_ratio = calculatePSNR( img_resolution,original_image, reconstructed_image )
mean_squared_error = calcMSE(original_image, reconstructed_image);
squared_max = (2 ^ img_resolution - 1).^2;
peak_to_signal_noise_ratio = 10 * log10(squared_max / mean_squared_error);

return ;