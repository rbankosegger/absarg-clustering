echo "Test 1"
echo "Classical stable semantics:"
clingo --verbose=0 tests/cstable-test1.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered stable semantics:"
clingo --verbose=0 tests/cstable-test1.lp semantics/clusem-stable.lp 0
echo "---"

echo ""

echo "Test 2"
echo "Classical stable semantics:"
clingo --verbose=0 tests/cstable-test2.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered stable semantics:"
clingo --verbose=0 tests/cstable-test2.lp semantics/clusem-stable.lp 0
echo "---"

echo ""

echo "Test 3"
echo "Classical stable semantics:"
clingo --verbose=0 tests/cstable-test3.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered stable semantics:"
clingo --verbose=0 tests/cstable-test3.lp semantics/clusem-stable.lp 0
echo "---"

echo ""

echo "Test 4"
echo "Classical stable semantics:"
clingo --verbose=0 tests/cstable-test4.lp semantics/sem-stable.lp 0
echo "---"
echo "Clustered stable semantics:"
clingo --verbose=0 tests/cstable-test4.lp semantics/clusem-stable.lp 0
echo "---"
