% Test: If every clustered argument is a singleton, 
%		semantics should behave like the grounded semantics.
%		The example is taken from the lecture
%		Introduction to Formal Argumentation - Stefan Woltran (November 2020)

arg(a;b;c;d;e).
att(a,b).
att(c,b).	att(c,d).
att(d,c).	att(d,e).
att(e,e).
