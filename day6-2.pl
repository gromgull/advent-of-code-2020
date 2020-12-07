:- use_module(library(dcg/basics)).

parse([]) --> eos.

parse([H|T]) --> parse_group(H), parse(T).

parse_group([]) --> "\n".
parse_group([]) --> eos.

parse_group([H|T]) --> string(Hs), { string_codes(Hc, Hs), string_chars(Hc, H) }, "\n", parse_group(T).

all_member([], _).
all_member([L|T], E) :- member(E, L), all_member(T, E).


count(G, C) :-
	findall(E, all_member(G, E), L),
	length(L, C).


:- phrase_from_file(parse(Groups), 'input-6.txt'),
   write(Groups), nl,
   maplist(count, Groups, Counts),
   sum_list(Counts, Sum),
   write(Sum), nl.
