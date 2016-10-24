function stitchn(ImageArray)
[row,column] = size(ImageArray);

AffineTransformations = {0};
AffineTransformation = {0};
MosaicRows = 0;
MosaicColumns = 0;

%Bilinear Interpolation

[FirstImageRows,FirstImageColumn,Channels] = size(ImageArray{1});

for i=column:-1:2
     ImageArray{i} = bilinearInterpolation(ImageArray{i},[FirstImageRows,FirstImageColumn]);    
end

%Stitching
for i=column:-1:2
    
    AffineTransformations{i-1} = RANSAC(ImageArray{i-1},ImageArray{i});
    AffineTransformation{i-1} = AffineTransformations{i-1};
    MosaicRows = MosaicRows + round(AffineTransformations{i-1}(2,3));
    MosaicColumns = MosaicColumns + round(AffineTransformations{i-1}(1,3));
  
end

for i= column:-1:2
    for j = i-1:-1:2
       AffineTransformation{i-1} = [AffineTransformations{j-1};0 0 1]*[AffineTransformation{i-1}; 0 0 1];
    end
end

[m,n] = size(single(rgb2gray(ImageArray{1})));
MosaicRows = MosaicRows + m ;
MosaicColumns = MosaicColumns + n ;
MosaicImage = zeros(MosaicRows,MosaicColumns,3);


for l = column:-1:2
    [m1,n1] = size(single(rgb2gray(ImageArray{l-1})));
    [m2,n2] = size(single(rgb2gray(ImageArray{l})));
    for i = 1: m2
    
        for j = 1: n2
        
            for k = 1:3
                
                            
                if round(AffineTransformation{l-1}(1,1)*i)+round(AffineTransformation{l-1}(1,2)*j)-round(AffineTransformation{l-1}(2,3)) <= 0
                    Offset = -round(AffineTransformation{l-1}(1,1)*i)-round(AffineTransformation{l-1}(1,2)*j) + 1; 
                else
                    Offset =  round(AffineTransformation{l-1}(2,3));
                end
              
                MosaicImage(Offset+round(AffineTransformation{l-1}(1,1)*i)+round(AffineTransformation{l-1}(1,2)*j),round(AffineTransformation{l-1}(1,3))+round(AffineTransformation{l-1}(2,1)*i)+round(AffineTransformation{l-1}(2,2)*j),k) = ImageArray{l}(i,j,k);
         
            end
               
        end
   
    end
    
    
    
    
    for i = 1: m1
    
        for j = 1: n1
        
            for k = 1: 3

                   if j >= n1 - 30
                   
                   %Feathering Approach For Reducing Exposure Variation In The Blending Region    
                   
                   w = (n1 - j)/30; %Weight Function
                   MosaicImage(i,j,k) = ((w)*ImageArray{l-1}(i,j,k) + (1-w)*MosaicImage(i,j,k));

                   else

                  MosaicImage(i,j,k) = ImageArray{l-1}(i,j,k);

                   end
            end
        end
     end
   
end
     

%Box Filter for black points
[m3,n3,o3] = size(MosaicImage);

for i = 1: m3
    for j = 1: n3
        for k = 1:3
       
       if  i ~= m3 && j ~=n3 && i ~= 1 && j ~= 1 && MosaicImage(i,j,k) == 0
          
        MosaicImage(i,j,k) = (MosaicImage(i-1,j,k)+MosaicImage(i,j-1,k)+MosaicImage(i-1,j-1,k)+MosaicImage(i-1,j+1,k)+MosaicImage(i+1,j-1,k)+ MosaicImage(i+1,j,k)+MosaicImage(i,j+1,k)+MosaicImage(i+1,j+1,k))/8;
        
       end
        
      end
        
    end
   
end


figure;

image(uint8(MosaicImage));
title('Mosaic Image');
