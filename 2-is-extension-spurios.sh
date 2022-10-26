echo "Example from Figure 1c, here again the classical stable extensions:"
clingo --verbose=0 examples/e1.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered extension {abce, d} can be mapped to concrete extensions"
clingo --verbose=0 examples/e1-map2-ext1.lp examples/e1.lp examples/e1-map2.lp to-clustered-af.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious.lp 0
echo "---"
echo "Clustered extension {abce} can be mapped to concrete extensions"
clingo --verbose=0 examples/e1-map2-ext2.lp examples/e1.lp examples/e1-map2.lp to-clustered-af.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious.lp 0
echo "---"
echo "Clustered extension {d} can not be mapped to concrete extensions (is spurious)"
clingo --verbose=0 examples/e1-map2-ext3.lp examples/e1.lp examples/e1-map2.lp to-clustered-af.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious.lp 0
