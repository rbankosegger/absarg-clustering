echo "Example from Figure 1c, here again the classical stable extensions:"
clingo --verbose=0 examples/e1-concrete.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered extension {abce, d} can be mapped to concrete extensions"
clingo --verbose=0 examples/e1-clustered2-extension1.lp examples/e1-concrete.lp examples/e1-clustered2.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious.lp 0
echo "---"
echo "Clustered extension {abce} can be mapped to concrete extensions"
clingo --verbose=0 examples/e1-clustered2-extension2.lp examples/e1-concrete.lp examples/e1-clustered2.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious.lp 0
echo "---"
echo "Clustered extension {d} can not be mapped to concrete extensions (is spurious)"
clingo --verbose=0 examples/e1-clustered2-extension3.lp examples/e1-concrete.lp examples/e1-clustered2.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious.lp 0
