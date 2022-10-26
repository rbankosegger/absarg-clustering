echo "Figure 1(a) from the paper, classical stable semantics"
clingo --verbose=0 examples/e1.lp semantics/sem-stable.lp 0
echo "---"
echo "Figure 1(b) from the paper, clustered stable semantics"
clingo --verbose=0 examples/e1.lp examples/e1-map1.lp to-clustered-af.lp semantics/clusem-stable.lp 0
echo "---"
echo "Figure 1(c) from the paper, clustered stable semantics"
clingo --verbose=0 examples/e1.lp examples/e1-map2.lp to-clustered-af.lp semantics/clusem-stable.lp 0
echo "---"
echo "Figure 3(a) from the paper, classical stable semantics"
clingo --verbose=0 examples/e3.lp semantics/sem-stable.lp 0
echo "---"
echo "Figure 3(b) from the paper, clustered stable semantics"
clingo --verbose=0 examples/e3.lp examples/e3-map1.lp to-clustered-af.lp semantics/clusem-stable.lp 0
echo "---"
echo "Figure 3 from the paper all arguments in one big cluster, clustered stable semantics"
clingo --verbose=0 examples/e3.lp examples/e3-map2.lp to-clustered-af.lp semantics/clusem-stable.lp 0
