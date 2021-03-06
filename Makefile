##
# Mathias J. Hennig wrote this script. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and
# you think this stuff is worth it, you can buy me a beer in return.
##

##
# Where to store the install manifest
log=./.install_manifest

##
# Where to find nirvana
null=/dev/null

##
# Obligatoric stuff to pretend portability
chmod=chmod
cp=cp -r
find=find
echo=echo
mkdir=mkdir -p
rm=rm -r
tar=tar -cvzf
test=test
wc=wc
which=which
xargs=xargs
zip=zip -r

##
# Instead of a quirky DEFAULT_TARGET..
nothing:
	@$(echo) Available targets: all check install uninstall
	@$(echo) Recommended install command: PREFIX=/usr/local make all

##
# Now the "real" targets are following:
##

all: check install

check: ./loop.sh
	$(which) bc cat getopt printf sleep test >> $(null)
	$(chmod) +x ./loop.sh
	$(test) x3 = "x`./loop.sh -i 3 $(echo) 'Hello World!' | $(wc) -l`"

install: ./loop.sh ./loop.1
	$(mkdir) "$$PREFIX/bin" "$$PREFIX/man/man1"
	$(cp) ./loop.sh "$$PREFIX/bin/loop"
	$(echo) "$$PREFIX/bin/loop" >> "$(log)"
	$(cp) ./loop.1 $$PREFIX/man/man1/loop.1
	$(echo) "$$PREFIX/man/man1/loop.1" >> "$(log)"
	$(chmod) 755 "$$PREFIX/bin/loop"
	$(chmod) 644 "$$PREFIX/man/man1/loop.1" "$(log)"

uninstall:
	$(test) -e "$(log)" && $(xargs) $(rm) < "$(log)"
	$(test) -e "$(log)" && $(rm) "$(log)"

##
# Unofficial targets
##

loop-%.tar.gz: ./README ./Makefile ./loop.sh ./loop.1
	$(test) -e "loop-$*" || ( $(mkdir) "loop-$*" && $(cp) $^ "loop-$*" )
	$(tar) "loop-$*.tar.gz" "loop-$*"

loop-%.zip: ./README ./Makefile ./loop.sh ./loop.1
	$(test) -e "loop-$*" || ( $(mkdir) "loop-$*" && $(cp) $^ "loop-$*" )
	$(zip) "loop-$*.zip" "loop-$*"

clean:
	$(find) . -type d -name 'loop-*' | $(xargs) $(rm)

distclean:
	$(rm) loop-*

