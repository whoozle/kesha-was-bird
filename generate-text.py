#!/usr/bin/env python

import argparse
import json

parser = argparse.ArgumentParser(description='Compile font.')
parser.add_argument('sources', help='input file', nargs='+')
args = parser.parse_args()

offsets = []
data = []

for source in args.sources:
	messages = json.load(open(source))
	for key, value in messages.iteritems():
		print ":const text_%s %d\n" %(key, len(offsets)),
		offsets.append(len(data))
		for ch in value:
			data.append(ord(ch))
		data.append(0)

print ": data_text\n\t",
print " ".join(["0x%02x" %i for i in data])

print ": data_text_index\n\t" + " ".join(["0x%02x 0x%02x" %(x & 0xff, x >> 8) for x in offsets])
print
