# This Makefile is based on LuaSec's Makefile. Thanks to the LuaSec developers.
# Inform the location to intall the modules

PREFIX=/usr/local/openresty

LUAPATH  = $(PREFIX)/luajit
LUACPATH = $(PREFIX)/luajit/lib/lua/5.1
INCDIR   = $(PREFIX)/luajit/include/luajit-2.1
LIBDIR   = $(PREFIX)/lualib

# For Mac OS X: set the system version
MACOSX_VERSION = 10.4

CMOD = zlib.so
OBJS = lua_zlib.o

LIBS = -lz -lm
WARN = -Wall -pedantic

BSD_CFLAGS  = -O2 -fPIC $(WARN) -I$(INCDIR) $(DEFS)
BSD_LDFLAGS = -O -shared -fPIC -L$(LIBDIR)

LNX_CFLAGS  = -O2 -fPIC $(WARN) -I$(INCDIR) $(DEFS)
LNX_LDFLAGS = -O -shared -fPIC -L$(LIBDIR)

MAC_ENV     = env MACOSX_DEPLOYMENT_TARGET='$(MACVER)'
MAC_CFLAGS  = -O2 -fPIC -fno-common $(WARN) -I$(INCDIR) $(DEFS)
MAC_LDFLAGS = -bundle -undefined dynamic_lookup -fPIC -L$(LIBDIR)

CC = gcc
LD = $(MYENV) gcc
CFLAGS  = $(MYCFLAGS)
LDFLAGS = $(MYLDFLAGS)

.PHONY: all clean install none linux bsd macosx

all:
	@echo "Usage: $(MAKE) <platform>"
	@echo "  * linux"
	@echo "  * bsd"
	@echo "  * macosx"

install: $(CMOD)
	cp $(CMOD) $(LIBDIR)

uninstall:
	rm $(LUACPATH)/zlib.so

linux:
	@$(MAKE) $(CMOD) MYCFLAGS="$(LNX_CFLAGS)" MYLDFLAGS="$(LNX_LDFLAGS)" INCDIR="$(INCDIR)" LIBDIR="$(LIBDIR)" DEFS="$(DEFS)"

bsd:
	@$(MAKE) $(CMOD) MYCFLAGS="$(BSD_CFLAGS)" MYLDFLAGS="$(BSD_LDFLAGS)" INCDIR="$(INCDIR)" LIBDIR="$(LIBDIR)" DEFS="$(DEFS)"

macosx:
	@$(MAKE) $(CMOD) MYCFLAGS="$(MAC_CFLAGS)" MYLDFLAGS="$(MAC_LDFLAGS)" MYENV="$(MAC_ENV)" INCDIR="$(INCDIR)" LIBDIR="$(LIBDIR)" DEFS="$(DEFS)"

clean:
	rm -f $(OBJS) $(CMOD)

.c.o:
	$(CC) -c $(CFLAGS) $(DEFS) -I$(INCDIR) -o $@ $<

$(CMOD): $(OBJS)
	$(LD) $(LDFLAGS) -L$(LIBDIR) $(OBJS) $(LIBS) -o $@
