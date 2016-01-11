#!/usr/bin/env python

import argparse
import json

parser = argparse.ArgumentParser(description='Compile font.')
parser.add_argument('source', help='input file')
args = parser.parse_args()

messages = json.load(open(args.source))
offsets = []
data = []
for key, value in messages.iteritems():
	offsets.append(len(data))
	print ": const text_%s %d\n" %(key, len(offsets)),
	for ch in value:
		data.append(ord(ch))
	data.append(0)

print ": data_text\n\t",
print " ".join(["0x%02x" %i for i in data])

print ": data_text_index\n\t" + " ".join(["0x%02x 0x%02x" %(x & 0xff, x >> 8) for x in offsets])
print
