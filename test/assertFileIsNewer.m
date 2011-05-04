function assertFileIsNewer(fileA,fileB)
% ASSERTFILEEXISTS - assert that fileA is newer than fileB

a = dir(fileA);
b = dir(fileB);

assert(~isempty(a),'%s should exist but it doesn''t',fileA);
assert(~isempty(b),'%s should exist but it doesn''t',fileB);
assert(a.datenum >= b.datenum,'%s is not newer than %s', fileA, fileB);
