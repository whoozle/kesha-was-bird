#!/usr/bin/env python

def generate(name, file):
	source = ": %s_data\n" %name
	with open(file) as fontsource:
		font = {}
		while True:
			decl = fontsource.readline()
			if decl == '':
				break
			elif decl == '\n':
				continue
			decl = decl.split()
			if not decl:
				break
			if len(decl) == 3:
				char, height, width = (t(s) for t,s in zip((str, int, int), decl))
				descent = 0
			else:
				char, height, width, descent = (t(s) for t,s in zip((str, int, int, int), decl))

			width += 1 #shadow + interval
			if width > 8:
				raise "width is more than 8"

			rows, shadows = [], []
			for y in xrange(0, height):
				rowstr = fontsource.readline().rstrip()
				row = [1 if ch != ' ' else 0 for ch in rowstr]
				for x in xrange(len(row), width):
					row.append(0)

				#shadow
				shadow = [0 for i in xrange(0, width)]
				for i in xrange(1, width):
					x = width - 1 - i
					if row[x] and not row[x + 1]:
						shadow[x + 1] = 1
				#print y, row, shadow
				rows.append(row)
				shadows.append(shadow)

			font[char] = (height, width, descent, rows, shadows)

		#print font
		chars = [ord(x) for x in font.keys()]
		cmin, cmax = min(chars), max(chars)

		index = 0
		index_source = ""
		for ch in xrange(cmin, cmax + 1):
			key = chr(ch)
			if key in font:
				height, width, descent, rows, shadow = font[key]
				for data in [rows, shadow]:
					for row in data:
						value = 0
						for i in xrange(0, width):
							if row[i]:
								value |= (0x80 >> i)
						source += "0x%02x " %value
					if index > 255:
						print "invalid index offset"

				index_source += "%d %d %d %d " %(height, index, width, descent)
				#print key, font[key]
				if height != 5:
					index += height - 5
			else:
				index_source += "0 0 3 0 "
	source += "\n\n"
	source += ": %s_index\n%s\n\n" %(name, index_source)
	source += ": draw_%s_char\n" %name
	source += "\tif v0 < %d then return\n" %cmin
	source += "\tif v0 > %d then return\n" %cmax
	source += "\tv0 += %d\n" %-cmin
	source += "\tv0 += v0\n"
	source += "\ti := %s_index\n"
	source += "\ti += v0\n"
	source += "\ti += v0\n"
	source += "\ti += v0\n"
	source += "\ti += v0\n"
	source += "\n"
	return source

import argparse

parser = argparse.ArgumentParser(description='Compile font.')
parser.add_argument('source', help='input file')
args = parser.parse_args()


print generate('font', args.source)
