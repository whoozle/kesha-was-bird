#!/usr/bin/env python

import argparse
import png

parser = argparse.ArgumentParser(description='Compile font.')
parser.add_argument('source', help='input file')
parser.add_argument('name', help='name')
args = parser.parse_args()

tex = png.Reader(args.source)
w, h, pixels, metadata = tex.read_flat()
tw, th = 16, 16

def label(name):
	return ": data_%s_%s" %(args.name, name)

nx = (w + tw - 1) / tw
ny = (h + th - 1) / th

def get_pixel(x, y, plane):
	if x < 0 or x >= w:
		return 0
	if y < 0 or y >= h:
		return 0

	bit = 1 << plane
	return 1 if pixels[y * w + x] & bit else 0

print label("data"),
for ty in xrange(0, ny):
	basey = ty * th
	print "\n" + label("row_%d" %ty)
	for tx in xrange(0, nx):
		basex = tx * tw
		print "\n" + label("_%d_%d" %(ty, tx))
		for plane in xrange(0, 2):
			for y in xrange(0, th):
				for x in xrange(0, tw / 8):
					byte = 0
					for bit in xrange(0, 8):
						byte |= get_pixel(basex + x + bit, basey + y, plane) << (7 - bit)
					print "0x%02x" %byte ,
