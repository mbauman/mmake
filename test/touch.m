function touch(varargin)
% TOUCH mimic the unix utility touch on every argument

[result, status] = perl(fullfile(fileparts(mfilename),'touch.pl'),varargin{:});
if result ~= 0, error('MJB:perl:touch',status); end;
