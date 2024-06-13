% Main
clear;

dirInfo = dir;                    
dirFlags  = [dirInfo.isdir];     
Fold_List = dirInfo(dirFlags);     
numFold   = length(Fold_List); 

for k=3:numFold 
fname = Fold_List(k).name;                
fpath = [Fold_List(k).folder '/' fname]; 


RigidityMap(fpath);  
clc;
Contour(fpath);    

img_rigidity = imread([fpath '/' 'rigidity.tif']);
img_contour  = imread([fpath '/' 'contour.tif']);


[indRow,indCol] = find(~(img_rigidity(:,:,1)==255 & img_rigidity(:,:,2)==255 & img_rigidity(:,:,3)==255)); 
RowMin = min(indRow); RowMax = max(indRow);                       
ColMin = min(indCol); ColMax = max(indCol);                    
img_rigidity = img_rigidity(RowMin:RowMax, ColMin:ColMax, :);                   


[imgW,imgH] = size(img_contour); 
magFac      = 1;   
img_rigidity = imresize(img_rigidity, magFac.*[imgW,imgH]);
img_contour  = imresize(img_contour,  magFac.*[imgW,imgH]);


figure('visible','off');
imshow(img_rigidity); hold on;
[LocY,LocX]   = find(img_contour==1);    
[LocYn,LocXn] = find(img_contour==0);   
plot(LocX,LocY,'k*','MarkerSize',1);    


saveas(gcf,[fpath '/' 'overlay.tif']);   
LocX_  = (LocX-1)  ./ (imgW-1); LocY_  = (LocY-1)  ./ (imgH-1);
LocXn_ = (LocXn-1) ./ (imgW-1); LocYn_ = (LocYn-1) ./ (imgH-1);


AnaRigidity(fpath,LocX_,LocY_,LocXn_,LocYn_);


end
%======================== End of Loop =====================================
