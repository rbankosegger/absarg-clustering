abs_map(a,abce).	
abs_map(b,abce).	
abs_map(c,abce).
abs_map(d,d).
abs_map(e,abce).

abs_arg(X) :- abs_map(_,X).
singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
