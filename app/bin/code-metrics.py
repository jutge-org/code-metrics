#!/usr/bin/env python


import os, sys, json, commands, lizard


program = sys.argv[1]
output = sys.argv[2] if len(sys.argv) == 3 else None


filename, extension = os.path.splitext(program)
bindir = os.path.dirname(os.path.realpath(__file__))



# count total number of lines
lines = len(open(program, "r").readlines())

# call lizard
ana = lizard.analyze_file(program)

# call cloc
cloc = commands.getstatusoutput("cloc --csv %s 2> /dev/null | tail -1" % program)[1].split(",")

# call commentedCodeDetector.py
halstead = {}
if extension in [".cc", ".c", ".java"]:
	out = commands.getstatusoutput("%s/commentedCodeDetector.py -fm %s 2> /dev/null" % (bindir, program))[1]
	for line in out.split("\n"):
		key, val = map(str.strip, line.split())
		halstead[key] = float(val)


# build the output

inf = {}

ccn_max = 0.0
inf = {}

for func in ana.function_list:
	f = {}
	f['name'] = func.name
	f['long_name'] = func.long_name
	f['tokens'] = func.token_count
	f['nloc'] = func.nloc
	f['lines'] = func.length
	f['ccn'] = func.cyclomatic_complexity * 1.0
	f['parameters'] = func.parameters
	inf[func.name] = f
	ccn_max = max(func.cyclomatic_complexity, ccn_max)

f = {}
f['lines'] = lines
f['nloc'] = ana.nloc
f['tokens'] = ana.token_count
f['name'] = program
f['ccn'] = ccn_max
f['comments'] = int(cloc[3])
f['language'] = cloc[1]
f['halstead'] = halstead
inf["*"] = f

# write output
if output:
	json.dump(inf, open(output, "w"), indent=2)
else:
	json.dump(inf, sys.stdout, indent=2)
