function strs = parseShellString(str)
% PARSESHELLSTRING - parse a list of space-delimited arguments as a shell might, accounting for quote and escapes
% 
% Note that PARSESHELLSTRING does *not* support file globbing with '*' or
% variable expansion or other such advanced features.
% 
% returns STRS, a cell array of arguments in the order they appear in STR

IFS = {sprintf(' ') sprintf('\t') sprintf('\n')};

% Run unit tests if DEBUG_PARSE_SHELL_STRING is set in the base workspace
% Use function t(in,out,ex) (defined below) to ensure 
% parseShellString(in) == out or it fails with exception 'ex'
if nargin == 0 && evalin('base','exist(''DEBUG_PARSE_SHELL_STRING'',''var'') && DEBUG_PARSE_SHELL_STRING')
    t('hello',{'hello'});
    t('hello world',{'hello' 'world'});
    t('"hello world"',{'hello world'});
    t('"hello world" more',{'hello world' 'more'});
    t('a b c "d e f"',{'a' 'b' 'c' 'd e f'});
    t('"hello escaped\" quote" part',{'hello escaped" quote' 'part'});
    t('''a b\ c\'' d'' "1 2 3"',{'a b\ c'' d' '1 2 3'});
    t('"trailing whitespace  " x y',{'trailing whitespace  ' 'x' 'y'});
    t('multiple    spaces',{'multiple' 'spaces'});
    res = parseShellString(sprintf(' \t\n'));
    assert(iscellstr(res) && isempty(res));
    res = parseShellString('');
    assert(iscell(res) && isempty(res));
    res = parseShellString('hello');
    assert(iscell(res));
    t('unfinished escape \',{},'MJB:parseShellString:IncompleteEscape');
    t('unfinished "quote',  {},'MJB:parseShellString:IncompleteQuote');
    t('unfinished ''quote', {},'MJB:parseShellString:IncompleteQuote');
    fprintf('all tests passed\n');
    nargout = 0; %#ok<NASGU>
    return;
elseif nargin == 0 || nargin > 1
    error('MJB:parseShellString:Arguments','parseShellString requires one argument');
end

strs = {};

tok = zeros(size(str));
tokidx = 1;

inDoubleQuote = false;
inSingleQuote = false;

i = 1;
while i <= length(str)
    % Use a state-based parsing algorithm.
    switch str(i)
        case '\'
            if inDoubleQuote && str(i+1) ~= '"'
                % Print literal \ when inside a "quote" and not escaping \"
                tok(tokidx) = str(i);
                tokidx = tokidx+1;
            elseif inSingleQuote && str(i+1) ~= ''''
                % Print literal \ when inside a 'quote' and not escaping \'
                tok(tokidx) = str(i);
                tokidx = tokidx+1;
            else
                % Ignore the \ and print whatever comes afterwards
                i = i+1;
                if i > length(str)
                    error('MJB:parseShellString:IncompleteEscape','Incomplete escape sequence at end of string');
                end
                tok(tokidx) = str(i);
                tokidx = tokidx+1;
            end
        case '"'
            if inSingleQuote
                tok(tokidx) = str(i);
                tokidx = tokidx+1;
            elseif inDoubleQuote
                inDoubleQuote = false;
            else
                inDoubleQuote = true;
            end
        case ''''
            if inDoubleQuote
                tok(tokidx) = str(i);
                tokidx = tokidx+1;
            elseif inSingleQuote
                inSingleQuote = false;
            else
                inSingleQuote = true;
            end
        case IFS
            if inDoubleQuote || inSingleQuote
                tok(tokidx) = str(i);
                tokidx = tokidx+1;
            elseif tokidx > 1
                % Only save a token if it actually has characters
                strs{end+1} = char(tok(1:tokidx-1));
                tok = zeros(1,length(str)-i);
                tokidx = 1;
            end
        otherwise
            tok(tokidx) = str(i);
            tokidx = tokidx+1;
    end
    i = i+1;
end

if inDoubleQuote || inSingleQuote
    % We're done parsing, but still in a quote. This is an error.
    if inDoubleQuote, quoteChar = '"'; end
    if inSingleQuote, quoteChar = ''''; end
    error('MJB:parseShellString:IncompleteQuote',['Unmatched ' quoteChar ' in input']);
end

% Save the final token
lastTok = char(tok(1:tokidx-1));
if ~isempty(lastTok)
    strs{end+1} = char(lastTok);
end
end

% Test function
function t(in,out,fail)
    if nargin == 3
        msg = ['Test case ''' in ''' failed to produce exception ''' fail ''''];
        try 
            parseShellString(in);
            assert(false,msg);
        catch EX
            assert(strcmp(EX.identifier,fail),msg);
        end
    else
        result = parseShellString(in);
        assert(all(strcmp(result,out)),['Test case ''' in ''' failed']);
    end
end
