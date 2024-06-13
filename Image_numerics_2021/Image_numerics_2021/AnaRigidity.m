

function AnaRigidity(fpath,LocX_,LocY_,LocXn_,LocYn_)
cd(fpath);
load('rigidityVar.mat');    


xMax = max(max(X));
yMax = max(max(Y));

LocX_  = round(LocX_.*(xMax-1))+1;  
LocY_  = round(LocY_.*(yMax-1))+1;
LocXn_ = round(LocXn_.*(xMax-1))+1;
LocYn_ = round(LocYn_.*(yMax-1))+1;

RgJ  = [];  
RgJn = [];  


numLocJ  = length(LocX_) ;
numLocJn = length(LocXn_);

if numLocJn > numLocJ
    for i=1:numLocJ
        RgJ(end+1)  = Z_new(LocX_(i),LocY_(i));
        RgJn(end+1) = Z_new(LocXn_(i),LocYn_(i));
    end
    for i=numLocJ+1:numLocJn
        RgJ(end+1)  = NaN;
        RgJn(end+1) = Z_new(LocXn_(i),LocYn_(i));
    end
else 
    for i=1:numLocJn
        RgJ(end+1)  = Z_new(LocX_(i),LocY_(i));
        RgJn(end+1) = Z_new(LocXn_(i),LocYn_(i));
    end
    for i=numLocJn+1:numLocJ
        RgJ(end+1)  = Z_new(LocX_(i),LocY_(i));
        RgJn(end+1) = NaN;
    end      
end
writematrix([RgJ',RgJn'],'rigidity_Junc_nonJunc.xlsx'); 

cd ..


end