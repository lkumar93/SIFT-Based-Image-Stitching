%
% THIS IS AN IMPLEMENTATION OF THE RANSAC FUNCTION REQUIRED FOR COMPUTING
% THE AFFINE TRANSFORMATION BETWEEN TWO IMAGES BASED ON SIFT FEATURES
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


function AffineTransformation = RANSAC(InputImage1,InputImage2)
GrayScaleImage1 = rgb2gray(InputImage1);
SinglePrecisionImage1 = im2single(GrayScaleImage1);
[f1,d1] = vl_sift(SinglePrecisionImage1);

GrayScaleImage2 = rgb2gray(InputImage2);
SinglePrecisionImage2 = im2single(GrayScaleImage2);
[f2,d2] = vl_sift(SinglePrecisionImage2);

[matches, scores] = vl_ubcmatch(d2, d1) ;
 
[B,I] = sort(scores);

[m,n] = size(I);

Maximum_Iterations = 1500;

best_matched_points = 0;

Threshold = 2;
for iteration = 1 : Maximum_Iterations

    rn = randperm(n,3);
    in1 = rn(1);
    in2 = rn(2);
    in3 = rn(3);

    p2 = [ f2(1,matches(1,in1)) f2(1,matches(1,in2)) f2(1,matches(1,in3)) ; f2(2, matches(1,in1)) f2(2, matches(1,in2)) f2(2, matches(1,in3)) ] ;

    p1 = [ f1(1, matches(2,in1)) f1(1, matches(2,in2)) f1(1, matches(2,in3)) ; f1(2, matches (2,in1)) f1(2, matches (2,in2)) f1(2, matches (2,in3)) ] ;

    A = affine_transformation(p1,p2) ;

    matched_points = 0;
    
    for index = 1:n

       Point2 = [f2(1,matches(1,index)); f2(2,matches(1,index)) ; 1];
       Point1 = [f1(1,matches(2,index)); f1(2,matches(2,index)) ; 1];
       TransformedPoint2 = A*Point2 ; 
       EuclideanDistance = sqrt((Point1(1)-TransformedPoint2(1))^2 + (Point1(2)-TransformedPoint2(2))^2 );
       if EuclideanDistance <= Threshold
           matched_points= matched_points+1;
       end
    end  
    
    if matched_points > best_matched_points
        best_matched_points = matched_points;
        best_affine_transformation = A;
        best_in1 = in1;
        best_in2 = in2;
        best_in3 = in3;
    end
  
    
end


AffineTransformation = best_affine_transformation

