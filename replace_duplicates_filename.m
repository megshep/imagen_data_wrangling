% set the working directory
cd S:\niamh_project\fu3_scans\

%creates a variable which identifies all files in the directory
files = dir('*');

for i = 1:length(files)
    old = files(i).name;
    
    % Replace multiple consecutive _BL with a single _BL
    new = regexprep(old, '(_FU3)+', '_FU3');
    
    % Rename only if different from the original file
    if ~strcmp(old, new)
        movefile(old, new);
    end
end
