%
% THIS IS AN IMPLEMENTATION OF A FUNCTION FOR FINDING THE BEST MATCHING
% SIFT FEATURES
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

function FindBestMatch(InputImage1,InputImage2)

GrayScaleImage1 = rgb2gray(InputImage1);
SinglePrecisionImage1 = im2single(GrayScaleImage1);
[f1,d1] = vl_sift(SinglePrecisionImage1);

GrayScaleImage2 = rgb2gray(InputImage2);
SinglePrecisionImage2 = im2single(GrayScaleImage2);
[f2,d2] = vl_sift(SinglePrecisionImage2);

[matches, scores] = vl_ubcmatch(d2, d1) ;
 
[B,I] = sort(scores);

figure;

subplot (1,2,1);
image(InputImage2);

hold on;

in1= I(1); 
in2 = I(2);
in3 = I(3);
plot (f2(1,matches(1,in1)), f2(2, matches(1,in1)), 'w*');

plot (f2(1,matches(1,in2)), f2(2, matches(1,in2)), 'g*');
plot (f2(1,matches(1,in3)), f2(2, matches(1,in3)), 'b*');

title('Image 2 Best Matching Points')

hold off

subplot (1,2,2);
image(InputImage1);

hold on;

plot (f1(1, matches(2,in1)), f1(2, matches (2,in1)), 'w*');
plot (f1(1, matches(2,in2)), f1(2, matches (2,in2)), 'g*');
plot (f1(1, matches(2,in3)), f1(2, matches (2,in3)), 'b*');

title('Image 1 Best Matching Points')

hold off;

