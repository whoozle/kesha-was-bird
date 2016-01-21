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
		./generate-texture.py assets/heads/pets2.png pets 2 16 >> $@

$(PREFIX)/dtmf.8o: Makefile ./generate-dtmf.py
		./generate-dtmf.py > $@

$(PREFIX)/banners.8o: Makefile ./generate-texture.py assets/big_pics/*
		./generate-texture.py assets/big_pics/drinking.png drinking 2 16 > $@
		./generate-texture.py assets/big_pics/fday_devise.png banner_fday_device 2 16 >> $@
		./generate-texture.py assets/big_pics/fish.png banner_fish 2 16 >> $@
		./generate-texture.py assets/big_pics/galina.png banner_galina 2 16 >> $@
		./generate-texture.py assets/big_pics/galina_pests.png banner_galina_pests 2 16 >> $@
		./generate-texture.py assets/big_pics/memory_erizer.png banner_memory_eraser 2 16 >> $@
		./generate-texture.py assets/big_pics/ninja.png banner_ninja 2 16 >> $@
		./generate-texture.py assets/big_pics/phone_notepad.png phone_screen 2 16 >> $@
		./generate-texture.py assets/big_pics/prison.png banner_prison 2 16 >> $@
		./generate-texture.py assets/big_pics/professor.png banner_professor 2 16 >> $@
		./generate-texture.py assets/big_pics/ninja_kills_kesha.png ninja_kills_kesha 2 16 >> $@
		./generate-texture.py assets/big_pics/ninja_kills_kesha_2.png ninja_kills_kesha_2 2 16 >> $@
		./generate-texture.py assets/big_pics/ninja_kills_kesha_3.png ninja_kills_kesha_3 2 16 >> $@

$(PREFIX)/tiles.8o: Makefile ./generate-texture.py assets/tiles/* assets/phone/* assets/*.png
		./generate-texture.py assets/tiles/letter.png letter 2 8 > $@
		./generate-texture.py assets/splash.png splash 2 16 >> $@
		./generate-texture.py assets/frame.png frame 2 16 >> $@
		./generate-texture.py assets/room.png room 2 16 >> $@

$(PREFIX)/dialogs.8o $(PREFIX)/dialogs.json: Makefile generate-dialogs.py
		./generate-dialogs.py $(PREFIX)

$(PREFIX)/font.8o $(PREFIX)/font-data.8o: Makefile generate-font.py assets/font/5.font
		./generate-font.py assets/font/5.font font a000 $(PREFIX)

$(PREFIX)/texts.8o $(PREFIX)/texts_data.8o: Makefile assets/en.json $(PREFIX)/dialogs.8o $(PREFIX)/dialogs.json generate-text.py
		./generate-text.py $(PREFIX) a800 assets/en.json $(PREFIX)/dialogs.json

ifeq ($(strip $(AUDIO)),)
$(PREFIX)/audio.8o: Makefile sources/splash_audio_null.8o
		cp -f sources/splash_audio_null.8o $@
else
$(PREFIX)/audio.8o: Makefile ./generate-audio.py assets/sounds/*
		./generate-audio.py assets/sounds/track3.wav splash > $@
endif

$(PREFIX)/signature.8o: Makefile ./generate-string.py
		./generate-string.py --right-align=46000 "Brought to you by Whoozle & Gazay FROM COW WITH LOVE ©2016" > $@

game.8o: Makefile $(PREFIX)/heads.8o $(PREFIX)/texts.8o $(PREFIX)/texts_data.8o $(PREFIX)/font.8o $(PREFIX)/tiles.8o $(PREFIX)/banners.8o $(PREFIX)/dtmf.8o $(PREFIX)/audio.8o $(PREFIX)/signature.8o assets/* assets/*/* sources/*.8o generate-texture.py
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
		cat sources/dispatch_event.8o >> $@
		cat sources/call_galina.8o >> $@
		cat sources/call_glitch.8o >> $@
		cat sources/call_invalid.8o >> $@
		cat sources/call_pets.8o >> $@
		cat sources/call_ninja.8o >> $@
		cat sources/call_lab.8o >> $@
		cat sources/splash.8o >> $@
		cat sources/notepad.8o >> $@
		cat sources/drinking.8o >> $@
		cat sources/audio.8o >> $@
		cat sources/game-logic.8o >> $@
		cat sources/days.8o >> $@
		cat sources/lab.8o >> $@
		cat sources/credits.8o >> $@
		echo ":org 0x1000" >> $@
		cat sources/audio_data.8o >> $@
		cat $(PREFIX)/tiles.8o >> $@
		cat $(PREFIX)/heads.8o >> $@
		cat $(PREFIX)/dtmf.8o >> $@
		cat $(PREFIX)/banners.8o >> $@
		cat $(PREFIX)/signature.8o >> $@
		cat $(PREFIX)/font_data.8o >> $@
		cat $(PREFIX)/texts_data.8o >> $@
		cat $(PREFIX)/audio.8o >> $@

game.bin: game.8o
	./octo/octo game.8o $@

game.hex: game.bin ./generate-hex.py
	./generate-hex.py game.bin $@

xclip: game.hex
	cat game.hex | xclip

pbcopy: game.hex
	cat game.hex | pbcopy

clean:
		rm -f game.bin game.8o .compiled/*
