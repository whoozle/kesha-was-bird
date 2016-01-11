all: assets/font/5.font sources/main.8o
		./generate-font.py assets/font/5.font > game.8o
		./generate-text.py assets/en.json >> game.8o
		cat sources/main.8o >> game.8o

game.bin:
	./octo/octo game.8o game.bin
