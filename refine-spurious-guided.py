from collections import namedtuple
from clingo.control import Control
from clingo.symbol import parse_term
import clingo
import sys

semantics = sys.argv[1]
lp_concrete = sys.argv[2]
lp_map_start = sys.argv[3]
if '-h' in sys.argv or len(sys.argv)!=4:
    print('usage: python find_spurious.py cf|admissible|stable instance-concrete.lp instance-mapping.lp')
    quit()

# Read out mapping
ctl = Control()
ctl.configuration.solve.models = 0
ctl.load(lp_concrete)
ctl.load(lp_map_start)
ctl.add('base', [], '#show abs_map/2.')
ctl.ground([('base', [])])
*_, model = ctl.solve(yield_=True)
mapping = { str(abs_map.arguments[0]) : str(abs_map.arguments[1]) for abs_map in model.symbols(shown=True) }

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
    
    ctl.load(lp_concrete)
    ctl.add('base', [], '\n'.join(f'abs_map({k},{v}).' for k, v in mapping.items()))
    ctl.load('to-clustered-af.lp')
    
    ctl.load(f'semantics/clusem-{semantics}.lp')
    ctl.add('base', [], '-abs_in(A) :- abs_arg(A), not abs_in(A).')
    ctl.add('base', [], '#show -abs_in/1.')
    ctl.ground([('base', [])])
    handle = ctl.solve(yield_=True)

    for model in handle:
        yield model.symbols(shown=True)

def simplify_mapping(mapping):

    #return mapping

    partition = dict()
    for k,v in mapping.items():
        if not v in partition.keys():
            partition[v] = list()
        partition[v].append(k)

    #print(partition)

    #mapping2=dict()
    for k,v in mapping.items():
        #mapping[k] = '"(' + ','.join(sorted(partition[v])) + ')"'
        #mapping[k] = '(' + ','.join(sorted(partition[v])) + ')'
        if len(partition[v]) > 1:
            #mapping[k] = '(' + ','.join(sorted(partition[v])) + ')'
            #mapping[k] = 'clu_' + '_'.join(sorted(partition[v]))
            mapping[k] = '(' + ','.join(sorted(partition[v])) + ')'
        else:
            #mapping[k] = '"(' + ','.join(sorted(partition[v])) + ')"'
            #mapping[k] = '(' + ','.join(sorted(partition[v])) + ')'
            #mapping[k] = 'single_' + partition[v][0]

            mapping[k], = partition[v]
            #pass

    partition = dict()
    for k,v in mapping.items():
        if not v in partition.keys():
            partition[v] = list()
        partition[v].append(k)

    #print(partition)

    return mapping


def check_spuriousness_and_refine(semantics, mapping, clustered_extension):

    ctl = Control()
    ctl.configuration.solve.models = 0

    
    ctl.load(lp_concrete)
    ctl.add('base', [], '\n'.join(f'abs_map({k},{v}).' for k, v in mapping.items()))
    ctl.load('to-clustered-af.lp')
    
    ctl.load(f'semantics/clusem-{semantics}.lp')
    ctl.load(f'semantics/sem-{semantics}.lp')
    ctl.load('spurious-guided-refinement.lp')
    ctl.add('base', [], '#show abs_map_refined/2.')
    ctl.ground([('base', [])])

    assumptions = [(parse_term(f'{lit.name}({lit.arguments[0]})'), lit.positive) for lit in clustered_extension]
    #*_, optimal_model = ctl.solve(assumptions=assumptions, yield_=True)
    models = ctl.solve(assumptions=assumptions, yield_=True)
    optimal_model = None
    for m in models:
        optimal_model = m

    if optimal_model == None:
        print('Error! No ground extensions found! Exiting...')
        exit()
        
    symbols = optimal_model.symbols(shown=True)

    is_spurious = optimal_model.contains(parse_term('spurious'))
    str_clustered = '{ ' + ', '.join(str(lit) for lit in clustered_extension if lit.positive) + ' }'
    str_concrete = '{ ' + ', '.join(str(lit) for lit in symbols if lit.match('in', 1)) + ' }' + f'{optimal_model.cost}'
    
    if is_spurious:
        #print(optimal_model)
        print(f'\tSpurious: {str_clustered}')
        #print(f'\tBest match: {str_concrete}')
        mapping_refined = { str(lit.arguments[0]) : str(lit.arguments[1]) for lit in symbols if lit.match('abs_map_refined', 2) }
        mapping_refined = simplify_mapping(mapping_refined)
        #print(f'\t\t{mapping_refined}')

        return mapping_refined

    else:
        #print(f'Accepted: {str_clustered}')
        #print(f'\t\t{str_concrete}')
        pass

    return None


while True:
    needs_refinement = False
    clustered_extensions = compute_clustered_extensions(semantics, mapping)
    #print(f'Check mapping {mapping}')
    print('Check ', end='')
    print_mapping(mapping)
    for ext in clustered_extensions:
        #print(ext)

        mapping_refined = check_spuriousness_and_refine(semantics,mapping, ext)

        if mapping_refined:
            needs_refinement = True
            mapping = mapping_refined
            break


    if needs_refinement:
        #print('Refine!')
        pass
    else:
        #print('Done!')
        break

print('Found nonspurious ', end='')
print_mapping(mapping)
