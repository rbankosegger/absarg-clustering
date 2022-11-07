abs_false_positive(X') :- abs_in(X'), 0 = #count{ X: in(X), abs_map(X,X')}.
#show abs_false_positive/1.

abs_false_negative(X') :- in(X), abs_map(X,X'), not abs_in(X').
#show abs_false_negative/1.

:~ abs_false_negative(C). [1@2,C]
:~ abs_false_positive(C). [1@2,C]

refinement_candidate(C) :- abs_false_positive(C).
refinement_candidate(C) :- abs_false_negative(C).
refinement_candidate(C) :- refinement_candidate(S), singleton(S), abs_att(C,S).
refinement_candidate(C) :- refinement_candidate(S), singleton(S), abs_att(S,C).

abs_arg_size(C,S) :- abs_arg(C), S = #count{ A : abs_map(A, C) }.
1 = { abs_split(A, (C, 1..S)) } :- abs_map(A,C), refinement_candidate(C), not singleton(C), abs_arg_size(C,S).
:- abs_split(A1, C), abs_split(A2, C), in(A1), not in(A2).
:- abs_split(A1, C), abs_split(A2, C), att(A1, S), not att(A2, S), refinement_candidate(S).
:- abs_split(A1, C), abs_split(A2, C), att(S, A1), not att(S, A2), singleton(S), refinement_candidate(S).
splits(C,M) :- M=#count { N : abs_split(_, (C,N)) }, refinement_candidate(C), not singleton(C).
:- splits(C,M), I=1..M, not abs_split(_,(C,I)).
:- splits(_, M), M<=1.
#show splits/2.
:~ abs_split(A, (C,N)). [1@1,C,N]
#show abs_split/2.
#show refinement_candidate/1.

abs_map_refined(A,(C,I)) :- abs_split(A,(C,I)).
abs_map_refined(A,C) :- abs_map(A,C), not abs_split(A,(C,_)).

spurious :- abs_false_negative(_).
spurious :- abs_false_positive(_).
#show spurious/0.
