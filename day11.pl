:- use_module(library(dcg/basics)).

parse([]) --> eos.
parse([H|T]) --> parse_line(H), parse(T).

parse_line([]) --> "\n" .
parse_line([]) --> eos .
parse_line([s|T]) --> "L", parse_line(T).
parse_line([f|T]) --> ".", parse_line(T).

seat(L,[X,Y]) :-
	width(W),
	height(H),

	X>0,
	Y>0,
	X=<W,
	Y=<H,
	C is (Y-1)*W+X-1,
	nth0(C, L, o).

add(X, Y, [Xd, Yd], [Nx, Ny]) :-
	Nx is X+Xd,
	Ny is Y+Yd.

count(_, _, 0, []) :- !.

count(L, 0, Y, OutL) :-
	succ(Y2, Y),
	width(W),
	count(L, W, Y2, OutL), !.

count(L, X, Y, [R|OutL]) :-
	Coords = [ [-1,-1], [0,-1], [1,-1],
			   [-1, 0],         [1, 0],
			   [-1, 1], [0, 1], [1, 1] ],

	findall(CC, (member(C, Coords), add(X,Y,C,CC), seat(L, CC)), Counts),
	length(Counts, R),
	succ(X2, X),
	count(L, X2, Y, OutL), !.

step([], _, []).
step([s|L], [0|Counts], [o|OutL]) :- step(L, Counts, OutL).
step([s|L], [C|Counts], [s|OutL]) :- C > 0, step(L, Counts, OutL).
step([f|L], [_|Counts], [f|OutL]) :- step(L, Counts, OutL).
step([o|L], [C|Counts], [s|OutL]) :- C >=4, step(L, Counts, OutL) .
step([o|L], [C|Counts], [o|OutL]) :- C < 4, step(L, Counts, OutL) .

step(L, OutL) :-
	width(W),
	height(H),
	count(L, W, H, RCounts),
	reverse(RCounts, Counts),
	write("."),
	% print(L), nl, print(Counts), nl, nl,
	step(L, Counts, OutL), !.


converge(L, Final) :-
	step(L, Next),
	( L = Next, Final = L, ! ; L \= Next, !, converge(Next, Final) ).


symbol(f, '.').
symbol(s, 'L').
symbol(o, '#').
symbol(X,X).

print([],_).

print([H|T], 0):-
	symbol(H, S),
	write(S),
	nl,
	width(W),
	W2 is W-1,
	print(T, W2).

print([H|T], C):-
	symbol(H, S),
	write(S),
	succ(C2, C),
	print(T, C2).

print(L):-
	width(W),
	W2 is W-1,
	print(L, W2).

:- phrase_from_file(parse(L), 'input-11.txt'),

   length(L, H),
   [Row|_] = L,
   length(Row, W),
   assert(height(H)),
   assert(width(W)),

   flatten(L, Flat),
   write(L), nl,

   converge(Flat, O),

   step(O,_),

   findall(a, member(o, O), Res),
   length(Res, N),
   write(O), nl,
   write(N).
