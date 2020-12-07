:- use_module(library(dcg/basics)).

parse([]) --> eos.

parse([H|T]) --> string(Hc), { string_codes(Hs, Hc), string_lower(Hs, Hl), string_chars(Hl, H) },blank, parse(T).

row([l|T], [l|T], _, 0).
row([r|T], [r|T], _, 0).
row([f|T], Rest, N, Row):- N2 is div(N,2), row(T, Rest, N2, Row).
row([b|T], Rest, N, Row):- N2 is div(N,2), row(T, Rest, N2, C2), Row is C2+N2.


col([], _, 0).
col([l|T], N, Col):- N2 is div(N,2), col(T, N2, Col).
col([r|T], N, Col):- N2 is div(N,2), col(T, N2, C2), Col is C2+N2.


code(Seat, Code):- row(Seat, Rest, 128, Row),
				   col(Rest, 8, Col),
				   Code is Row*8+Col.

:- phrase_from_file(parse(Seats), 'input-5.txt'),

   maplist(code, Seats, Codes),
   max_list(Codes, Max),
   between(0, Max, S),
   \+member(S, Codes),
   succ(S, After),
   succ(Before, S),
   member(After, Codes),
   member(Before, Codes),
   write(S), nl.
