# Simonshaven, admissible and stable
# Example 1, example 3 (the UNSAT one?)

echo "Example from Figure 1b (admissible semantics). It is already nonspurious, no refinement needed!"
time python refine-spurious-guided.py admissible examples/e1.lp examples/e1-map1.lp
echo ""

echo "Example from Figure 1c (admissible semantics). Is spurious, needs refinement."
time python refine-spurious-guided.py admissible examples/e1.lp examples/e1-map2.lp
echo ""

echo "Example from Figure 3 (stable semantics), everything in a single cluster. There are no stable extensions, i.e. also no counterexamples for refinement! The method currently fails..."
time python refine-spurious-guided.py stable examples/e3.lp examples/e3-map2.lp
echo ""

echo "Simonshaven example (admissible semantics), starting with 'a' as singleton cluster (and everything else in a second cluster)"
time python refine-spurious-guided.py admissible examples/simonshaven.lp examples/simonshaven-map1.lp
echo ""

echo "Simonshaven example (stable semantics), starting with 'a' as singleton cluster (and everything else in a second cluster)"
time python refine-spurious-guided.py stable examples/simonshaven.lp examples/simonshaven-map1.lp
echo ""
