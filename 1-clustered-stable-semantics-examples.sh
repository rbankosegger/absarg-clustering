echo "Figure 1(a) from the paper, classical stable semantics"
clingo --verbose=0 examples/e1-concrete.lp semantics/sem-stable.lp 0
echo "---"
echo "Figure 1(b) from the paper, clustered stable semantics"
clingo --verbose=0 examples/e1-concrete.lp examples/e1-clustered1.lp semantics/clusem-stable.lp 0
echo "---"
echo "Figure 1(c) from the paper, clustered stable semantics"
clingo --verbose=0 examples/e1-concrete.lp examples/e1-clustered2.lp semantics/clusem-stable.lp 0
echo "---"
echo "Figure 3(a) from the paper, classical stable semantics"
clingo --verbose=0 examples/e3-concrete.lp semantics/sem-stable.lp 0
echo "---"
echo "Figure 3(b) from the paper, clustered stable semantics"
clingo --verbose=0 examples/e3-concrete.lp examples/e3-clustered1.lp semantics/clusem-stable.lp 0
