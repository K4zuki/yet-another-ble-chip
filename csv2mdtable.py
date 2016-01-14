#-*- coding: utf-8 -*-
#!/usr/bin/env python27

import csv

# convert from tab(\t)-separated text file to markdown table

import argparse
class MyParser(object):
    def __init__(self):
        self._parser = argparse.ArgumentParser(description = """take screenshot from Tek MSO/DPO/MDO4000 Oscilloscope,
        will *Not* control instuments other than Oscillo
        """)
        self._parser.add_argument('--file', '-F', help = 'input csv file', default = "csv.csv")
        self._parser.add_argument('--out', '-O', help = 'output markdown file', default = "table.md")
        self._parser.add_argument('--delimiter', '-D', help = 'device number', default = ',')
#        self._parser.add_argument('--basename','-B', help = 'base directry of output',
#            default = "C:\\Users\\Public\\Documents\\")
        self.args = self._parser.parse_args(namespace=self)

parser = MyParser()
_file = parser.args.file
_output = parser.args.out
_delimiter = parser.args.delimiter

_read = csv.reader(open(_file, 'r'), delimiter=_delimiter, quotechar='\"')
_outfile = open( _output,'a' )

lst = list(_read)
width = len(lst[0])
height = len(lst)

widthlist = []
maxwidthlist = []
for i in range(width): #x
    widthlist.append([])
    for j in range(height): #y
        widthlist[i].append(len(lst[j][i]))
#        print lst[j][i]
    maxwidthlist.append(max(widthlist[i]))
#    print max(widthlist[i])

#print widthlist
#print maxwidthlist
hbar="+"
hline="+"
for i in maxwidthlist:
    for j in range(i):
        hbar+=u"="
        hline+=u"-"
    hbar+=u"+"
    hline+=u"+"
#print hbar
#print hline

str=""
for i in range(width): #x
    for j in range(height): #y
#        print "%d" %(maxwidthlist[i] - len(lst[j][i])),
        str=""
        for s in range(maxwidthlist[i] - len(lst[j][i])):
            str+=" "
        lst[j][i] = lst[j][i]+str
#        print lst[j][i],
#    print "|"

_outfile.write( hline+"\n")
_outfile.write( u"|%s|\n" %"|".join(lst[0]))
_outfile.write( hbar+"\n")
for j in range(height-1): #y
    _outfile.write( u"|%s|\n" %"|".join(lst[j+1]))
    _outfile.write( hline+"\n")

_outfile.close()
