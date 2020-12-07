:- use_module(library(dcg/basics)).

parse() --> "\n".
parse() --> eos.

parse() --> bag(Bag), " bags contain ", bags(Content), "\n", parse(), { assert(rule(Bag, Content)) }.
parse() --> bag(Bag), " bags contain no other bags.\n", parse(), { assert(rule(Bag, [])) }.

bags([bag(I, C)|T]) --> count_bag(I,C), more_bags(T).

more_bags([]) --> "." .
more_bags([bag(I, C)|T]) --> ", ", count_bag(I,C), more_bags(T).

count_bag(I, B) --> integer(I), blank, { I = 1 }, bag(B), " bag" .
count_bag(I, B) --> integer(I), blank, { I > 1 }, bag(B), " bags" .

bag(B) --> nonblanks(C1), blank, nonblanks(C2),
		   { string_codes(S1, C1),
			 string_codes(S2, C2),
			 string_concat(S1, "_", S1_),
			 string_concat(S1_, S2, S),
			 atom_string(B, S) }.

tally([], 0).
tally([bag(I, B)|T], C) :-
	carry(B, BagCount),
	tally(T, RestCount),
	C is I*BagCount + RestCount.

carry(B, C):-
	rule(B, Bags),
	tally(Bags, SubC),
	C is SubC+1.

:- phrase_from_file(parse(), 'input-7.txt'),
   carry(shiny_gold, C),
   C2 is C-1,
   write(C2), nl.
