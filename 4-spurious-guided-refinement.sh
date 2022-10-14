echo "Example from Figure 1c, here again the classical stable extensions:"
clingo --verbose=0 examples/e1-concrete.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered extension {abce, d}. Same mapping as for find_spurious.py"
clingo --verbose=0 examples/e1-clustered2-extension1.lp examples/e1-concrete.lp examples/e1-clustered2.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious-refinement.lp 0
echo "---"
echo "Clustered extension {abce}. Same mapping as for find_spurious.py"
clingo --verbose=0 examples/e1-clustered2-extension2.lp examples/e1-concrete.lp examples/e1-clustered2.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious-refinement.lp 0
echo "---"
echo "Spurious clustered extension {d}. "
clingo --verbose=0 examples/e1-clustered2-extension3.lp examples/e1-concrete.lp examples/e1-clustered2.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious-refinement.lp 0
echo "---"
echo ""
#echo "But the method breaks down for some (edge?) cases!"
echo ""
echo "Test 1, output of 'find_spurious.py'":
python find_spurious.py stable tests/refinement-test1.lp
echo "---"
echo "Closer look at spurious clustered stable extension {a, bc}"
#echo "bc causes problems and should be split. But the split is errouneous! No change to the cluster structure!"
clingo --verbose=0 tests/refinement-test1.lp tests/refinement-test1-extension.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious-refinement.lp 0
echo "---"
echo "Test 2, output of 'find_spurious.py'":
python find_spurious.py stable tests/refinement-test2.lp
echo "Closer look at spurious clustered stable extension {a, bce}"
#echo "bce causes problems and d is falsely excluded. bce is not recognized as problem. No change to the cluster structure!"
echo "---"
clingo --verbose=0 tests/refinement-test2.lp tests/refinement-test2-extension.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious-refinement.lp 0
echo "---"
echo "Test 3, output of 'find_spurious.py'":
python find_spurious.py stable tests/refinement-test2.lp
echo "Closer look at spurious clustered stable extension {a, a1, bce}"
#echo "bce causes problems and d, d1 are falsely excluded. bce is not recognized as problem. No change to the cluster structure!"
echo "---"
clingo --verbose=0 tests/refinement-test3.lp tests/refinement-test3-extension.lp semantics/sem-stable.lp semantics/clusem-stable.lp spurious-refinement.lp 0
