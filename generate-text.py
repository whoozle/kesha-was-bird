#!/usr/bin/env python

import argparse
import json

parser = argparse.ArgumentParser(description='Compile font.')
parser.add_argument('source', help='input file')
args = parser.parse_args()

messages = json.load(open(args.source))
for key, value in messages.iteritems():
	print ": text_%s\n\t" %key,
	print " ".join(["0x%02x" %ord(i) for i in value])
