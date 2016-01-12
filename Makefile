all: assets/font/5.font sources/main.8o
		./generate-font.py assets/font/5.font > game.8o
		./generate-text.py assets/en.json >> game.8o
		cat sources/utils.8o >> game.8o
		cat sources/text.8o >> game.8o
		cat sources/tiles.8o >> game.8o
		cat sources/room.8o >> game.8o
		cat sources/splash.8o >> game.8o
		cat sources/main.8o >> game.8o
		./generate-texture.py assets/tiles/bed.png bed 2 16 >> game.8o
		./generate-texture.py assets/tiles/sink.png sink 2 16 >> game.8o
		./generate-texture.py assets/tiles/wall.png wall 2 8 >> game.8o
		./generate-texture.py assets/tiles/wc.png wc 2 16 >> game.8o
		./generate-texture.py assets/splash.png splash 1 16 >> game.8o

game.bin:
	./octo/octo game.8o game.bin
