% Clustered stable semantics for clustured argumentation frameworks

{ abs_in(X) : abs_arg(X) }.

% 1) Conflict-free
:- abs_in(X), abs_in(Y), abs_att(X,Y), singleton(X), singleton(Y).


% 2) IF 		not abs_in(b) 	
%	 THEN	 	there is abs_in(a) with abs_att(a,b)
%		
%		Apply modus tollens!
%		IF		no abs_in(a) with abs_att(a,b)
%		THEN	abs_in(b)

abs_in(Y) :- abs_arg(Y), not abs_in(X) : abs_att(X,Y).


% 3) IF 		abs_in(a), E does not attack a, abs_att(a,b), singleton(b)
%	 THEN		not abs_in(b)

abs_defeated(Y) :- abs_in(X), abs_att(X,Y).
not abs_in(B) :- abs_in(A), not abs_defeated(A), abs_att(A,B), singleton(B).

#show abs_in/1.
