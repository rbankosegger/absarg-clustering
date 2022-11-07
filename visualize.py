import sys
from graphviz import Digraph
from clingo.control import Control

if '-h' in sys.argv or len(sys.argv)<3:
    print('usage: python visualize.py output-file.gv instance.lp')
    print('usage: python visualize.py output-file.gv instance.lp instance-map.lp to-clustered-af.lp')
    quit()
output_file = sys.argv[1]
clingo_files = sys.argv[2:]

ctl = Control()
for f in clingo_files:
    ctl.load(f)
ctl.ground([('base', [])])
handle = ctl.solve(yield_=True)
model = next(m.symbols(shown=True) for m in handle)

clusters = dict()
attacks = list()
for sym in model:
    if sym.name == 'abs_map':
        arg = str(sym.arguments[0])
        clu = str(sym.arguments[1])

        if clu not in clusters.keys():
            clusters[clu] = set()

        clusters[clu].add(arg)

    if sym.name == 'att':
        attacks.append((str(sym.arguments[0]), str(sym.arguments[1])))


g = Digraph('G', filename=output_file)
g.attr('node', shape='circle')

for clu, args in clusters.items():
    if len(args) == 1:
        continue
    with g.subgraph(name=f'cluster_{clu}') as c:
        for arg in args:
            c.node(arg)
        c.attr(label='')

for arg1, arg2 in attacks:
    g.edge(arg1, arg2)


g.view()
