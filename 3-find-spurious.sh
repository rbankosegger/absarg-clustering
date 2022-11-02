echo "Example from Figure 1b, try to map classical extensions to clustered ones. Identify spurious ones."
python find_spurious.py stable examples/e1.lp examples/e1-map1.lp to-clustered-af.lp
echo ""

echo "Example from Figure 1c, try to map classical extensions to clustered ones. Identify spurious ones."
python find_spurious.py stable examples/e1.lp examples/e1-map2.lp
echo ""

echo "Also work with admissible (or cf) semantics. Example from Figure 1c:"
python find_spurious.py admissible examples/e1.lp examples/e1-map2.lp
echo ""

echo "Test case 3: Try to map classical extensions to clustered ones. Identify spurious ones."
python find_spurious.py stable tests/cstable-3.lp tests/cstable-3-map.lp
echo ""

echo "Test case 4: Try to map classical extensions to clustered ones. Identify spurious ones."
python find_spurious.py stable tests/cstable-4.lp tests/cstable-4-map.lp
