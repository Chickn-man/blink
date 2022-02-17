PROGNAME = blink

CHIP = atmega328p
PROGRAMER = arduino

PORT = /dev/ttyACM0

CC = avr-gcc
AS = avr-as
LD = avr-ld
AD = avrdude

AVRINC = /usr/avr/include
AVRLIB = /usr/avr/lib

INCS = -I$(AVRINC)
LIBS = -L$(AVRLIB)

CFLAGS = -nostdlib
ASFLAGS =
LDFLAGS = 

SRCDIR := src
OBJDIR := lib
BUILDDIR = bin

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SRC = $(call rwildcard,$(SRCDIR),*.c)
OBJS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRC))
DIRS = $(wildcard $(SRCDIR)/*)

build: $(OBJS) link
	@ mkdir -p $(BUILDDIR)
	
$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@ echo !==== COMPILING $^
	@ mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $^ -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.s
	@ echo !==== ASEMBLING $^
	@ mkdir -p $(@D)
	$(AS) $(ASFLAGS) $^ -f elf64 -o $@
	
link:
	@ echo !==== LINKING $^
	$(CC) -o $(BUILDDIR)/$(PROGNAME) $(OBJS)

clean:
	-@ rm $(BUILDDIR)/$(PROGNAME)
	-@ rm -r $(OBJDIR)

upload:
	sudo chmod a+rw $(PORT)
	@ $(AD) -C/home/hlep/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/etc/avrdude.conf -v -p$(CHIP) -c$(PROGRAMER) -P$(PORT) -b115200 -D -Uflash:w:$(CURDIR)/$(BUILDDIR)/$(PROGNAME)
