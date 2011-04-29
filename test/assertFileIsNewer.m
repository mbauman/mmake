function assertFileIsNewer(fileA,fileB)
% ASSERTFILEEXISTS - assert that fileA is newer than fileB

a = dir(fileA);
b = dir(fileB);

assert(a.datenum >= b.datenum,'%s is not newer than %s', fileA, fileB);
