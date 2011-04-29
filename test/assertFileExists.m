function assertFileExists(file)
% ASSERTFILEEXISTS - simple wrapper for assert(exist(file,'file'))

assert(exist(file,'file'),'File %s does not exist',file)
