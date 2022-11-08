from collections import namedtuple
import argparse
from clingo.control import Control
from clingo.symbol import parse_term
import clingo
import sys

parser = argparse.ArgumentParser(description='Perform an exhaustive search in the space of argument partitions. Find the smallest partition that does not produce spurious counterexamples w.r.t. the selected semantics')
parser.add_argument('semantics', choices=['cf', 'admissible', 'stable'], help='The AF semantics to work with')
parser.add_argument('lp_af', metavar='af.lp', help='Filename to a logic program defining the concrete argumentation framework.')
parser.add_argument('lp_map', metavar='map.lp', help='Filename to a logic program defining a mapping from concrete to abstract arguments. This mapping will be the start of the refinement procedure.')
parser.add_argument('--enumerate', choices=['all', 'opt'], default='opt')
parser.add_argument('--strict_ordering', action=argparse.BooleanOptionalAction, default=False)
parser.add_argument('--experimental_nogoods', action=argparse.BooleanOptionalAction, default=False)

args = parser.parse_args()
semantics=args.semantics
lp_af = args.lp_af
lp_map = args.lp_map
enumeration_mode = args.enumerate
enumerate_in_strict_order = args.strict_ordering
use_experimental_nogoods = args.experimental_nogoods

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
    
    ctl.load(lp_af)
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
    
    ctl.load(lp_af)
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
    
    ctl.load(lp_af)
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

        if is_spurious:
            return True, noncongruents

    return False, None

ctl = Control()
ctl.configuration.solve.models = 0
ctl.load(lp_af)
ctl.load(lp_map)
ctl.load('to-clustered-af.lp')
ctl.load('partitions.lp')
ctl.ground([('base', [])])
i = 0
current_best_cost = None
admissible_mappings = list()

while(True):
    # If enumeration mode is 'opt', consider only partitions that are smaller than the current best one!
    # If enumeration mode is 'all', consider all partitions and enumerate them.
    if enumeration_mode == 'opt' and current_best_cost:
        ctl.configuration.solve.opt_mode = f'opt, {", ".join(str(b-1) for b in current_best_cost) }'

    i += 1
    handle = ctl.solve(yield_=True)

    model = None
    if enumerate_in_strict_order:
        # If enumerating in strict order, always look at the very last model found by the solver (i.e. the optimal one)
        for model in handle:
            pass
    else:
        # If not enumerating in strict order, look at the first model found by the solver (i.e. allow suboptimal models)
        model = handle.model()
        handle.cancel()
    if not model:
        break
    symbols = model.symbols(shown=True)
    mapping = { str(lit.arguments[0]) : str(lit.arguments[1]) for lit in symbols if lit.match('abs_split', 2) }

    if use_experimental_nogoods:
        # If using experimental nogoods, try to learn clauses from spurious counterexamples.
        # Add learned clauses to the search process!
        is_current_mapping_spurious, noncongruents = is_spurious_with_refinement(semantics, mapping)
    else:
        # No experimental nogoods to add!
        is_current_mapping_spurious = is_spurious(semantics, mapping)
        noncongruents = []

    if is_current_mapping_spurious:
        for nc in noncongruents:
            ctl.add(f'nogood{i}', [], f'{nc}.')
    else:
        current_best_cost = model.cost
        print_mapping(mapping, model.cost)
        admissible_mappings.append((mapping, model.cost))

    # Always add the current partition as nogood! 
    # This ensures termination, as no partition is visited more than once.
    nogood = ':-' + ','.join(f'{lit}' for lit in symbols if lit.match('abs_split', 2)) + '.'
    ctl.add(f'nogood{i}', [], nogood)
    ctl.ground([(f'nogood{i}', [])])

print('Exhaustive search finished!')
