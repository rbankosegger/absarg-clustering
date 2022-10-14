% Test: Edge case for abstraction refinement.

arg(a;b;c;d;e).
att(a,b).	att(a,c).
att(b,d).

arg(a1;b1;c1;d1;e1).
att(a1,b1).	att(a1,c1).
att(b1,d1).

abs_map(a,a).	
abs_map(b,x).	
abs_map(c,x).
abs_map(d,d).
abs_map(e,x).

abs_map(a1,a1).	
abs_map(b1,x).	
abs_map(c1,x).
abs_map(d1,d1).
abs_map(e1,x).

abs_arg(X) :- abs_map(_,X).
singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
