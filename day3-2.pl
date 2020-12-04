:- use_module(library(dcg/basics)).

parse(Y,X) --> parse(0,0,Y,X).

parse(Y,X,Y,X) --> eos.
parse(Y, _, YMax, XMax) --> line(0,Y,X), { succ(Y, Y2) }, parse(Y2, X, YMax, XMax).

line(X,_,X) --> blank.
line(X,Y,X3) --> ".", { succ(X, X2) }, line(X2, Y, X3).
line(X,Y,X3) --> "#", { assert(tree(X,Y)), succ(X, X2) }, line(X2, Y, X3).

traverse(X,Y,_,_,Trees,Trees):-
	maxY(MaxY),
	Y >= MaxY.

traverse(X,Y,Sx,Sy,TreesSoFar,TreeTotal):-
	maxX(MaxX),
	Tx is X mod MaxX,

	( tree(Tx,Y), Temp is TreesSoFar+1 ; \+tree(Tx,Y), Temp = TreesSoFar),
	NewX is X+Sx,
	NewY is Y+Sy,
	traverse(NewX,NewY,Sx,Sy,Temp,TreeTotal).


:- phrase_from_file(parse(Y,X), 'input-3.txt'),

   assert(maxY(Y)),
   assert(maxX(X)),
   write(Y), nl,
   write(X), nl,

   traverse(0,0,1,1,0,T1),
   traverse(0,0,3,1,0,T2),
   traverse(0,0,5,1,0,T3),
   traverse(0,0,7,1,0,T4),
   traverse(0,0,1,2,0,T5),

   A is T1*T2*T3*T4*T5,

   write(A), nl.
