from sys import argv
import re
import os


with open(argv[1]) as f:
    file = f.readlines()

# Removal of outgroups when identifying ORs
file.pop(0)
file.pop(0)

name = argv[1].split('.')[0]
start = 1
os.system('rm %s' % argv[1])
for line in file:
    m = re.match(r'^>.*', line)
    with open(argv[1], 'a') as w:
        if m:
            new_name = '>' + name + '_' + str(start)
            start += 1
            w.write(new_name + '\n')
        else:
            w.write(line)

