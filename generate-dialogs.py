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
_text = 0

def clear_state():
	global _line, _heads
	_line = 1
	_heads = {1: '', 2: ''}

def day(day, dialog):
	global _first_day, _source, _day, _dialog, _text
	_day, _dialog, _text = day, dialog, 1
	if _first_day:
		_first_day = False
	else:
		_source += '\treturn\n\n'

	clear_state()
	_source += ': dialog_day_%d_%d\n\tpanel_draw\n' %(day, dialog)

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
	global _source, _texts, _day, _dialog, _line, _text
	id = 'dialog_%d_%d_%d' %(_day, _dialog, _text)

	_source += """
	va := dialog_line_{line}_x
	vb := dialog_line_{line}_y
	vc := text_{id}
	draw_text

""".format(line = _line, id = id)
	if sleep > 0:
		_source += """
	va := {sleep}
	sleep

""".format(sleep = sleep)

	_line += 1
	_text += 1
	_texts[id] = text

def call(name, *args):
	global _source
	if len(args) > 4:
		raise Exception("only 4 arguments supported")
	regs = ['va', 'vb', 'vc', 'vd']
	_source += '\n'.join(["\t%s := %s" %(reg, arg) for reg, arg in zip(regs, args)])
	_source += '\n\t%s\n\n' %name

def clear():
	clear_state()
	call('panel_draw')

day(1, 1)
head(1, 'kesha')
text("Ugh.. My head hurts..")
text("I need a drink..")
text("There was some vodka")
head(1, 'kesha_e')
text("Press V (F)")
#call('drink_vodka', arg1, arg2)

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

day(3, 1)
head(1, 'kesha_o')
text("Hi, it's Kesha")
head(2, 'cow')
text("Can we talk now?")
text("You need to", 0)

clear()

head(1, 'professor')
text('Excuse me for my', 0)
text('interruption, lovebirds...')
text('but I need Galina', 0)
text('RIGHT NOW!!!')

day(4, 1)
head(1, 'kesha_o')
text("Hi, it's me again")

head(2, 'cow')
text("Can we", 0)

clear()

head(1, 'ninja')
text('Pardon me')
text('I\'d like to help you')
text('Call me, 1337') #leet :D

text('N I N J A')


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