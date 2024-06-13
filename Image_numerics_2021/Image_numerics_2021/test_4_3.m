
clear;


file_List = dir('./*.xlsx');      
file_List = file_List(~startsWith({file_List.name},'~'));  

num0fdata = length(file_List);  
numData=[]; txtData=[]; rawData=[];
for ii=1:num0fdata 
    file = fullfile('./', file_List(ii).name);               
    [numData{ii},txtData{ii},rawData{ii}] = xlsread(file);   
end

LoC  = []; 
YMod = [];


imgW = 148;   
imgH = imgW; 

for kk=1:num0fdata  

data = numData{kk};  

[nRows,nCols] = size(data);       
idx_FileName = find(contains(txtData{kk},'No'));      
idx_Modulus  = find(contains(txtData{kk},'Modulus')); 

ImgFN_List = numData{kk}(:,idx_FileName);             
YMod_List  = numData{kk}(:,idx_Modulus);             


idx_rev = find(YMod_List<0);  
for jj=1:numel(idx_rev)
    idx0 = idx_rev(jj);
    idx1 = idx0-1;  
    idx2 = idx0+1;  
    
   
    chk0 = floor(idx0/imgW);  
    chk1 = floor(idx1/imgW);
    chk2 = floor(idx2/imgW);
    
    YM_temp = [];
    if chk1==chk0 && ~any(idx_rev==idx1)  
       YM_temp(end+1) = YMod_List(idx1);
    end
    if chk2==chk0 && ~any(idx_rev==idx2) 
       YM_temp(end+1) = YMod_List(idx2);
    end
    if isempty(YM_temp) 
        YM_temp = 0.0;
    end
    
    
    YMod_List(idx0) = mean(YM_temp);
end


LoC  = ImgFN_List;   
YMod = YMod_List;    

end

data=[];
for i=1:length(YMod)  
    data(i,:) = [mod(LoC(i), imgW), floor(LoC(i)/imgW), YMod(i)];
end

num0fgrid = imgW;      
xmin = 0;
xmax = imgW-1;
dx   = (xmax-xmin)/(num0fgrid-1);
ymin = 0;
ymax = imgH-1;
dy   = (ymax-ymin)/(num0fgrid-1);

[X,Y] = meshgrid(xmin:dx:xmax, ymax:-dy:ymin);   

Z = griddata(data(:,1), data(:,2), data(:,3), X, Y, 'cubic');   

figure('visible','on');
figure(1);
fs = 14;

cmp0 = colormap(jet);  
Z_new=1.*Z;
surf(X,Y,Z_new);         
hold on
shading interp;     
view(2);             


zmin = 0;
zmax = 30;
caxis([zmin, zmax]); 
cb = colorbar;
cb.Label.String = 'Young''s Modulus (kPa)';  
set(cb,'YTick',[zmin:(zmax-zmin)/4:zmax]);  
cb.Ruler.TickLabelFormat = '%.0f';  


xlim([xmin, xmax]);
xticks([xmin, round((xmax-xmin)/2), xmax]);
xticklabels({'1',num2str(round(0.5*imgW)), num2str(imgW)});
ylim([ymin, ymax]);
yticks([ymin, round((ymax-ymin)/2), ymax]);
yticklabels({'1',num2str(round(0.5*imgH)), num2str(imgH)});
axis off
axis square

set(gca,'FontSize',fs);