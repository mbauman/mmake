function protectedStr = shellProtect(str)
% shellEscape - protect a string STR with single quotes '' to allow for passing to a shell

% Escape any existing single quotes in the string
protectedStr = strrep(str,'''','\''');

if iscell(str)
    for i=1:length(str)
        protectedStr{i} = ['''' protectedStr{i} ''''];
    end
else
    protectedStr = ['''' protectedStr ''''];
end
