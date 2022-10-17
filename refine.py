from collections import namedtuple
from clingo.control import Control
from clingo.symbol import parse_term
import clingo
import sys

semantics='stable'

def clustered_lp(mapping):

    return '\n'.join(f'abs_map({k},{v}).' for k, v in mapping.items()) + """
abs_arg(X) :- abs_map(_,X).
singleton(X) :- 1 = #count { Y : abs_map(Y,X) }, abs_arg(X).
abs_att(X',Y') :- att(X,Y), abs_map(X,X'), abs_map(Y,Y').
    """

def compute_clustered_extensions(mapping):

    global semantics

    ctl = Control()
    ctl.configuration.solve.models = 0
    
    #for file in clingo_imports:
    #    ctl.load(file)
    ctl.load('examples/e1-concrete.lp')
    ctl.add('base', [], clustered_lp(mapping))
    #ctl.load('examples/e1-clustered2.lp')
    
    ctl.load(f'semantics/clusem-{semantics}.lp')
    ctl.add('base', [], '-abs_in(A) :- abs_arg(A), not abs_in(A).')
    ctl.add('base', [], '#show -abs_in/1.')
    ctl.ground([('base', [])])
    handle = ctl.solve(yield_=True)

    return [m.symbols(shown=True) for m in handle]

def check_spuriousness_and_refine(mapping, clustered_extension):

    global semantics

    ctl = Control()
    ctl.configuration.solve.models = 0
    
    #for file in clingo_imports:
    #    ctl.load(file)
    ctl.load('examples/e1-concrete.lp')
    ctl.add('base', [], clustered_lp(mapping))
    #ctl.load('examples/e1-clustered2.lp')
    
    ctl.load(f'semantics/clusem-{semantics}.lp')
    ctl.load(f'semantics/sem-{semantics}.lp')
    ctl.load('spurious-refinement.lp')
    ctl.add('base', [], '#show abs_map_refined/2.')
    ctl.ground([('base', [])])

    assumptions = [(parse_term(f'{lit.name}({lit.arguments[0]})'), lit.positive) for lit in clustered_extension]
    *_, optimal_model = ctl.solve(assumptions=assumptions, yield_=True)
    symbols = optimal_model.symbols(shown=True)

    is_spurious = any(s.match(name='spurious', arity=0) for s in symbols)
    str_clustered = '{ ' + ', '.join(str(lit) for lit in ec if lit.positive) + ' }'
    str_concrete = '{ ' + ', '.join(str(lit) for lit in symbols if lit.match('in', 1)) + ' }' + f'{optimal_model.cost}'
    
    if is_spurious:
        print(f'Spurious: {str_clustered}')
        print(f'\tBest match: {str_concrete}')
        mapping_refined = { str(lit.arguments[0]) : str(lit.arguments[1]) for lit in symbols if lit.match('abs_map_refined', 2) }
        print(f'\t\t{mapping_refined}')

        return mapping_refined

    else:
        print(f'Accepted: {str_clustered}')
        print(f'\t\t{str_concrete}')

    return None

mapping = { 'a':'x', 'b':'x', 'c':'x', 'd':'d', 'e':'x' }
while True:
    needs_refinement = False
    clustered_extensions = compute_clustered_extensions(mapping)
    print(f'Check mapping {mapping}')
    for ec in clustered_extensions:
        mapping_refined = check_spuriousness_and_refine(mapping, ec)

        if mapping_refined:
            needs_refinement = True
            mapping = mapping_refined
            break

   # partition = dict()
   # for k, v in mapping.items():
   #     if not v in partition.keys():
   #         partition[v] = set()

   #     partition[v].add(k)

   # for k, v in mapping.items():
   #     if len(partition[v]) == 1:
   #         mapping[k] = k
   # 

    if needs_refinement:
        print('Refine!')
    else:
        print('Done!')
        break

