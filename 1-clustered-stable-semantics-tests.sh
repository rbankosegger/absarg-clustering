echo "Test 1"
echo "Classical stable semantics:"
clingo --verbose=0 tests/cstable-1.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered stable semantics:"
clingo --verbose=0 tests/cstable-1.lp tests/cstable-1-map.lp to-clustered-af.lp semantics/clusem-stable.lp 0
echo "---"

echo ""

echo "Test 2"
echo "Classical stable semantics:"
clingo --verbose=0 tests/cstable-2.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered stable semantics:"
clingo --verbose=0 tests/cstable-2.lp tests/cstable-2-map.lp to-clustered-af.lp semantics/clusem-stable.lp 0
echo "---"

echo ""

echo "Test 3"
echo "Classical stable semantics:"
clingo --verbose=0 tests/cstable-3.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered stable semantics:"
clingo --verbose=0 tests/cstable-3.lp tests/cstable-3-map.lp to-clustered-af.lp semantics/clusem-stable.lp 0
echo "---"

echo ""

echo "Test 4"
echo "Classical stable semantics:"
clingo --verbose=0 tests/cstable-4.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered stable semantics:"
clingo --verbose=0 tests/cstable-4.lp tests/cstable-4-map.lp to-clustered-af.lp semantics/clusem-stable.lp 0
echo "---"
