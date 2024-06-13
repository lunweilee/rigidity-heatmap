
function Contour(fpath)
cd(fpath);

img_List = dir('./*_ROI_1.tif');       
img_raw = imread(img_List(1).name);    

[indRow,indCol] = find(img_raw(:,:,2)<128 & img_raw(:,:,3)<128);   
RowMin = min(indRow); RowMax = max(indRow);                     
ColMin = min(indCol); ColMax = max(indCol);                       
img  =  img_raw(RowMin:RowMax, ColMin:ColMax, 1);                 
[imgW,imgH] = size(img); 

imgL = min(imgW,imgH);   
img  = imresize(img, [imgL,imgL]);
[imgW,imgH] = size(img); 

T = adaptthresh(img, 0.4);  
img_bw = imbinarize(img,T); 


se = strel('disk',2);             
img_seg = imopen(img_bw,se);  
                                 

imwrite(img_seg,'contour.tif');


cd ..

end