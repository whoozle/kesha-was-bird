#!/usr/bin/env python

import argparse
import wave
import struct

parser = argparse.ArgumentParser(description='Convert audio.')
parser.add_argument('source', help='input file')
parser.add_argument('name', help='name')
parser.add_argument('-o', '--output', help = 'dump audio as wav file')
args = parser.parse_args()

wav = wave.open(args.source)
n = wav.getnframes()
if wav.getsampwidth() != 2:
	raise Exception("invalid sample width")
if wav.getnchannels() != 1:
	raise Exception("only mono supported")
if wav.getframerate() != 4000:
	raise Exception("invalid sample rate, sox -S %s -r 4000 -b 16 <output>" %args.source)

frames = wav.readframes(n)

offset = 0
size = 0
bit, byte = 0, 0

source = ""
source += ": audio_%s\n" %args.name

data = bytes()
for i in xrange(0, n):
	buf = []

	value, = struct.unpack('<h', frames[offset: offset + 2]) if offset < len(frames) else (0,)
	offset += 2

	x = value / 32768.0
	assert x >= -1 and x <= 1
	qe = 0

	if x >= qe:
		byte |= (0x80 >> bit)
		y = 1
		data += struct.pack('<h', 16384)
	else:
		y = -1
		data += struct.pack('<h', -16384)
	qe = y - x + qe

	bit += 1
	if bit == 8:
		source += "0x%02x " %byte
		bit = 0
		byte = 0
		size += 1
		if (size % 32) == 0:
			source += "\n"

if size % 16:
	rem = 16 - (size % 16)
	for i in xrange(0, rem):
		source += "0x00 "
		size += 1

print
size /= 16 #loop count
#print ":const audio_%s_size %d"  %(args.name, size)
print ": audio_%s_size\n\t0x%02x 0x%02x\n%s"  %(args.name, size & 0xff, size >> 8, source)

if args.output:
	out = wave.open('out.wav', 'w')
	out.setnchannels(1)
	out.setsampwidth(2)
	out.setframerate(wav.getframerate())
	out.setnframes(len(data) / 2)
	out.writeframes(data)
	out.close() #no __exit__
