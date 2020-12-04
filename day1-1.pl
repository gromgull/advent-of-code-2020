:- use_module(library(dcg/basics)).
ints([]) --> [].
ints([I|T]) --> integer(I), blanks, ints(T).



:- phrase_from_file(ints(L), 'input-1.txt'),
   member(X, L),
   member(Y, L),
   member(Z, L),
   S is X+Y+Z,
   S = 2020,
   P is X*Y*Z,
   write(X), nl,
   write(Y), nl,
   write(Z), nl,
   write(P), nl.
