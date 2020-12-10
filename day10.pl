:- use_module(library(dcg/basics)).

parse([]) --> [].
parse([I|T]) --> integer(I), blanks, parse(T).

diffs([X,Y], 1, 0) :- R is Y-X, R = 1.
diffs([X,Y], 0, 0) :- R is Y-X, R = 2.
diffs([X,Y], 0, 1) :- R is Y-X, R = 3.

diffs([X|[Y|T]], One, Three) :- R is Y-X, R = 1, diffs([Y|T], One2, Three), succ(One2, One).
diffs([X|[Y|T]], One, Three) :- R is Y-X, R = 2, diffs([Y|T], One, Three).
diffs([X|[Y|T]], One, Three) :- R is Y-X, R = 3, diffs([Y|T], One, Three2), succ(Three2, Three).

:- phrase_from_file(parse(L), 'input-10.txt'),
   write(L), nl,
   L2 = [0|L],
   sort(L2, Sorted),
   diffs(Sorted, One, Three_),
   succ(Three_, Three), % device is +3
   write(One), nl,
   write(Three), nl,
   R is One*Three,
   write(R), nl.
