:- use_module(library(dcg/basics)).

parse(_) --> eos.

parse(N) --> instruction(I), blank, integer(A), { assert(instr(N, I, A)), succ(N, N2) }, "\n", parse(N2).

instruction(I) --> nonblanks(C), { string_codes(S, C), atom_string(I, S) }.

set(Var, Val) :- retractall(var(Var, _)), assertz(var(Var, Val)).

exec(N, nop, _, Next) :- succ(N, Next).

exec(N, jmp, Arg, Next) :- Next is N+Arg.

exec(N, acc, Arg, Next) :-
	var(acc, V),
	V2 is V+Arg,
	set(acc, V2),
	succ(N, Next).

find_loop_val(N,A) :-
	assert(var(acc,0)),
	find_loop(N, []),
	var(acc, A).

find_loop(N, L) :-
	member(N, L).

find_loop(N, L):-
	\+ member(N, L),
	instr(N, Op, Arg),
	exec(N, Op, Arg, Next),

	find_loop(Next, [N|L]).

:- phrase_from_file(parse(0), 'input-8.txt'),

   findall(_, ( instr(N, Op, Arg), write(instr(N, Op, Arg)), nl ), _),
   trace,
   find_loop_val(0, A),
   write(A).
