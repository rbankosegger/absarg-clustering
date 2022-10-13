{ in(X) : arg(X) }.
:- in(X), in(Y), att(X,Y).
def(X) :- in(Y), att(Y,X).
:- in(X), att(Y,X), not def(Y).
#show in/1.
