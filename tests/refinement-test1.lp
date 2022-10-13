% Test: Edge case for abstraction refinement

arg(a;b;c;d).
att(a,b).	att(a,c).
att(b,d).

abs_map(a,a).	
abs_map(b,bc).	
abs_map(c,bc).
abs_map(d,d).

abs_arg(X) :- abs_map(_,X).
singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
