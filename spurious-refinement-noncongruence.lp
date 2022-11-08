abs_false_positive(X') :- abs_in(X'), 0 = #count{ X: in(X), abs_map(X,X')}.

abs_false_negative(X') :- in(X), abs_map(X,X'), not abs_in(X').

:~ abs_false_negative(C). [1@1,C]
:~ abs_false_positive(C). [1@1,C]

refinement_candidate(C) :- abs_false_positive(C).
refinement_candidate(C) :- abs_false_negative(C).
refinement_candidate(C) :- refinement_candidate(S), singleton(S), abs_att(C,S).
refinement_candidate(C) :- refinement_candidate(S), singleton(S), abs_att(S,C).

refine(A,C) :- refinement_candidate(C), abs_map(A,C).

-congruent(A1, A2) :- refine(A1,C), refine(A2,C), in(A1), not in(A2).
-congruent(A1,A2) :- refine(A1,C), refine(A2,C), att(A1,S), not att(A2,S), refinement_candidate(S).
-congruent(A1,A2) :- refine(A1, C), refine(A2, C), att(S, A1), not att(S, A2), singleton(S), refinement_candidate(S).
#show -congruent/2.

spurious :- abs_false_negative(_).
spurious :- abs_false_positive(_).
#show spurious/0.








