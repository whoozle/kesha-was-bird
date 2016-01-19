PREFIX := .compiled
all: game.8o
$(PREFIX)/heads.8o: Makefile assets/heads/* generate-texture.py
		./generate-texture.py assets/heads/kesha_v2.png kesha 2 16 > $@
		./generate-texture.py assets/heads/kesha_v2_open.png kesha_o 2 16 >> $@
		./generate-texture.py assets/heads/kesha_v2_excited.png kesha_e 2 16 >> $@
		./generate-texture.py assets/heads/squirrel_2.png cow 2 16 >> $@
		./generate-texture.py assets/heads/professor.png professor_old 2 16 >> $@
		./generate-texture.py assets/heads/professor2.png professor 2 16 >> $@
		./generate-texture.py assets/heads/ninja.png ninja_old 2 16 >> $@
		./generate-texture.py assets/heads/ninja2.png ninja 2 16 >> $@
		./generate-texture.py assets/heads/ninja_kesha.png ninja_kesha 2 16 >> $@
		./generate-texture.py assets/heads/lab.png lab 2 16 >> $@
		./generate-texture.py assets/heads/disabled.png disabled 2 16 >> $@
		./generate-texture.py assets/heads/fish.png fish 2 16 >> $@
		./generate-texture.py assets/heads/pets.png pets 2 16 >> $@

$(PREFIX)/dtmf.8o: Makefile ./generate-dtmf.py
		./generate-dtmf.py > $@

$(PREFIX)/font.8o $(PREFIX)/font-data.8o: Makefile generate-font.py assets/font/5.font
		./generate-font.py assets/font/5.font font 5000 $(PREFIX)

$(PREFIX)/banners.8o: Makefile ./generate-texture.py assets/big_pics/*
		./generate-texture.py assets/big_pics/ninja.png banner_ninja 2 16 > $@
		./generate-texture.py assets/big_pics/professor.png banner_professor 2 16 >> $@
		./generate-texture.py assets/big_pics/galina.png banner_galina 2 16 >> $@
		./generate-texture.py assets/big_pics/prison.png banner_prison 2 16 >> $@

$(PREFIX)/tiles.8o: Makefile ./generate-texture.py assets/tiles/* assets/phone/* assets/*.png
		./generate-texture.py assets/phone/phone_button.png phone_button 2 16 > $@
		./generate-texture.py assets/phone/phone_0a.png phone_0a 2 16 >> $@
		./generate-texture.py assets/phone/phone_0b.png phone_0b 2 16 >> $@
		./generate-texture.py assets/tiles/bed.png bed 2 16 >> $@
		./generate-texture.py assets/tiles/sink.png sink 2 16 >> $@
		./generate-texture.py assets/tiles/wall.png wall 2 8 >> $@
		./generate-texture.py assets/tiles/up_door1.png up_door1 2 8 >> $@
		./generate-texture.py assets/tiles/up_door2.png up_door2 2 8 >> $@
		./generate-texture.py assets/tiles/wc.png wc 2 16 >> $@
		./generate-texture.py assets/tiles/bottle_v.png bottle_v 2 8 >> $@
		./generate-texture.py assets/tiles/bottle_h.png bottle_h 2 8 >> $@
		./generate-texture.py assets/tiles/letter.png letter 2 8 >> $@
		./generate-texture.py assets/splash.png splash 2 16 >> $@
		./generate-texture.py assets/frame.png frame 2 16 >> $@
		./generate-texture.py assets/notepad.png notepad 2 16 >> $@
		./generate-texture.py assets/drinking.png drinking 2 16 >> $@
		./generate-texture.py assets/room.png room 2 16 >> $@

$(PREFIX)/dialogs.8o $(PREFIX)/dialogs.json: Makefile generate-dialogs.py
		./generate-dialogs.py $(PREFIX)

$(PREFIX)/texts.8o $(PREFIX)/texts_data.8o: Makefile assets/en.json $(PREFIX)/dialogs.8o $(PREFIX)/dialogs.json generate-text.py
		./generate-text.py $(PREFIX) 6000 assets/en.json $(PREFIX)/dialogs.json

ifeq ($(strip $(AUDIO)),)
$(PREFIX)/audio.8o: Makefile sources/splash_audio_null.8o
		cp -f sources/splash_audio_null.8o $@
else
$(PREFIX)/audio.8o: Makefile ./generate-audio.py assets/sounds/*
		./generate-audio.py assets/sounds/track3.wav splash >> $@
endif


game.8o: Makefile $(PREFIX)/heads.8o $(PREFIX)/texts.8o $(PREFIX)/texts_data.8o $(PREFIX)/font.8o $(PREFIX)/tiles.8o $(PREFIX)/banners.8o $(PREFIX)/dtmf.8o $(PREFIX)/audio.8o assets/* assets/*/* sources/*.8o generate-texture.py
		cat sources/main.8o > $@
		cat $(PREFIX)/texts.8o >> $@
		cat $(PREFIX)/font.8o >> $@
		cat $(PREFIX)/dialogs.8o >> $@
		cat sources/utils.8o >> $@
		cat sources/text.8o >> $@
		cat sources/tiles.8o >> $@
		cat sources/room.8o >> $@
		cat sources/panel.8o >> $@
		cat sources/phone.8o >> $@
		cat sources/dispatch_call.8o >> $@
		cat sources/call_galina.8o >> $@
		cat sources/call_glitch.8o >> $@
		cat sources/call_invalid.8o >> $@
		cat sources/call_pets.8o >> $@
		cat sources/call_ninja.8o >> $@
		cat sources/splash.8o >> $@
		cat sources/notepad.8o >> $@
		cat sources/drinking.8o >> $@
		cat sources/audio.8o >> $@
		cat sources/game-logic.8o >> $@
		cat sources/days.8o >> $@
		cat sources/lab.8o >> $@
		echo ":org 0x1000" >> $@
		cat sources/audio_data.8o >> $@
		cat $(PREFIX)/tiles.8o >> $@
		cat $(PREFIX)/font_data.8o >> $@
		cat $(PREFIX)/heads.8o >> $@
		cat $(PREFIX)/dtmf.8o >> $@
		cat $(PREFIX)/texts_data.8o >> $@
		cat $(PREFIX)/banners.8o >> $@
		cat $(PREFIX)/audio.8o >> $@

game.bin: game.8o
	./octo/octo game.8o $@

game.hex: game.bin ./generate-hex.py
	./generate-hex.py game.bin $@

xclip: game.8o
	cat game.8o | xclip

pbcopy: game.8o
	cat game.8o | pbcopy

clean:
		rm -f game.bin game.8o .compiled/*
