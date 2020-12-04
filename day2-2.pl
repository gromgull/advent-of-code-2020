:- use_module(library(dcg/basics)).
data([]) --> [].
data([rule(Min,Max,Char, Password)|T]) -->
	integer(Min), "-", integer(Max),
	" ",
	string(CharC), { atom_chars(Char, CharC) },
	": ",
	string(PasswordC), { atom_chars(Password2, PasswordC), atom_chars(Password2, Password) },
	blanks, data(T).

valid(rule(Min, Max, Char, Password)):-
	( nth1(Min, Password, Char), nth1(Max, Password, NotChar), NotChar\=Char )
	;
	( nth1(Min, Password, NotChar), nth1(Max, Password, Char), NotChar\=Char ).


:- phrase_from_file(data(Passwords), 'input-2.txt'),
   include(valid, Passwords, ValidPasswords),
   length(ValidPasswords, Len),
   write(Len).
