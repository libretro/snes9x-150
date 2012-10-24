LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

APP_DIR := ../../src

LOCAL_MODULE    := retro

ifeq ($(TARGET_ARCH),arm)
LOCAL_CFLAGS += -DANDROID_ARM
endif

ifeq ($(TARGET_ARCH),x86)
LOCAL_CFLAGS +=  -DANDROID_X86
endif

ifeq ($(TARGET_ARCH),mips)
LOCAL_CFLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
endif

LOCAL_SRC_FILES    += = $(APP_DIR)/apu.cpp $(APP_DIR)/data.cpp $(APP_DIR)/bsx.cpp $(APP_DIR)/c4.cpp $(APP_DIR)/c4emu.cpp $(APP_DIR)/cheats.cpp $(APP_DIR)/cheats2.cpp $(APP_DIR)/clip.cpp $(APP_DIR)/conffile.cpp $(APP_DIR)/controls.cpp $(APP_DIR)/cpu.cpp $(APP_DIR)/cpuexec.cpp $(APP_DIR)/cpuops.cpp $(APP_DIR)/crosshairs.cpp $(APP_DIR)/dma.cpp $(APP_DIR)/dsp1.cpp $(APP_DIR)/fxinst.cpp $(APP_DIR)/fxemu.cpp $(APP_DIR)/gfx.cpp $(APP_DIR)/globals.cpp $(APP_DIR)/memmap.cpp $(APP_DIR)/obc1.cpp $(APP_DIR)/ppu.cpp $(APP_DIR)/sa1.cpp $(APP_DIR)/sa1cpu.cpp $(APP_DIR)/screenshot.cpp $(APP_DIR)/sdd1.cpp $(APP_DIR)/sdd1emu.cpp $(APP_DIR)/seta.cpp $(APP_DIR)/seta010.cpp $(APP_DIR)/seta011.cpp $(APP_DIR)/seta018.cpp $(APP_DIR)/reader.cpp $(APP_DIR)/snaporig.cpp $(APP_DIR)/snapshot.cpp $(APP_DIR)/soundux.cpp $(APP_DIR)/snes9x.cpp $(APP_DIR)/spc700.cpp $(APP_DIR)/spc7110.cpp $(APP_DIR)/srtc.cpp $(APP_DIR)/tile.cpp ../libretro.cpp
LOCAL_CFLAGS += -O3 -ffast-math -funroll-loops -DHAVE_STRINGS_H -DHAVE_STDINT_H -DRIGHTSHIFT_IS_SAR -D__LIBRETRO__ -DNO_INLINE_SET_GET -DNOASM -DNEW_COLOUR_BLENDING -DRIGHTSHIFT_int8_IS_SAR -DRIGHTSHIFT_int16_IS_SAR -DRIGHTSHIFT_int32_IS_SAR -DRIGHTSHIFT_int64_is_SAR -DRIGHTSHIFT_IS_SAR -DCPU_SHUTDOWN -DSPC700_SHUTDOWN -DCORRECT_VRAM_READS

include $(BUILD_SHARED_LIBRARY)
