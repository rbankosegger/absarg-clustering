abs_map(a,abcde).	
abs_map(b,abcde).	
abs_map(c,abcde).
abs_map(d,abcde).
abs_map(e,abcde).

abs_arg(X) :- abs_map(_,X).
singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
