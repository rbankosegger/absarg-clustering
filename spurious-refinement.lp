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
abs_false_positive(X') :- abs_in(X'), 0 = #count{ X: in(X), abs_map(X,X')}.
#show abs_false_positive/1.

abs_false_negative(X') :- in(X), abs_map(X,X'), not abs_in(X').
#show abs_false_negative/1.

:~ abs_false_negative(C). [1@2,C]
:~ abs_false_positive(C). [1@2,C]

refinement_candidate(C) :- abs_false_positive(C).
refinement_candidate(C) :- abs_false_negative(C).
refinement_candidate(C) :- refinement_candidate(A), singleton(A), abs_att(C,A).

abs_arg_size(C,S) :- abs_arg(C), S = #count{ A : abs_map(A, C) }.
1 = { abs_split(A, (C, 1..S)) } :- abs_map(A,C), refinement_candidate(C), not singleton(C), abs_arg_size(C,S).
:- abs_split(A1, C), abs_split(A2, C), in(A1), not in(A2).
:- abs_split(A1, C), abs_split(A2, C), att(A1, S), not att(A2, S), singleton(S), refinement_candidate(S).
:~ abs_split(A, (C,N)). [1@1,C,N]
#show abs_split/2.

abs_map_refined(A,(C,I)) :- abs_split(A,(C,I)).
abs_map_refined(A,C) :- abs_map(A,C), not abs_split(A,(C,_)).

