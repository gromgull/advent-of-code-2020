:- use_module(library(dcg/basics)).

parse([]) --> [].
parse([I|T]) --> integer(I), blanks, parse(T).

prefix(L, L, [], 0).
prefix([H|T], L2, [H|T2], N) :- succ(N2, N), prefix(T, L2, T2, N2).


legal(Prefix, N) :-
	member(X, Prefix),
	member(Y, Prefix),
	N2 is X+Y,
	N = N2.

first_illegal(_, [], _).

first_illegal(Prefix, [N|_], N) :-
	\+ legal(Prefix, N).

first_illegal([P|Prefix], [N|List], Illegal) :-
	legal([P|Prefix], N),
	append(Prefix, [N], NextPrefix),
	first_illegal(NextPrefix, List, Illegal).

find_first_illegal(ListAll, N, Illegal) :-
	prefix(ListAll, List, Prefix, N),
	first_illegal(Prefix, List, Illegal).


:- phrase_from_file(parse(L), 'input-9.txt'),
   write(L), nl,
   find_first_illegal(L, 25, Illegal),
   write(Illegal), nl.
