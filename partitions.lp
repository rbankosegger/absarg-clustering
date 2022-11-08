{ congruent(A,B) : abs_map(A,C), abs_map(B, C) }.
congruent(A,A) :- arg(A).
congruent(A,B) :- congruent(B,A).
congruent(A,C) :- congruent(A,B), congruent(B,C).

1 = { abs_split(A, (C,B)) : congruent(A, B) } :- abs_map(A,C).
:- abs_split(A, (X,B)), abs_map(A,X), congruent(A,C), C<B.
:~ abs_split(_, (C,N)). [1,C,N]
#show abs_split/2.
