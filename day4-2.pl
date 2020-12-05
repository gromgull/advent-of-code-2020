:- use_module(library(dcg/basics)).


parse([]) --> eos.
parse([passport(P)|T]) --> parse_passport(P), parse(T).

parse_passport([]) --> "\n" ; eos.
parse_passport([f(Field, Value)|T]) --> string(FieldChars), ":", { atom_chars(Field, FieldChars) }, string(ValueChars), blank, { atom_chars(Value, ValueChars) }, parse_passport(T).


required([byr, iyr, eyr, hgt, hcl, ecl, pid]). % skip cid

valid_c(A):- A>=97, A=<102. % a-f
valid_c(A):- A>=48, A=<57. % 0-9

valid_field(byr, Ya):- atom_string(Ya, Y), Y @>= "1920", Y @=< "2002" .
valid_field(iyr, Ya):- atom_string(Ya, Y), Y @>= "2010", Y @=< "2020" .
valid_field(eyr, Ya):- atom_string(Ya, Y), Y @>= "2020", Y @=< "2030" .
valid_field(hgt, Ha):- atom_string(Ha, H), string_concat(Ns, "cm", H), number_string(N, Ns), N @>= 150, N @=< 193.
valid_field(hgt, Ha):- atom_string(Ha, H), string_concat(Ns, "in", H), number_string(N, Ns), N @>= 59, N @=< 76.

valid_field(hcl, Ha):- atom_string(Ha, H), string_concat("#", C, H), string_codes(C, Cs), maplist(valid_c, Cs).

valid_field(ecl, amb).
valid_field(ecl, blu).
valid_field(ecl, brn).
valid_field(ecl, gry).
valid_field(ecl, grn).
valid_field(ecl, hzl).
valid_field(ecl, oth).

valid_field(pid, D) :- string_chars(D, Ds), maplist(is_digit, Ds), length(Ds,9).


valid(passport(Passport)):-
	required(R),
	valid(Passport, R, []).

valid(_, [], []).
valid(Passport, [H|T], T2):-
	member(f(H, V), Passport),
	valid_field(H,V),
	valid(Passport, T, T2).

:- phrase_from_file(parse(Passports), 'input-4.txt'),
   %trace,
   include(valid, Passports, ValidPassports),
   write(ValidPassports), nl,
   length(ValidPassports, L),
   write(L), nl.
