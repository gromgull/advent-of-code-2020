:- use_module(library(dcg/basics)).

parse([]) --> [].
parse([I|T]) --> integer(I), blanks, parse(T).

select3(H, [H|L], L).
select3(H2, [_|[H2|L]], L).
select3(H3, [_|[_|[H3|L]]], L).

solution(_, Max, Max, []).
solution(L, C, Max, [E|OutList]) :-

	select3(E, L, L2),
	R is E-C,
	R =< 3,

	solution(L2, E, Max, OutList).

split3([_], Streak, [Streak]).

split3([X|[Y|T]], Streak, [[X|Streak]|L]) :-
	R is Y-X,
	R == 3,
	split3([Y|T], [], L).

split3([X|[Y|T]], Streak, L) :-
	R is Y-X,
	R \== 3,
	split3([Y|T], [X|Streak], L).

solutions([_], 1).
solutions([Min|L], Len) :-
	last(L, Max),
	findall(Out, solution(L, Min, Max, Out), AllOut),
	length(AllOut, Len).

prodlist([], 1).
prodlist([H|T], Res) :- prodlist(T, P), Res is H*P.

is_empty([]).

:- phrase_from_file(parse(L), 'input-10.txt'),

   max_list(L, Max),
   Device is Max+3,
   sort([Device|L], Sorted),

   write(Sorted), nl,

   split3([0|Sorted], [], AllChunks),

   exclude(is_empty, AllChunks, RChunks),
   maplist(reverse, RChunks, Chunks),

   write(Chunks), nl,

   maplist(solutions, Chunks, Out),

   write(Out), nl,

   prodlist(Out, Res),
   write(Res), nl.
