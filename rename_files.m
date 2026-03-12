% set working directory
cd S:\niamh_project\fu3_scans\

% define variable to outline the folder when the scans are kept
folder = 'S:\niamh_project\fu3_scams'

%list any files in the current directory where there is *underscore* 
files = dir('*_*');

%for each file/scan, break down the name into each part of the name (ID, _dti, _ecc, .bval.bvec.nii.gz)
for i = 1:length(files)
    old = files(i).name;

    parts = strsplit(old,'_');
%if the file has at least 3 parts, rename the file to include FU3 in the name (changed this to rename BL files obvs)
    if length(parts) >= 3
        new = [parts{1} '_FU3_' strjoin(parts(3:end),'_')];
        movefile(old,new);
    end
end
