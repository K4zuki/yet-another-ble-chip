#!/usr/bin/env python

import re
import sys
include = re.compile("`([^`]+)`\{.include}")
for line in sys.stdin:
    if include.search(line):
        input_file = include.search(line).groups()[0]
        file_contents = open(input_file, "rb").read()
        line = include.sub(line, file_contents)
    sys.stdout.write(line)
