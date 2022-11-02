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
