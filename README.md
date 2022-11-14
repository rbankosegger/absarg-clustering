# Studies in clustered Argumentation Frameworks

## TL;DR

* We try to simplify Dung-Style Argumentation Frameworks (AFs) by partitioning arguments into clusters
* We implement conflict-free, admissible and stable semantics for clustered arguments
* We implement a method to identify spurious partitions which do not preserve the semantics of the original AF
* We implement methods to automatically compute non-spurious partitions
* All implementations are done in Answer Set Programming (ASP) and Python 3

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
* $cf(F) = \\{ S \subseteq A \mid \forall a,b \in S : (a,b) \not \in R \\}$
* $adm(F) = \\{ S \in cf(F) \mid S \subseteq \mathcal F _F (S) \\}$
* $stb(F) = \\{ S \in cf(F) \mid \forall a \in A \setminus S : \exists (b,a) \in R : b \in S \\}$

We will refer to these definition as the "classical" or "concrete" ones, 
as opposed to the "clustered" ones defined next.

### Existentially clustered Argumentation Frameworks

Based on a classical $F = (A,R)$
and a surjective mapping $m : A \mapsto \hat A$
we define a clustered AF $\hat F = (\hat A, \hat R)$ with
$\hat R =  \\{ (\hat a, \hat b) \mid (a, b) \in R \land m(a) = \hat a \land m(b) = \hat b \\}$.

For convenience we extend $m$ as follows:
* $m(S) = \\{ m(a) \mid a \in A \\}$
* $m(F) = \hat F = (\hat A, \hat R)$

The mapping $m$ and the clustered arguments $\hat a \in \hat A$ induce a partition over the classical arguments:
$A = \biguplus _ {\hat a \in \hat A} m^{-1}(\hat a)$.
Let $single(\hat A) = \\{ \hat a \in \hat A \mid |m^{-1}(\hat a)| = 1 \\}$
denote the set of singleton clustered arguments.

We define conflict-free, admissible and stable extensions for the clustered AF
(respectively $\hat {cf}(\hat F), \hat {adm}(\hat F), \hat {stb}(\hat F) \subseteq 2^{\hat A}$).
* $\hat {cf}  ( \hat F) = \\{ \hat E \subseteq \hat A \mid \forall \hat a, \hat b \in single(\hat E): (\hat a, \hat b) \not \in \hat R \\} $
* $\hat {adm} ( \hat F) = \\{ \hat E \in \hat {cf} ( \hat F) \mid \forall \hat a \in single(\hat E) : (\hat b, \hat a) \in \hat R \rightarrow \exists \hat c \in \hat E : (\hat c, \hat b) \in \hat R \\} $
* $\hat {stb} ( \hat F) = \\{ \hat E \in \hat {cf} ( \hat F) \mid ( \hat b \not \in \hat E \rightarrow \exists \hat a \in \hat E : (\hat a, \hat b) \in \hat R) \land (\forall \hat \a \in \hat E : (\lnot \exists \hat x \in \hat E : (\hat x, \hat a) \in \hat R) \land (\hat a, \hat b) \in \hat R \land \hat b \in single(\hat A) ) \rightarrow \hat b \not \in \hat E \\}$

Finally, for some $F$, mapping $m$  and classical (resp. clustered) semantics $\sigma(F)$ ( $\hat \sigma (m(F))$ ), 
we say that:
* $\hat E \in \hat \sigma (m(F))$ is spurious w.r.t. $F$ under $\sigma$ if $\not \exists E \in \sigma (F) : m(E) = \hat E$
* $m(F)$ under $\hat \sigma$ is faithful w.r.t. $F$ under $\sigma$ if there is no spurious $\hat E \in \hat \sigma ( \hat m(F) )$ w.r.t $F$ under $\sigma$.



provided in the paper


### Examples from the paper
### Simonshaven example


## Implementation of clustered semantics

The "input" answer set programs for $F=(A,R)$ and $m : A \mapsto \hat A$ are defined as follows:
* $\pi_F = \\{ \textbf{arg} (a). \mid a \in A \\} \cup \\{ \textbf{att} (a,b). \mid (a,b) \in R \\}$.
* $\pi_m = \\{ \textbf{abs\\_map} (a, \hat a). \mid a \in A, m(a) = \hat a \\}$

Programs of this type can be found in the `/examples` and `/tests` directories.

The induced $m(F) = \hat F = (\hat A, \hat R)$ can be computed with:

	abs_arg(X) :- abs_map(_,X).
	singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
	abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
	
The above program can be found in `to-clustered-af.lp`. 
In the text we refer to it also as $\pi_{m(F)}$.

All semantics-programs can be found in the folder `/semantics`.
The classical semantics are defined as usual in the ASPARIX framework,
where $\textbf{in} (a)$ is true in some answer set iff $a \in S$ 
for the extension $S$ that corresponds to that answer set.

TODO: Reference!

We will refer to the encoding of the 
classical (resp. clustered) semantics as $\pi_{\sigma}$ ( $\pi_{\hat \sigma}$).

### Clustered Conflict-Free and Clustered Admissible Semantics

The ASP implementation of these semantics are described in the paper.

TODO: Reference

For the Clustered Conflict-Free case we have:

	{ abs_in(X) : abs_arg(X) }.
  	:- abs_in(X), abs_in(Y), abs_att(X,Y), singleton(X), singleton(Y).
	
For the Clustered Admissible semantics we extend the above by:

	abs_defeated(X) :- abs_in(Y), abs_att(Y,X), singleton(Y).
	{ abs_defeated(X) } :- abs_in(Y), abs_att(Y,X), not singleton(Y).
	:- abs_in(X), abs_att(Y,X), not abs_defeated(Y), singleton(X).

