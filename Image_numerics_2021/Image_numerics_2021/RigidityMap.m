
function RigidityMap(fpath)

cd(fpath);

file_List = dir('./*.xls');      
for ii=1:numel(file_List)
    file = fullfile('./', file_List(ii).name);  
    [tempDir, tempFile] = fileparts(file);      
    status = copyfile(file, fullfile(tempDir, [tempFile, '.txt'])); 

end

data_List = dir('./*.txt');      
num0fdata = length(data_List);  

LoC  = []; 
YMod = [];

for kk=1:num0fdata  
data = readtable(data_List(kk).name);  

[nRows,nCols] = size(data);             
ImgFN_List = data.ImageFileName;       
YMod_List  = data.Young_sModulus_MPa_;  

for i=1:nRows
    if contains(ImgFN_List{i},'.spm')  
        LoC_idx = extractBetween(ImgFN_List{i},"ForceCurveIndex_",".spm"); 
        
        LoC(end+1)  = str2double(LoC_idx{1});   % location 
        YMod(end+1) = YMod_List(i);             % Youngs modulus
    end
end

end



imgW = 100;   
imgH = imgW;  


data=[];
for i=1:length(YMod)  
    data(i,:) = [mod(LoC(i), imgW)+1, floor(LoC(i)/imgW)+1, YMod(i)];
end

num0fgrid = imgW;      
xmin = 1;
xmax = imgW;
dx   = (xmax-xmin)/(num0fgrid-1);
ymin = 1;
ymax = imgH;
dy   = (ymax-ymin)/(num0fgrid-1);

[X,Y] = meshgrid(xmin:dx:xmax, ymax:-dy:ymin);   

Z = griddata(data(:,1), data(:,2), data(:,3), X, Y, 'cubic');   

figure('visible','off');
fs = 18;

cmp0 = colormap(jet);  

uniConvert = 1000;   
Z_new = Z.*uniConvert;   
surf(X,Y,Z_new);    
shading interp;      
view(2);            

zmin = min(Z,[],'all').*uniConvert;
zmax = max(Z,[],'all').*uniConvert;
caxis([zmin, zmax]); 
cb = colorbar;
cb.Label.String = 'Young''s Modulus (kPa)';  
set(cb,'YTick',[zmin:(zmax-zmin)/4:zmax]);   
cb.Ruler.TickLabelFormat = '%.1f';         

xlim([xmin, xmax]);
xticks([xmin, round((xmax-xmin)/2), xmax]);
xticklabels({'1',num2str(round(0.5*imgW)), num2str(imgW)});
ylim([ymin, ymax]);
yticks([ymin, round((ymax-ymin)/2), ymax]);
yticklabels({'1',num2str(round(0.5*imgH)), num2str(imgH)})

set(gca,'FontSize',fs);
xlabel('X','interpreter','Latex','FontSize',24);
ylabel('Y','interpreter','Latex','FontSize',24,'rotation',0);
title('Rigidity Map');


axis square;
axis off;                        
title('');                      
colorbar off;                   
saveas(gcf,'rigidity.tif');      
save('rigidityVar.mat','X','Y','Z_new');  
cd ..

end
