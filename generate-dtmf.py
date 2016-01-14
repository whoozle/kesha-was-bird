#!/usr/bin/env python

FREQ = 4000

def osc(t, freq):
	x = (t * freq) % 1
	return x < 0.5

def pulse(freq):
	buf = bytes()
	byte = 0
	bit = 0
	for i in xrange(0, 256):
		byte |= (0x80 if osc(i * 1.0 / FREQ, freq) else 0) >> bit
		bit += 1
		if bit == 8:
			buf += chr(byte)
			byte = 0
			bit = 0
	return buf

def mix(a, b):
	c = bytes()
	for i in xrange(0, 16):
		c += chr(ord(a[i]) ^ ord(b[i]))
	return c

cols = (pulse(1209), pulse(1336), pulse(1477), pulse(1633))
rows = (pulse(697), pulse(770), pulse(852), pulse(941))

mapping = (
	1, 2, 3, 12,
	4, 5, 6, 13,
	7, 8, 9, 14,
	10, 0, 11, 15
)

print ": audio_phone_tones"
for row in xrange(0, 4):
	for col in xrange(0, 4):
		idx = row * 4 + col
		#print row, col, mapping[idx]
		tone = mix(rows[row], cols[col])
		print " ".join(["0x%02x" %ord(x) for x in tone])
