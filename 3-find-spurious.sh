echo "Example from Figure 1b, try to map classical extensions to clustered ones. Identify spurious ones."
python find_spurious.py stable examples/e1-concrete.lp examples/e1-clustered1.lp
echo ""

echo "Example from Figure 1c, try to map classical extensions to clustered ones. Identify spurious ones."
python find_spurious.py stable examples/e1-concrete.lp examples/e1-clustered2.lp
echo ""

echo "Also work with admissible (or cf) semantics. Example from Figure 1c:"
python find_spurious.py admissible examples/e1-concrete.lp examples/e1-clustered2.lp
echo ""

echo "Test case 3: Try to map classical extensions to clustered ones. Identify spurious ones."
python find_spurious.py stable tests/cstable-test3.lp
echo ""

echo "Test case 4: Try to map classical extensions to clustered ones. Identify spurious ones."
python find_spurious.py stable tests/cstable-test4.lp
