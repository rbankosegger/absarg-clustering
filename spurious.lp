% USEAGE: 
%	clingo <example-concrete> <example-abs> <sem> <asem> spurious.lp 0
%
% 	For example:
%	clingo e1-concrete.lp e1-abs2.lp sem-stable.lp asem-stable.lp spurious.lp 0
%
% External Predicates
% 	in(A)		 ... true if argument `A` is in the concrete extension (i.e. the answer set)
%   abs_map(A,C) ... true if concrete argument `A` maps onto clustered argument `C`
%	abs_in(C)	 ... true if clustered argument `C` is in the clustered extension (i.e. the answer set)
%
% INPUT:
%	A clustered extension via the abs_in/2 predicate.
%		abs_in(C) indicates that the clustered argument C is in the extension
%		-abs_in(C) indicates that it is not. (Important: absence of arguments must be specified as well!)
%
% OUTPUT:
% 	Answer sets are abstracting pairings between concrete and clustered extensions.
%	The answer set contains the 0-ary predicate `spurious` if a clustered argument 
%		couldn't be paired up with a concrete argument (i.e. the pairing is spurious)
% 	If no non-spurious answer set exists, then the fixed clustered extension is spurios.

% Remove concrete extensions that do not abstract the given clustered extension
:- abs_in(X'), 0 = #count{ X: in(X), abs_map(X,X')}.

spurious :- in(X), abs_map(X,X'), not abs_in(X').
:- spurious.
#show spurious/0.

