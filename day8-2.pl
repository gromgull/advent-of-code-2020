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

run() :-
	set(acc, 0),
	set(exc, 0),
	run(0, []).

run(N, L) :-
	member(N, L), set(exc, 1), !.

run(N, L):-
	\+ member(N, L),
	instr(N, Op, Arg),
	exec(N, Op, Arg, Next),

	run(Next, [N|L]), !.

run(N, L):-
	\+ member(N, L),
	\+ instr(N, _, _), !.

save([]).
save([H|T]) :- assertz(H), save(T).

dump() :- findall(_, ( instr(N, Op, Arg), write(instr(N, Op, Arg)), nl ), _), nl.

:- phrase_from_file(parse(0), 'input-8.txt'),

   findall(instr(N, Op, Arg), instr(N, Op, Arg) , Program),

   %dump(),

   (
	   member(instr(N, jmp, Arg), Program),
	   select(instr(N, jmp, Arg), Program, instr(N, nop, Arg), NewProgram) ;
	   member(instr(N, nop, Arg), Program),
	   select(instr(N, nop, Arg), Program, instr(N, jmp, Arg), NewProgram)
   ),
   retractall(instr(_,_,_)),
   save(NewProgram),

   %dump(),

   run(),
   var(exc, 0),
   var(acc, A),
   write(A).
