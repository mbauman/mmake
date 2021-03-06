function [rules,vars] = MMakefile

% OBJS := a.${OBJ_EXT} b.${OBJ_EXT} linked.${OBJ_EXT}
vars.OBJS = {'a.${OBJ_EXT}' 'b.${OBJ_EXT}' 'linked.${OBJ_EXT}'};
vars.MEXFLAGS = '${MEXFLAGS} -g';

% pgm.${MEX_EXT}: ${OBJS}
%     mex $^ -output $@
rules(1).target = {'pgm.${MEX_EXT}'};
rules(1).deps = vars.OBJS;
rules(1).commands = 'mex ${MEXFLAGS} $^ -output $@';

% a.${OBJ_EXT}: a.h
rules(2).target = {'a.${OBJ_EXT}'};
rules(2).deps = {'a.h'};

% b.${OBJ_EXT}: b.h
rules(3).target = 'b.${OBJ_EXT}'; % Cell encapsulation is optional with only one elt
rules(3).deps = 'b.h';

rules(4).target = 'clean';
rules(4).commands = 'try; delete(''*.${OBJ_EXT}'',''*.${MEX_EXT}''); catch; end;';
