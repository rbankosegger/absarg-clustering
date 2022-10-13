defended(X) | defeated(X) :- arg(X).
defended(X) :- arg(X), defeated(Y) : att(Y,X).
defeated(X) :- defended(Y), att(Y,X).
:- defended(X), not defeated(Y), att(Y,X).
:- defeated(X), not defended(Y) : att(Y,X).
in(X) :- defended(X), not defeated(X).
#show in/1.
