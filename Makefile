JS_FILES = \
	src/start.js \
	src/Id.js \
	src/Svg.js \
	src/Transform.js \
	src/Cache.js \
	src/Url.js \
	src/Dispatch.js \
	src/Queue.js \
	src/Map.js \
	src/Layer.js \
	src/Image.js \
	src/GeoJson.js \
	src/Dblclick.js \
	src/Drag.js \
	src/Wheel.js \
	src/Arrow.js \
	src/Hash.js \
	src/Interact.js \
	src/Compass.js \
	src/Grid.js \
	src/end.js

JS_COMPILER = \
	java -jar lib/google-compiler/compiler-20100616.jar \
	--charset UTF-8

WWW_FILES = \
	polymaps.min.js \
	lib/nns/nns.min.js \
	lib/blueprint/screen.css \
	lib/modernizr/modernizr.min.js \
	www/index.html \
	www/logo-big.js \
	www/logo-small.js \
	www/style.css

WWW_EX_FILES = \
  www/ex/bing.html \
  www/ex/bing-sm.png \
  www/ex/bluemarble-sm.png \
  www/ex/cluster-sm.png \
  www/ex/features-sm.png \
  www/ex/flickr-sm.png \
  www/ex/grid-sm.png \
  www/ex/logo-big.png \
  www/ex/logo-small.png \
  www/ex/midnightcommander-sm.png \
  www/ex/overlay-sm.png \
  www/ex/paledawn-sm.png \
  www/ex/population-sm.png \
  www/ex/shadow-sm.png \
  www/ex/statehood-sm.png \
  www/ex/streets-sm.png \
  www/ex/tiles-sm.png \
  www/ex/transform-sm.png \
  www/ex/unemployment-sm.png

PYGMENT = /Library/Pygments-1.3.1/pygmentize
PYGMENT_STYLE = trac

all: polymaps.min.js polymaps.js

polymaps.min.js: polymaps.js
	rm -f $@
	echo "// $(shell git rev-parse --short HEAD)" >> $@
	$(JS_COMPILER) < polymaps.js >> $@

polymaps.js: $(JS_FILES) Makefile
	rm -f $@
	echo "// $(shell git rev-parse HEAD)" >> $@
	cat $(JS_FILES) >> $@
	chmod a-w $@

%.d: %.m4 Makefile www/m4d.sh
	www/m4d.sh $< > $@

include $(patsubst %.html,%.d,$(filter %.html,$(WWW_EX_FILES)))

html: $(WWW_FILES) $(WWW_EX_FILES) Makefile
	rm -rf $@
	mkdir $@ $@/ex
	cp $(WWW_FILES) $@
	cp $(WWW_EX_FILES) $@/ex

%.html: %.m4 Makefile
	rm -f $@
	pushd $(dir $<) && m4 -P < $(notdir $<) > $(notdir $@) && popd
	chmod a-w $@

%.js.html: %.js Makefile
	$(PYGMENT) -f html -O cssclass=syntax,style=$(PYGMENT_STYLE) -l js $(filter %.js,$^) > $@

%.js.txt: %.js Makefile
	cat $(filter %.js,$^) > $@

clean:
	rm -rf polymaps.js polymaps.min.js html
	rm -f $(patsubst %.html,%.d,$(filter %.html,$(WWW_EX_FILES)))
