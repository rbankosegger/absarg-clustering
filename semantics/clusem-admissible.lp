{ abs_in(X) : abs_arg(X) }.
:- abs_in(X), abs_in(Y), abs_att(X,Y), singleton(X), singleton(Y).

abs_defeated(X) :- abs_in(Y), abs_att(Y,X), singleton(Y).
{ abs_defeated(X) } :- abs_in(Y), abs_att(Y,X), not singleton(Y).
:- abs_in(X), abs_att(Y,X), not abs_defeated(Y), singleton(X).

#show abs_in/1.
