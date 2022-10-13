in(X) :- arg(X), not att(_,X).
def(X) :- in(Y), att(Y,X).
in(X) :- 
{ in(X) : arg(X) }.
:- in(X), in(Y), att(X,Y).
:- in(X), att(Y,X), not def(Y).
#show in/1.
