echo "Example from Figure 3 (stable semantics), everything in a single cluster. There are no stable extensions."
echo "We can use the '--enumerate=all' argument to enumerate all nonspurious refinements, not just the smallest one!"
time python refine-exhaustive.py --enumerate=all stable examples/e3.lp examples/e3-map2.lp
echo ""

echo "Simonshaven example (admissible semantics), starting with 'a' as singleton cluster (and everything else in a second cluster)"

echo "We can use the '--strict_ordering' argument to enumerate refinements in order (from smallest to largest)"
echo "Without strict ordering:"
time python refine-exhaustive.py admissible examples/simonshaven.lp examples/simonshaven-map1.lp
echo ""

echo "Much faster with strict ordering:"
time python refine-exhaustive.py --strict_ordering admissible examples/simonshaven.lp examples/simonshaven-map1.lp
echo ""

echo "EXPERIMENTAL: We can use the '--experimental_nogoods' argument to enable counterexample-guided nogood learning (similar to the 'refine-spurious-guided.py' techique)."
time python refine-exhaustive.py --experimental_nogoods admissible examples/simonshaven.lp examples/simonshaven-map1.lp
