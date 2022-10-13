from collections import namedtuple
from clingo.control import Control
from clingo.symbol import parse_term
import clingo
import sys

semantics = sys.argv[1]
clingo_imports = sys.argv[2:]
if '-h' in sys.argv or len(sys.argv)<=2:
    print('usage: python find_spurious.py cf|admissible|stable instance.lp')
    print('usage: python find_spurious.py cf|admissible|stable instance-concrete.lp instance-abstract.lp')
    quit()

ctl = Control()
ctl.configuration.solve.models = 0
for file in clingo_imports:
    ctl.load(file)
ctl.load(f'semantics/clusem-{semantics}.lp')
ctl.add('base', [], '-abs_in(A) :- abs_arg(A), not abs_in(A).')
ctl.add('base', [], '#show -abs_in/1.')
ctl.ground([('base', [])])
handle = ctl.solve(yield_=True)
extensions_clustered = [m.symbols(shown=True) for m in handle]

#print('Found clustered extensions:')
#for ext in extensions_clustered:
    #print(ext)

ctl = Control()
ctl.configuration.solve.models = 0
for file in clingo_imports:
    ctl.load(file)
ctl.load(f'semantics/clusem-{semantics}.lp')
ctl.load(f'semantics/sem-{semantics}.lp')
ctl.load('spurious.lp')
ctl.add('base', [], ':- spurious.')
ctl.ground([('base', [])])

tabu = set()
for ec in extensions_clustered:
    assumptions = [(parse_term(f'{lit.name}({lit.arguments[0]})'), lit.positive) for lit in ec]
    if frozenset(sorted(assumptions)) in tabu:
        continue
    tabu.add(frozenset(sorted(assumptions)))
    handle = ctl.solve(assumptions=assumptions, yield_=True)
    #models = [m.symbols(atoms=True) for m in handle]
    models = [m.symbols(shown=True) for m in handle]

    str_clustered = '{ ' + ', '.join(str(lit) for lit in ec if lit.positive) + ' }'
    if not handle.get().satisfiable:
        print(f'Spurious: {str_clustered}')
    else:
        print(f'Accepted: {str_clustered}')

        str_models = set()
        for m in models:
            str_concrete = '{ ' + ', '.join(str(lit) for lit in m if lit.name=='in') + ' }'
            str_models.add(str_concrete)

            #str_concrete = '{ ' + ', '.join(str(lit) for lit in m if lit.name in ['in', 'abs_in', 'abs_defeated']) + ' }'
            #print(f'\t\t{str_concrete}')

        for s in str_models:
            print(f'\tMaps to {s}')
