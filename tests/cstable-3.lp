% Test: If a clustered argument is in the stable extension 
%		and is itself not (possibly) defeated,
%		then all singletons attacked by it must be out of the extension.
%		However, attacked clustered arguments might still be in!
%		Also, if the clustered argument is in but itself attacked, 
%			the singletons attacked by it can be in as well (but don't have to be)!

% Here: 
%	a, bc are in for sure (not attacked).
%	de may be in or out
%	f, g may be in our out (independently of de, since de is maybe defeated, even if it is in)

%	The only concrete stable extension is {a, b, c, f, g}
%	This is abstracted by the clustered stable extension {a, bc, f, g}
%	The other clustered stable extensions are spurious:
%		{ a, bc, de }
%		{ a, bc, de, f}
%		{ a, bc, de, g}
%		{ a, bc, de, f, g}

arg(a;b;c;d;e;f;g).
att(a,e).	
att(b,d).
att(e,f).
att(d,g).
