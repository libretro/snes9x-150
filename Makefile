ifeq ($(platform),)
   platform = unix
   ifeq ($(shell uname -a),)
      platform = win
   else ifneq ($(findstring Darwin,$(shell uname -a)),)
      platform = osx
   else ifneq ($(findstring MINGW,$(shell uname -a)),)
      platform = win
   else ifneq ($(findstring win,$(shell uname -a)),)
      platform = win
   endif
endif

CXX        = g++
CC         = gcc

SNES9X_DIR := src
LIBRETRO_DIR := libretro

ifeq ($(platform), unix)
   TARGET := libretro.so
   fpic := -fPIC
   SHARED := -shared -Wl,-no-undefined -Wl,--version-script=$(LIBRETRO_DIR)/link.T
else ifeq ($(platform), osx)
   TARGET := libretro.dylib
   fpic := -fPIC
   SHARED := -dynamiclib
else ifeq ($(platform), ps3)
   TARGET := libretro_ps3.a
   CC = $(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-gcc.exe
   CXX = $(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-g++.exe
   AR = $(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-ar.exe
   CFLAGS += -DBLARGG_BIG_ENDIAN=1 -D__ppc__
else ifeq ($(platform), sncps3)
   TARGET := libretro_ps3.a
   CC = $(CELL_SDK)/host-win32/sn/bin/ps3ppusnc.exe
   CXX = $(CELL_SDK)/host-win32/sn/bin/ps3ppusnc.exe
   AR = $(CELL_SDK)/host-win32/sn/bin/ps3snarl.exe
   CFLAGS += -DBLARGG_BIG_ENDIAN=1 -D__ppc__
else ifeq ($(platform), psl1ght)
   TARGET := libretro_psl1ght.a
   CC = $(PS3DEV)/ppu/bin/ppu-gcc$(EXE_EXT)
   CXX = $(PS3DEV)/ppu/bin/ppu-g++$(EXE_EXT)
   AR = $(PS3DEV)/ppu/bin/ppu-ar$(EXE_EXT)
   CFLAGS += -DBLARGG_BIG_ENDIAN=1 -D__ppc__
else ifeq ($(platform), xenon)
   TARGET := libretro_xenon360.a
   CC = xenon-gcc$(EXE_EXT)
   CXX = xenon-g++$(EXE_EXT)
   AR = xenon-ar$(EXE_EXT)
   CFLAGS += -D__LIBXENON__ -m32 -D__ppc__
else ifeq ($(platform), ngc)
   TARGET := libretro_ngc.a
   CC = $(DEVKITPPC)/bin/powerpc-eabi-gcc$(EXE_EXT)
   CXX = $(DEVKITPPC)/bin/powerpc-eabi-g++$(EXE_EXT)
   AR = $(DEVKITPPC)/bin/powerpc-eabi-ar$(EXE_EXT)
   CFLAGS += -DGEKKO -DHW_DOL -mrvl -mcpu=750 -meabi -mhard-float -DBLARGG_BIG_ENDIAN=1 -D__ppc__
else ifeq ($(platform), wii)
   TARGET := libretro_wii.a
   CC = $(DEVKITPPC)/bin/powerpc-eabi-gcc$(EXE_EXT)
   CXX = $(DEVKITPPC)/bin/powerpc-eabi-g++$(EXE_EXT)
   AR = $(DEVKITPPC)/bin/powerpc-eabi-ar$(EXE_EXT)
   CFLAGS += -DGEKKO -DHW_RVL -mrvl -mcpu=750 -meabi -mhard-float -DBLARGG_BIG_ENDIAN=1 -D__ppc__
else
   TARGET := libretro.dll
   CC = gcc
   CXX = g++
   SHARED := -shared -Wl,-no-undefined -Wl,-static-libgcc -static-libstdc++ -s -Wl,--version-script=link.T
   CXXFLAGS += -D__WIN32__ -D__WIN32_LIBSNES__
endif


OBJECTS    = $(SNES9X_DIR)/apu.o $(SNES9X_DIR)/data.o $(SNES9X_DIR)/bsx.o $(SNES9X_DIR)/c4.o $(SNES9X_DIR)/c4emu.o $(SNES9X_DIR)/cheats.o $(SNES9X_DIR)/cheats2.o $(SNES9X_DIR)/clip.o $(SNES9X_DIR)/conffile.o $(SNES9X_DIR)/controls.o $(SNES9X_DIR)/cpu.o $(SNES9X_DIR)/cpuexec.o $(SNES9X_DIR)/cpuops.o $(SNES9X_DIR)/crosshairs.o $(SNES9X_DIR)/dma.o $(SNES9X_DIR)/dsp1.o $(SNES9X_DIR)/fxinst.o $(SNES9X_DIR)/fxemu.o $(SNES9X_DIR)/gfx.o $(SNES9X_DIR)/globals.o $(SNES9X_DIR)/memmap.o $(SNES9X_DIR)/obc1.o $(SNES9X_DIR)/ppu.o $(SNES9X_DIR)/sa1.o $(SNES9X_DIR)/sa1cpu.o $(SNES9X_DIR)/screenshot.o $(SNES9X_DIR)/sdd1.o $(SNES9X_DIR)/sdd1emu.o $(SNES9X_DIR)/seta.o $(SNES9X_DIR)/seta010.o $(SNES9X_DIR)/seta011.o $(SNES9X_DIR)/seta018.o $(SNES9X_DIR)/reader.o $(SNES9X_DIR)/snaporig.o $(SNES9X_DIR)/snapshot.o $(SNES9X_DIR)/soundux.o $(SNES9X_DIR)/snes9x.o $(SNES9X_DIR)/spc700.o $(SNES9X_DIR)/spc7110.o $(SNES9X_DIR)/srtc.o $(SNES9X_DIR)/tile.o $(LIBRETRO_DIR)/libretro.o

INCLUDES   = -I. -I$(SNES9X_DIR)

ifeq ($(platform), sncps3)
   WARNINGS_DEFINES =
   CODE_DEFINES =
else
   WARNINGS_DEFINES = -Wall -W -Wno-unused-parameter
   CODE_DEFINES = -fomit-frame-pointer
endif

CXXFLAGS    += -O3 $(CODE_DEFINES) -fno-exceptions -fno-rtti -pedantic $(WARNINGS_DEFINES) $(fpic)
CXXFLAGS    += -DHAVE_STRINGS_H -DHAVE_STDINT_H -DRIGHTSHIFT_IS_SAR -D__LIBRETRO__ -DNO_INLINE_SET_GET -DNOASM -DNEW_COLOUR_BLENDING -DRIGHTSHIFT_int8_IS_SAR -DRIGHTSHIFT_int16_IS_SAR -DRIGHTSHIFT_int32_IS_SAR -DRIGHTSHIFT_int64_is_SAR -DRIGHTSHIFT_IS_SAR -DCPU_SHUTDOWN -DSPC700_SHUTDOWN -DCORRECT_VRAM_READS -DTHREAD_SOUND
CFLAGS     = $(CXXFLAGS)

all: $(TARGET)

$(TARGET): $(OBJECTS)
ifeq ($(platform), ps3)
	$(AR) rcs $@ $(OBJECTS)
else ifeq ($(platform), sncps3)
	$(AR) rcs $@ $(OBJECTS)
else ifeq ($(platform), psl1ght)
	$(AR) rcs $@ $(OBJECTS)
else ifeq ($(platform), xenon)
	$(AR) rcs $@ $(OBJECTS)
else ifeq ($(platform), ngc)
	$(AR) rcs $@ $(OBJECTS)
else ifeq ($(platform), wii)
	$(AR) rcs $@ $(OBJECTS)
else
	$(CXX) $(fpic) $(SHARED) $(INCLUDES) -o $@ $(OBJECTS) -lm
endif

%.o: %.cpp 
	$(CXX) $(INCLUDES) $(CXXFLAGS) -c -o $@ $<

%.o: %.c
	$(CC) $(INCLUDES) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJECTS) $(TARGET)

