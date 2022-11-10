# Studies in clustered Argumentation Frameworks

## TL;DR

## Preliminaries

https://proceedings.kr.org/2021/52/

### Argumentation frameworks

Given a finite set of arguments $A$ and
an attack relation $R \subseteq A \times A$ we define
an argumentation framework (AF) as
$F = (A,R)$
per usual.


We consider conflict-free, admissible and stable extensions
(respectively $cf(F), adm(F), stb(F) \subseteq 2^A$)
defined in the standard way based on the characteristic function
$\mathcal F _F (S) = \\{ x \in A \mid \forall (y,x) \in R : \exists z \in S : (z,y) \in R \\}$.
* $S \in cf(F)$ iff there are no $a, b \in S$ such that $(a,b) \in R$. 
* $S \in adm(F) \subseteq cf(F)$ iff $S \subseteq \mathcal F _F (S)$
* $S \in stb(F) \subseteq cf(F)$ iff $\forall a \in A \setminus S : \exists (b,a) \in R : b \in S$
* ...
* $cf(F) = \\{ S \subseteq A \mid \forall (a,b) \in R : a \not \in S \lor b \not \in S \\}$
* $adm(F) = \\{ S \in cf(F) \mid S \subseteq \mathcal F _F (S) \\}$
* $stb(F) = \\{ S \in cf(F) \mid \forall a \in A \setminus S : \exists (b,a) \in R : b \in S \\}$

We will refer to these definition as the "classical" or "concrete" ones, 
as opposed to the "clustered" ones defined next.

### Existentially clustered Argumentation Frameworks

Based on a classical $F = (A,R)$
and a surjective mapping $m : A \mapsto \hat A$
we define a clustered AF $\hat F = (\hat A, \hat R)$ with
$\hat R =  \\{ (\hat a, \hat b) \mid (a, b) \in R \land m(a) = \hat a \land m(b) = \hat b \\}$.

The mapping $m$ and the clustered arguments $\hat a \in \hat A$ induce a partition over the classical arguments:
$ A = \biguplus _ {\hat a \in \hat A} m^{-1}(\hat a)$.
Let $single(\hat A) = \\{ \hat a \in \hat A \mid |m^{-1}(\hat a)| = 1 \\}$
denote the set of singleton clustered arguments.



define...
	single(E)
	definition 10
		cf, adm, stb
		
	definition 8
		abstracting, spurious, faithful

### Implementaton of confrict-flee and admissible clustered semantics

provided in the paper


### Examples from the paper
### Simonshaven example


## Implementation of clustered stable semantics
## Finding spurious extensions
## Spurious extension guided abstraction refinement
## Exhaustive search for smalles abstraction

## Future work
