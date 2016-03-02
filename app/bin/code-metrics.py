#!/usr/bin/python


import os, sys, json, commands, lizard

program = sys.argv[1]


# call cloc
cloc = commands.getstatusoutput("cloc --csv %s 2> /dev/null | tail -1" % program)[1].split(",")



# call lizard
ana = lizard.analyze_file(program)

inf = {}

ccn_max = 0.0
inf = {}

for func in ana.function_list:
	f = {}
	f['name'] = func.name
	f['long_name'] = func.long_name
	f['tokens'] = func.token_count
	f['nloc'] = func.nloc
	f['ccn'] = func.cyclomatic_complexity * 1.0
	f['parameters'] = func.parameters
	inf[func.name] = f
	if func.cyclomatic_complexity > ccn_max:
		ccn_max = func.cyclomatic_complexity

f = {}
f['nloc'] = ana.nloc
f['tokens'] = ana.token_count
f['name'] = program
f['ccn'] = ccn_max
f['comments'] = int(cloc[3])
f['language'] = cloc[1]
inf["*"] = f

# write output
json.dump(inf, sys.stdout, indent=2)