### Clustered Stable Semantics

These semantics were the first implementation task for this project.
It was implemented as follows:

	{ abs_in(X) : abs_arg(X) }.
	:- abs_in(X), abs_in(Y), abs_att(X,Y), singleton(X), singleton(Y).
	abs_in(Y) :- abs_arg(Y), not abs_in(X) : abs_att(X,Y).
	abs_defeated(Y) :- abs_in(X), abs_att(X,Y).
	not abs_in(B) :- abs_in(A), not abs_defeated(A), abs_att(A,B), singleton(B).
  
The third line was inspired by the ASPRIX-Implementation of the classical stable semantics.

To ensure correctness, we tested the semantics with several instances:
 * `tests/cstable-1` ensures the clustered semantics reduce to the classical ones when every clustered argument is singleton
 * `/tests/cstable-2` ensures that not-attacked clusters are always accepted, always-attacked singletons are never accepted and always-attacked clusteres can be both accepted or not.
 * `/tests/cstable-3` and `/tests/cstable-4` have different concrete AF's but their mapping induces the same clustered AF. Thus, their clustered semantics should yield the same extensions.

To run the tests, execute in a terminal:

	. 1-clustered-stable-semantics-examples.sh

## Identifying spurious clustered extensions

Given some $F$, $m$, $\hat F = m(F), \sigma$ and $\hat E \in \hat \sigma (\hat F)$.
How can we know whether the extension $\hat E$ is spurious?
We need to find an $E \in \sigma(F)$ such that $m(E) = \hat E$ if no such $E$ can be found, 
we know that $\hat E$ is spurious..

Recall the ASP encodings defined above:
* $\pi_F = \\{ \textbf{arg} (a). \mid a \in A \\} \cup \\{ \textbf{att} (a,b). \mid (a,b) \in R \\}$.
* $\pi_m = \\{ \textbf{abs\\_map} (a, \hat a). \mid a \in A, m(a) = \hat a \\}$
* $\pi_{m(F)}$ (found in `to-clustered-af.lp`) to deduce $\textbf{abs\\_arg}/1$, $\textbf{singleton}/1$ and $\textbf{abs\\_att}/2$.
* $\pi_{\sigma}$ to deduce $\textbf{in}/1$
* $\pi_{\hat \sigma}$ to deduce $\textbf{abs\\_in}/1$

Consider the program 
$\pi_F \cup \pi_m \cup \pi_{m(F)} \cup \pi_\sigma \cup \pi_{\hat \sigma}$.
The answer sets of this combination yield the cross product of classical and clustered extensions
$(X, \hat X) \in \sigma(F) \times \hat \sigma( \hat F)$.

Second, we need to eliminate combinations of $X$ and $\hat X$ where $m(X) \not = \hat X$.
This is done by adding two constraints:

	:- abs_in(X'), 0 = #count{ X: in(X), abs_map(X,X')}.
 	:- in(X), abs_map(X,X'), not abs_in(X').
	
Let's refer to these two constraints as $\pi_{m(X) = \hat X}$.

Finally, we need to constrain the search to clustered extensions that map to $\hat E$.
Let's encode $\hat E$ as the answer set program 
$\pi_{\hat E} = \\{ \textbf{abs\\_in}(\hat a) \mid \hat a \in \hat E \\} \cup \\{ \textbf{-abs\\_in}(\hat a) \mid \hat a \in \hat A \setminus \hat E  \\}$
and add it to constrain the answer sets accordingly.
The final procedure is:

$\mathcal {AS} ( \pi_F \cup \pi_m \cup \pi_{m(F)} \cup \pi_\sigma \cup \pi_{\hat \sigma} \cup \pi_{m(X) = \hat X} \cup \pi_{\hat E} ) \cong \\{ X, \hat X \mid X \in \sigma(F) \land \hat X \in \hat \sigma(\hat F) \land m(X) = \hat X \land \hat X = \hat E \\}$

If there are no answer sets, then no $X$ corresponding to $\hat E$ could be found, 
i.e. $\hat E$ is spurious.

To see examples of this, investigate and run `2-is-extension-spurious.sh`.

## Identifying spurious abstraction mappings

Given some $F$, $m$, $\hat F = m(F)$ and $\sigma$ we would like 
to know whether some $\hat E \in \hat \sigma (\hat F)$ is spurious.

The above procedure can be extended to achieve this by looping though the clustered extensions:

> for $\hat E \in \mathcal {AS} ( \pi_F \cup \pi_m \cup \pi_{m(F)} \cup \pi_{\hat \sigma} )$:
>> $Q \leftarrow \mathcal {AS} ( \pi_F \cup \pi_m \cup \pi_{m(F)} \cup \pi_\sigma \cup \pi_{\hat \sigma} \cup \pi_{m(X) = \hat X} \cup \pi_{\hat E} )$
>>
>> if $Q = \emptyset$ return "spurious!"
>>
> return "not spurious!"

This was implemented as a python program using `clingo` as answer set solver.
The code can be found in `find_spurious.py`.
Note that the procedure requres two nested calls to the `clingo` solver. 
The outer call is for computing the clustered extensions, 
the inner call to check whether that extension is spurious or not.

Note that besides $\pi_{\hat E}$ the code of the inner answer set program stays the same.
Thus, we utilize clingo's Solving under Assumptions feature:
The inner clingo program is grounded only once, before entering the loop.
Then, during the loop, $\hat E$ is passed to the solver in the form of assumptions.
This prevents unnecessary repetition of the grounding step and speeds up the program.

To see examples of this, investigate and run `3-find-spurious.sh`

## Spurious extension guided abstraction refinement
## Exhaustive search for smalles abstraction

## Future work
