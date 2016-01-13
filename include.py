#-*- coding: utf-8 -*-
#!/usr/bin/env python27

import re
import sys
import argparse
class MyParser(object):
    def __init__(self):
        self._parser = argparse.ArgumentParser(description = """take screenshot from Tek MSO/DPO/MDO4000 Oscilloscope,
        will *Not* control instuments other than Oscillo
        """)
        self._parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin)
        self._parser.add_argument('--out', '-O', help = 'output markdown file', default = "table.md")
        self.args = self._parser.parse_args(namespace=self)

parser = MyParser()
_file = parser.args.infile
_output = parser.args.out

include = re.compile("`([^`]+)`\{.include}")
output = open(_output,'wb')
#for line in sys.stdin:
for line in _file:
    if include.search(line):
        input_file = include.search(line).groups()[0]
        file_contents = open(input_file, "rb").read()
        line = include.sub(line, file_contents)
    output.write(line)
