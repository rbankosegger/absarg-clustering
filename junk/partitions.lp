arg(a;b;c;d).
{ par(N) : N=1..M } :- M=#count{ A : arg(A) }.
:- par(N), not par(M), M=1..N.

1  = { map(A,P) : par(P) } :- arg(A).
1 <= { map(A,P) : arg(A) } :- par(P).

parsize(P, S) :- par(P), S=#count{ A : map(A,P) }.
:- parsize(P1,S1), parsize(P2,S2), P1<P2, S1>S2.

% TODO: bell number for 4 items is 15, we get only 13 answer sets!
:- parsize(P1,S1), parsize(P2,S2), P1<P2, S1=S2, map(A1,P1), map(A2,P2), A1>A2.

#show map/2.
% Bell numbers starting from zero: 1, 1, 2, 5, 15, 52, 203, 877, 4140
