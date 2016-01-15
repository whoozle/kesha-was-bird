#!/usr/bin/env python

import argparse

parser = argparse.ArgumentParser(description='generate dialogs')
parser.add_argument('prefix', help='target directory')
args = parser.parse_args()

_day, _dialog = 0, 0
_heads = None
_draw_heads = set()
_source = ''
_heads_source = ''
_first_day = True
_texts = {}
_line = 0

def day(day, dialog):
	global _first_day, _source, _day, _dialog, _heads, _line
	_day, _dialog, _line = day, dialog, 1
	if _first_day:
		_first_day = False
	else:
		_source += '\treturn\n\n'

	_heads = {1: '', 2: ''}
	_source += ': dialog_day_%d_%d\n\tpanel_draw\n' %(day, dialog)
	pass

def head(idx, name):
	global _heads_source, _heads, _source
	key = (idx, name)
	if key not in _draw_heads:
		_heads_source += """\
: heads_draw_{name}_{idx}
	v0 := dialog_head_{idx}_x
	v1 := dialog_head_{idx}_y
	i := long tile_{name}_data
	sprite v0 v1 0
	return\n\n""".format(name = name, idx = idx)
		_draw_heads.add(key)
	if _heads[idx]:
		_source += '\theads_draw_%s_%d\n' %(_heads[idx], idx) #erase old head
	_heads[idx] = name
	_source += '\theads_draw_%s_%d\n' %(name, idx) #erase old head
	pass

def text(text, sleep = 30):
	global _source, _texts, _day, _dialog, _line
	id = 'dialog_%d_%d_%d' %(_day, _dialog, _line)

	_source += """
	va := dialog_line_{line}_x
	vb := dialog_line_{line}_y
	vc := text_{id}
	draw_text

	va := {sleep}
	sleep

""".format(line = _line, id = id, sleep = sleep)
	_line += 1
	_texts[id] = text

day(1, 1)
head(1, 'kesha')
text("Ugh.. My head hurts..")
text("I need a drink..")
text("There was some vodka")
head(1, 'kesha_e')
text("Press V (F)")

day(2, 1)
text("We really need to talk")
text("1113. Galina")

day(2, 2)
head(1, 'kesha')
text("Hello! Who is this?")
head(2, 'cow')
text("It's Galina.")
head(1, 'kesha_o')
text("We need to talk")
head(1, 'kesha_e')
text("I'll have a drink first")

import os.path
import json

_source += '\treturn\n\n'
prefix = args.prefix
with open(os.path.join(prefix, 'dialogs.8o'), 'w') as f:
	_source = """\
:const dialog_line_1_x 28
:const dialog_line_2_x 26
:const dialog_line_3_x 26
:const dialog_line_4_x 24

:const dialog_line_1_y 10
:const dialog_line_2_y 20
:const dialog_line_3_y 30
:const dialog_line_4_y 40

:const dialog_head_1_x 9
:const dialog_head_1_y 10

:const dialog_head_2_x 100
:const dialog_head_2_y 20

""" + _heads_source + _source
	f.write(_source)

with open(os.path.join(prefix, 'dialogs.json'), 'w') as f:
	json.dump(_texts, f)
