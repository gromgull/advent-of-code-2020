:- use_module(library(dcg/basics)).

parse() --> "\n".
parse() --> eos.

parse() --> bag(Bag), " bags contain ", bags(Content), "\n", parse(), { assert(rule(Bag, Content)) }.
parse() --> bag(Bag), " bags contain no other bags.\n", parse(), { assert(rule(Bag, [])) }.

bags([bag(I, C)|T]) --> count_bag(I,C), more_bags(T).

more_bags([]) --> "." .
more_bags([bag(I, C)|T]) --> ", ", count_bag(I,C), more_bags(T).

count_bag(B, I) --> integer(I), blank, { I = 1 }, bag(B), " bag" .
count_bag(B, I) --> integer(I), blank, { I > 1 }, bag(B), " bags" .

bag(B) --> nonblanks(C1), blank, nonblanks(C2),
		   { string_codes(S1, C1),
			 string_codes(S2, C2),
			 string_concat(S1, "_", S1_),
			 string_concat(S1_, S2, S),
			 atom_string(B, S) }.

carry(Bag, InBag) :-
	rule(InBag, Content),
	member(bag(Bag, _), Content).

carry(Bag, InBag) :-
	rule(B2, Content),
	member(bag(Bag, _), Content),
	carry(B2, InBag).

:- phrase_from_file(parse(), 'input-7.txt'),

   findall(C, carry(shiny_gold,C), L),
   list_to_set(L, S),
   write(S), nl,
   length(S, Len),
   write(Len), nl.
