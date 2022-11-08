from collections import namedtuple
from clingo.control import Control
from clingo.symbol import parse_term
import clingo
import sys

#semantics='cf'
#semantics='admissible'
semantics='stable'
#lp_con = 'tests/refinement-test1-concrete.lp'
#lp_map = 'tests/refinement-test1-cluster-mapping.lp'
#lp_con = 'tests/refinement-test2-concrete.lp'
#lp_map = 'tests/refinement-test2-cluster-mapping.lp'
#lp_con = 'tests/refinement-test3-concrete.lp'
#lp_map = 'tests/refinement-test3-cluster-mapping.lp'
#lp_con = 'examples/e1.lp'
#lp_map = 'examples/e1-map2.lp'
#lp_con = 'examples/e3.lp'
#lp_map = 'examples/e3-map2.lp'
#lp_con = 'examples/e4-simonshaven-concrete.lp'
#lp_map = 'examples/e4-simonshaven-mapping.lp'
lp_con = 'examples/simonshaven.lp'
lp_map = 'examples/simonshaven-map1.lp'
#lp_map = 'examples/e4-simonshaven-mapping-4.lp'
#lp_map = 'examples/e4-simonshaven-mapping-3.lp'
#lp_con = 'examples/e5-random6-concrete.lp'
#lp_map = 'examples/e5-random6-mapping.lp'
#lp_con = 'examples/e6-simonshaven-simplified-concrete.lp'
#lp_map = 'examples/e6-simonshaven-simplified-mapping1.lp'

def print_mapping(mapping, cost=[]):

    partition = dict()
    for k,v in sorted(mapping.items()):
        if not v in partition.keys():
            partition[v] = set()
        partition[v].add(k)

    print(f'Partition[{len(partition.keys())}]:', ', '.join('{' + ','.join(str(v2) for v2 in sorted(v)) + '}' for v in sorted(partition.values())))


def compute_clustered_extensions(semantics, mapping):

    ctl = Control()
    ctl.configuration.solve.models = 0
    
    ctl.load(lp_con)
    ctl.add('base', [], '\n'.join(f'abs_map({k},{v}).' for k, v in mapping.items()))
    ctl.load('to-clustered-af.lp')
    
    ctl.load(f'semantics/clusem-{semantics}.lp')
    ctl.add('base', [], '-abs_in(A) :- abs_arg(A), not abs_in(A).')
    ctl.add('base', [], '#show -abs_in/1.')
    ctl.ground([('base', [])])
    handle = ctl.solve(yield_=True)

    visited = set()
    for model in handle:
        symbols = model.symbols(shown=True)
        symbols_str = ','.join(str(sym) for sym in sorted(symbols))
        if symbols_str in visited:
            continue
        visited.add(symbols_str)
        yield symbols

def is_spurious(semantics, mapping):

    ctl = Control()
    ctl.configuration.solve.models = 0
    
    ctl.load(lp_con)
    ctl.add('base', [], '\n'.join(f'abs_map({k},{v}).' for k, v in mapping.items()))
    ctl.load('to-clustered-af.lp')
    
    ctl.load(f'semantics/clusem-{semantics}.lp')
    ctl.load(f'semantics/sem-{semantics}.lp')

    ctl.load('spurious.lp')
    ctl.add('base', [], ':- spurious.')
    ctl.add('base', [], '#show att/2.')
    ctl.add('base', [], '#show in/1.')
    ctl.add('base', [], '#show abs_att/2.')
    ctl.add('base', [], '#show abs_map/2.')

    ctl.ground([('base', [])])
    #handle = ctl.solve(yield_=True)

    for cex in compute_clustered_extensions(semantics, mapping):
        assumptions = [(parse_term(f'{lit.name}({lit.arguments[0]})'), lit.positive) for lit in cex]
        result = ctl.solve(assumptions=assumptions)
        #handle = ctl.solve(assumptions=assumptions, yield_=True)
        #result = handle.get()
        #handle.cancel()

        if not result.satisfiable:
            return True

    return False

def is_spurious_with_refinement(semantics, mapping):

    ctl = Control()
    ctl.configuration.solve.models = 0
    
    ctl.load(lp_con)
    ctl.add('base', [], '\n'.join(f'abs_map({k},{v}).' for k, v in mapping.items()))
    ctl.load('to-clustered-af.lp')

    ctl.load(f'semantics/clusem-{semantics}.lp')
    ctl.load(f'semantics/sem-{semantics}.lp')

    ctl.load('spurious-refinement-noncongruence.lp')

    ctl.ground([('base', [])])

    for cex in compute_clustered_extensions(semantics, mapping):
        assumptions = [(parse_term(f'{lit.name}({lit.arguments[0]})'), lit.positive) for lit in cex]
        *_, optimal_model = ctl.solve(assumptions=assumptions, yield_=True)
        symbols = optimal_model.symbols(shown=True)
        is_spurious = optimal_model.contains(parse_term('spurious'))

        noncongruents = [s for s in optimal_model.symbols(shown=True) if s.match('congruent', 2, positive=False)]

        #TODO: [x]  Modify spurious-refinement.lp to return not_congruent clauses
        #TODO: [x]  Extract and return those clauses here
        #TODO: [x]  Form constraints from clauses
        #TODO: [ ]  Proof: added constraints do not delete admissible abstractions


        if is_spurious:
            #print(cex)
            return True, noncongruents

    return False, None

ctl = Control()
ctl.configuration.solve.models = 0
ctl.load(lp_con)
ctl.load(lp_map)
ctl.load('to-clustered-af.lp')
ctl.load('partitions.lp')
ctl.ground([('base', [])])
i = 0
current_best_cost = None
admissible_mappings = list()

while(True):
    if current_best_cost:
        ctl.configuration.solve.opt_mode = f'opt, {", ".join(str(b-1) for b in current_best_cost) }'
    i += 1
    handle = ctl.solve(yield_=True)
    #model = None
    #for model in handle:
        #pass
    model = handle.model()
    handle.cancel()
    if not model:
        break
    symbols = model.symbols(shown=True)
    mapping = { str(lit.arguments[0]) : str(lit.arguments[1]) for lit in symbols if lit.match('abs_split', 2) }

    #print(i, model.cost, current_best_cost)
    #print(model)

    spur = is_spurious(semantics, mapping)
    noncongruents = []
    #spur, noncongruents = is_spurious_with_refinement(semantics, mapping)
    if spur:
        for nc in noncongruents:
            #print(nc)
            ctl.add(f'nogood{i}', [], f'{nc}.')
    else:
        current_best_cost = model.cost
        print_mapping(mapping, model.cost)
        admissible_mappings.append((mapping, model.cost))

    nogood = ':-' + ','.join(f'{lit}' for lit in symbols if lit.match('abs_split', 2)) + '.'
    #print(nogood)
    ctl.add(f'nogood{i}', [], nogood)
    ctl.ground([(f'nogood{i}', [])])
