# skyloft
SKYLOFT_DIR ?=
ifneq ($(SKYLOFT_DIR),)
	SKYLOFT_CPPFLAGS = -I$(SKYLOFT_DIR)/include -DSKYLOFT -mno-sse
	SKYLOFT_LDFALGS = -Wl,--wrap=main -Wl,--wrap=exit -T $(SKYLOFT_DIR)/lib/libos.ld
	SKYLOFT_LIBS = $(SKYLOFT_DIR)/lib/libshim.a $(SKYLOFT_DIR)/lib/libskyloft.a $(SKYLOFT_DIR)/lib/libutils.a -lnuma
	SKYLOFT_MSG := ==> building with skyloft
	BIN = schbench
else
	SKYLOFT_MSG := ==> no skyloft, using pthread
	BIN = schbench_lx
endif

CC      = gcc
CFLAGS  = -Wall -O2 -g -W
ALL_CFLAGS = $(CFLAGS) -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -mno-sse $(SKYLOFT_CPPFLAGS)

PROGS = $(BIN)
ALL = $(PROGS)

$(PROGS): | depend


all: $(ALL)

%.o: %.c
	$(CC) -o $*.o -c $(ALL_CFLAGS) $<

$(BIN): schbench.o $(SKYLOFT_LIBS)
	@echo "$(SKYLOFT_MSG)"
	$(CC) $(ALL_CFLAGS) -o $@ $^ -lpthread -lm $(SKYLOFT_LDFALGS)

depend:
	@$(CC) -MM $(ALL_CFLAGS) *.c 1> .depend

clean:
	-rm -f *.o schbench .depend

clean_lx:
	-rm -f *.o schbench_lx .depend

ifneq ($(wildcard .depend),)
include .depend
endif

