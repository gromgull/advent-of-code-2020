:- use_module(library(dcg/basics)).


parse([]) --> eos.
parse([passport(P)|T]) --> parse_passport(P), parse(T).

parse_passport([]) --> "\n" ; eos.
parse_passport([f(Field, Value)|T]) --> string(FieldChars), ":", { atom_chars(Field, FieldChars) }, string(ValueChars), blank, { atom_chars(Value, ValueChars) }, parse_passport(T).


required([iyr, eyr, hgt, hcl, ecl, pid, byr]). % skip cid

valid(passport(Passport)):-
	required(R),
	valid(Passport, R, []).

valid(_, [], []).
valid(Passport, [H|T], T2):-
	member(f(H, _), Passport),
	valid(Passport, T, T2).

:- phrase_from_file(parse(Passports), 'input-4.txt'),
%   trace,
   include(valid, Passports, ValidPassports),
   write(ValidPassports), nl,
   length(ValidPassports, L),
   write(L), nl.
