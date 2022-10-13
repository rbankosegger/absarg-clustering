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
abs_should_be_out(X') :- abs_in(X'), 0 = #count{ X: in(X), abs_map(X,X')}.
#show abs_should_be_out/1.

abs_should_be_in(X') :- in(X), abs_map(X,X'), not abs_in(X').
#show abs_should_be_in/1.

:~ abs_should_be_out(X). [1@1,X]
:~ abs_should_be_in(X). [1@2,X]

abs_refine(X) :- abs_should_be_out(X), not singleton(X).
abs_refine(X) :- abs_should_be_in(X), not singleton(X).
% abs_refine(Y) :- abs_should_be_in(X), singleton(X), abs_att(Y,X).
% abs_refine(Y) :- abs_should_be_out(X), singleton(X), abs_att(Y,X).
#show abs_refine/1.

% TODO: This does not work e.g. for tests/refinement-test1.lp and tests/refinement-test2.lp
%abs_refmap(A,C) :- abs_map(A,C), not abs_refine(C).
%abs_refmap(A, split1(C)) :- abs_refine(C), abs_map(A,C), in(A).
%abs_refmap(A, split2(C)) :- abs_refine(C), abs_map(A,C), not in(A).
%#show abs_refmap/2.
