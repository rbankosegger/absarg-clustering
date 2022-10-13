abs_map(a,abgh).	
abs_map(b,abgh).	
abs_map(c,c).
abs_map(d,d).
abs_map(e,e).
abs_map(f,f).
abs_map(g,abgh).
abs_map(h,abgh).


abs_arg(X) :- abs_map(_,X).
singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
