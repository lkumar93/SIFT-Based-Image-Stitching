%
% THIS FILE PLOTS THE SIFT FEATURES IN BOTH THE IMAGES, FINDS THE BEST MATCH BETWEEN TWO IMAGES
% AND COMPUTES THE AFFINE TRANSFORM USING RANSAC TO STITCH TWO IMAGES
%
% COPYRIGHT BELONGS TO THE AUTHOR OF THIS CODE
%
% AUTHOR : LAKSHMAN KUMAR
% AFFILIATION : UNIVERSITY OF MARYLAND, MARYLAND ROBOTICS CENTER
% EMAIL : LKUMAR93@UMD.EDU
% LINKEDIN : WWW.LINKEDIN.COM/IN/LAKSHMANKUMAR1993
%
% THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THE MIT LICENSE
% THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF
% THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.
% 
% BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO
% BE BOUND BY THE TERMS OF THIS LICENSE. THE LICENSOR GRANTS YOU THE RIGHTS
% CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND
% CONDITIONS.
%

function mosaic(Image1,Image2)

PlotSiftFeatures(Image1,100);
PlotSiftFeatures(Image2,100);
FindBestMatch(Image1,Image2);
Affine_Transformation = RANSAC(Image1,Image2);
stitch(Image1,Image2,Affine_Transformation);

end


