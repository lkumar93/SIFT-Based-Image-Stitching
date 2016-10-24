%
% THIS IS AN IMPLEMENTATION OF THE STITCH FUNCTION REQUIRED FOR 
% STITCHING TWO IMAGES
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

function stitch(J,K,A)
[m1,n1] = size(single(rgb2gray(J)));
[m2,n2] = size(single(rgb2gray(K)));

T1 = [1 0 0; 0 1 0; 100 0 1];
rotation = [ cos(-pi/16) -sin(-pi/16) 0; sin(-pi/16) cos(-pi/16) 0 ; 0 0 1];
scaling = [ 0.8 0 0 ; 0 0.8 0; 0 0 1];
translation = [1 0 0; 0 1 0; 100 50 1];
T2 = translation*scaling*rotation;


AffineTransformation1Image = zeros(m2,n2+T1(3,1),3);
AffineTransformation2Image = zeros(m2+round(A(1,3)), n2,3);
MosaicImage = zeros(m1+round(A(2,3)),n1+round(A(1,3)),3);

tform2 = affine2d(T2);
tform1 = affine2d(T1);

for i = 1: m2
    for j = 1: n2
        for k = 1:3
         u = [A(1,1) A(1,2) ; A(2,1) A(2,2) ]*[i;j];
         in1 = round(u(1));
         if in1 <= 0
            in1 = 1;
         end
         in2 = round(u(2)); 
         if in2 <= 0
            in2 = 1;
         end
        
         if round(A(1,1)*i)+round(A(1,2)*j)-round(A(2,3)) <= 0
            Offset = -round(A(1,1)*i)-round(A(1,2)*j) + 1; 
         else
            Offset =  round(A(2,3));
         end
        
         MosaicImage(Offset+round(A(1,1)*i)+round(A(1,2)*j),round(A(1,3))+round(A(2,1)*i)+round(A(2,2)*j),k) = K(i,j,k);
         AffineTransformation1Image(in1,in2,k) = K(i,j,k);
         AffineTransformation2Image(in1,in2,k) = K(i,j,k);

        end
        
    end
   
end

Rcb1 = imref2d(size(AffineTransformation1Image));
[AffineTransformation1Image] = imwarp(AffineTransformation1Image, tform1,'OutputView',Rcb1);

Rcb2 = imref2d(size(AffineTransformation2Image));
[AffineTransformation2Image] = imwarp(AffineTransformation2Image, tform2,'OutputView',Rcb2);


for i = 1: m1
    for j = 1: n1
        for k = 1: 3
        
       
        MosaicImage(i,j,k) = J(i,j,k);
        AffineTransformation1Image(i,j,k) = J(i,j,k);
        AffineTransformation2Image(i,j,k) = J(i,j,k);
        
        end
                
    end
   
end


%Box Filter for black points
[m3,n3,o3] = size(MosaicImage)

for i = 1: m3
    for j = 1: n3
        
        for k = 1:3
       
       if MosaicImage(i,j,k) == 0 && i ~= m3 && j ~=n3 && i ~= 1 && j ~= 1
          
        MosaicImage(i,j,k) = (MosaicImage(i-1,j,k)+MosaicImage(i,j-1,k)+MosaicImage(i-1,j-1,k)+MosaicImage(i-1,j+1,k)+MosaicImage(i+1,j-1,k)+ MosaicImage(i+1,j,k)+MosaicImage(i,j+1,k)+MosaicImage(i+1,j+1,k))/8;
        
       end
        
        end
        
    end
   
 end

figure;
subplot(1,2,1);

image(uint8(MosaicImage));
title('Mosaic Image');

