all: game.8o
game.8o: Makefile assets/* assets/*/* sources/*.8o *.py
		./generate-font.py assets/font/5.font > game.8o
		./generate-text.py assets/en.json >> game.8o
		cat sources/utils.8o >> game.8o
		cat sources/text.8o >> game.8o
		cat sources/tiles.8o >> game.8o
		cat sources/room.8o >> game.8o
		cat sources/panel.8o >> game.8o
		cat sources/dialogs.8o >> game.8o
		cat sources/phone.8o >> game.8o
		cat sources/splash.8o >> game.8o
		cat sources/audio.8o >> game.8o
		cat sources/game-logic.8o >> game.8o
		cat sources/main.8o >> game.8o
		./generate-texture.py assets/tiles/frame24x24.png frame 2 8 >> game.8o
		./generate-texture.py assets/phone/phone_button.png phone_button 2 16 >> game.8o
		./generate-texture.py assets/phone/phone_0a.png phone_0a 2 16 >> game.8o
		./generate-texture.py assets/phone/phone_0b.png phone_0b 2 16 >> game.8o
		./generate-texture.py assets/tiles/bed.png bed 2 16 >> game.8o
		./generate-texture.py assets/tiles/sink.png sink 2 16 >> game.8o
		./generate-texture.py assets/tiles/wall.png wall 2 8 >> game.8o
		./generate-texture.py assets/tiles/up_door1.png up_door1 2 8 >> game.8o
		./generate-texture.py assets/tiles/up_door2.png up_door2 2 8 >> game.8o
		./generate-texture.py assets/tiles/wc.png wc 2 16 >> game.8o
		./generate-texture.py assets/tiles/bottle_v.png bottle_v 2 8 >> game.8o
		./generate-texture.py assets/tiles/bottle_h.png bottle_h 2 8 >> game.8o
		./generate-texture.py assets/heads/kesha_v2.png kesha 2 16 >> game.8o
		./generate-texture.py assets/heads/kesha_v2_open.png kesha_o 2 16 >> game.8o
		./generate-texture.py assets/heads/kesha_v2_excited.png kesha_e 2 16 >> game.8o
		./generate-texture.py assets/heads/squirrel_2.png cow 2 16 >> game.8o
		./generate-texture.py assets/splash.png splash 1 16 >> game.8o

game.bin: game.8o
	./octo/octo game.8o game.bin
clean:
		rm game.bin game.8o
