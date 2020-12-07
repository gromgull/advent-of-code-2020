:- use_module(library(dcg/basics)).

parse([]) --> eos.

parse([H|T]) --> parse_group(H), parse(T).

parse_group([]) --> "\n".
parse_group([]) --> eos.

parse_group([H|T]) --> string(Hs), { string_codes(Hc, Hs), string_chars(Hc, H) }, "\n", parse_group(T).

count(G, C):-
 	maplist(list_to_set, G, S),
	foldl(union, S, [], U),
	length(U, C).


:- phrase_from_file(parse(Groups), 'input-6.txt'),
   write(Groups), nl,
   maplist(count, Groups, Counts),
   sum_list(Counts, Sum),
   write(Sum), nl.
