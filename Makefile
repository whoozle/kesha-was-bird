all: assets/font/5.font sources/main.8o
		./generate-font.py assets/font/5.font > game.8o
		./generate-text.py assets/en.json >> game.8o
		cat sources/utils.8o >> game.8o
		cat sources/text.8o >> game.8o
		cat sources/tiles.8o >> game.8o
		cat sources/room.8o >> game.8o
		cat sources/splash.8o >> game.8o
		cat sources/audio.8o >> game.8o
		cat sources/main.8o >> game.8o
		./generate-texture.py assets/tiles/bed.png bed 2 16 >> game.8o
		./generate-texture.py assets/tiles/sink.png sink 2 16 >> game.8o
		./generate-texture.py assets/tiles/wall.png wall 2 8 >> game.8o
		./generate-texture.py assets/tiles/up_door1.png up_door1 2 8 >> game.8o
		./generate-texture.py assets/tiles/up_door2.png up_door2 2 8 >> game.8o
		./generate-texture.py assets/tiles/wc.png wc 2 16 >> game.8o
		./generate-texture.py assets/tiles/bottle_v.png bottle_v 2 8 >> game.8o
		./generate-texture.py assets/tiles/bottle_h.png bottle_h 2 8 >> game.8o
		./generate-texture.py assets/tiles/kesha_v1.png kesha 2 16 >> game.8o
		./generate-texture.py assets/tiles/galya.png galya 2 16 >> game.8o
		./generate-texture.py assets/tiles/galya_v2.png galya_v2 2 16 >> game.8o
		./generate-texture.py assets/tiles/kesha_v1_open.png kesha_o 2 16 >> game.8o
		./generate-texture.py assets/splash.png splash 1 16 >> game.8o

game.bin:
	./octo/octo game.8o game.bin
