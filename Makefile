all: assets/font/5.font sources/main.8o
		./generate-font.py assets/font/5.font > game.8o
		cat sources/main.8o >> game.8o
