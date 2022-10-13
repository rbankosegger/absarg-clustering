% Test: If every clustered argument is a singleton, 
%		semantics should behave like the grounded semantics.
%		The example is taken from the lecture
%		Introduction to Formal Argumentation - Stefan Woltran (November 2020)

arg(a;b;c;d;e).
att(a,b).
att(c,b).	att(c,d).
att(d,c).	att(d,e).
att(e,e).

abs_map(a,a).	
abs_map(b,b).	
abs_map(c,c).
abs_map(d,d).
abs_map(e,e).

abs_arg(X) :- abs_map(_,X).
singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
