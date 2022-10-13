% Test: If a clustred argument is in the stable extension 
%		and is itself not (possibly) defeated,
%		then all singletons attacked by it must be out of the extension.
%		However, attacked clustered arguments might still be in!

% Here: 
%	ab is for sure in (not attacked).
%	cd	can be in or out (attacked but clustered)
% 	e and f are for sure out (singletons attacked by unattacked ac)

%	Note that extension {ab, cd} abstracts the concrete extension {a, b, d}
%		but that extension {ab} is spurious.

arg(a;b;c;d;e;f).
att(a,c).	att(a,e).	att(a,f).
att(b,e).

abs_map(a,ab).	
abs_map(b,ab).	
abs_map(c,cd).
abs_map(d,cd).
abs_map(e,e).
abs_map(f,f).

abs_arg(X) :- abs_map(_,X).
singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
