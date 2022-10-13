{ abs_in(X) : abs_arg(X) }.
:- abs_in(X), abs_in(Y), abs_att(X,Y), singleton(X), singleton(Y).
#show abs_in/1.
