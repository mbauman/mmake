function [rules,vars] = MMakefile
% MMAKEFILE

% OBJS := a.o b.o linked.o
vars.OBJS = {'a.o' 'b.o' 'linked.o'};

% pgm.${MEX_EXT}: ${OBJS}
%     mex $^ -output $@
rules(1).target = {'pgm.${MEX_EXT}'};
rules(1).deps = vars.OBJS;
rules(1).commands = 'mex $^ -output $@';

% a.o: a.h
rules(2).target = {'a.o'};
rules(2).deps = {'a.h'};

% b.o: b.h
rules(3).target = 'b.o'; % Cell encapsulation is optional with only one elt
rules(3).deps = 'b.h';
