TARGET = danmaku
COMMON_CFLAGS += -O2 `pkg-config glib-2.0 pango fontconfig pangoft2 freetype2 libgpiod zbar --cflags` -g3
CFLAGS += $(COMMON_CFLAGS) -std=gnu99
CXXFLAGS += $(COMMON_CFLAGS) -std=c++11
LDFLAGS += -pthread

LIBS +=  `pkg-config --libs freetype2 glib-2.0 pango fontconfig pangoft2 libgpiod zbar`

$(TARGET): danmaku_driver.o danmaku.o ring.o render.o qrcode_config.o

	$(CXX) -o $@ $(LDFLAGS) $^ $(LIBS)
	