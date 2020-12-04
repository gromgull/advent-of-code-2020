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

 	findall( M, ( member(M, Password), M=Char ), List),
	length(List, Len),
	Len>=Min,
	Len=<Max.

:- phrase_from_file(data(Passwords), 'input-2.txt'),
   include(valid, Passwords, ValidPasswords),
   length(ValidPasswords, Len),
   write(Len).
