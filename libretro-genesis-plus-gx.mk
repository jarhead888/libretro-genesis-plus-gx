################################################################################
#
# LIBRETRO_GENESIS-PLUS-GX
#
################################################################################
LIBRETRO_GENESIS-PLUS-GX_DEPENDENCIES = retroarch
LIBRETRO_GENESIS-PLUS-GX_DIR=$(BUILD_DIR)/libretro-genesis-plus-gx

$(LIBRETRO_GENESIS-PLUS-GX_DIR)/.source:
	mkdir -pv $(LIBRETRO_GENESIS-PLUS-GX_DIR)
	cp -raf package/libretro-genesis-plus-gx/src/* $(LIBRETRO_GENESIS-PLUS-GX_DIR)
	touch $@

$(LIBRETRO_GENESIS-PLUS-GX_DIR)/.configured : $(LIBRETRO_GENESIS-PLUS-GX_DIR)/.source
	touch $@

libretro-genesis-plus-gx-binary: $(LIBRETRO_GENESIS-PLUS-GX_DIR)/.configured $(LIBRETRO_GENESIS-PLUS-GX_DEPENDENCIES)
	BASE_DIR="$(BASE_DIR)" CFLAGS="$(TARGET_CFLAGS) -I${STAGING_DIR}/usr/include/ -I$(LIBRETRO_GENESIS-PLUS-GX_DIR)/" CXXFLAGS="$(TARGET_CXXFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" $(MAKE) -C $(LIBRETRO_GENESIS-PLUS-GX_DIR)/ -f Makefile.libretro platform="unix-allwinner-h6"

libretro-genesis-plus-gx: libretro-genesis-plus-gx-binary
	mkdir -p $(TARGET_DIR)/usr/lib/libretro
	cp -raf $(LIBRETRO_GENESIS-PLUS-GX_DIR)/genesis_plus_gx_libretro.so $(TARGET_DIR)/usr/lib/libretro/
	$(TARGET_STRIP) $(TARGET_DIR)/usr/lib/libretro/genesis_plus_gx_libretro.so

ifeq ($(BR2_PACKAGE_LIBRETRO_GENESIS-PLUS-GX), y)
TARGETS += libretro-genesis-plus-gx
endif
