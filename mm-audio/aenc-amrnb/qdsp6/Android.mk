ifneq ($(BUILD_TINY_ANDROID),true)

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

# ---------------------------------------------------------------------------------
#                 Common definitons
# ---------------------------------------------------------------------------------

libOmxAmrEnc-def := -g -O3
libOmxAmrEnc-def += -DQC_MODIFIED
libOmxAmrEnc-def += -D_ANDROID_
libOmxAmrEnc-def += -D_ENABLE_QC_MSG_LOG_
libOmxAmrEnc-def += -DVERBOSE
libOmxAmrEnc-def += -D_DEBUG
libOmxAmrEnc-def += -Wconversion
libOmxAmrEnc-def += -DAUDIOV2

# ---------------------------------------------------------------------------------
#             Make the Shared library (libOmxAmrEnc)
# ---------------------------------------------------------------------------------

include $(CLEAR_VARS)

libOmxAmrEnc-inc       := $(LOCAL_PATH)/inc
libOmxAmrEnc-inc       += $(TARGET_OUT_HEADERS)/mm-core/omxcore

LOCAL_MODULE             := libOmxAmrEnc
LOCAL_MODULE_TAGS        := optional
LOCAL_VENDOR_MODULE     := true
LOCAL_CFLAGS            := $(libOmxAmrEnc-def)
LOCAL_C_INCLUDES        := $(libOmxAmrEnc-inc)
LOCAL_PRELINK_MODULE    := false
LOCAL_SHARED_LIBRARIES  := libutils liblog

LOCAL_SRC_FILES         := src/aenc_svr.c
LOCAL_SRC_FILES         += src/omx_amr_aenc.cpp

LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/techpack/audio/include
LOCAL_ADDITIONAL_DEPENDENCIES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
ifneq ($(filter sdm710 qcs605,$(TARGET_BOARD_PLATFORM)),)
  LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/vendor/qcom/opensource/audio-kernel/include
  LOCAL_ADDITIONAL_DEPENDENCIES += $(BOARD_VENDOR_KERNEL_MODULES)
endif

include $(BUILD_SHARED_LIBRARY)

# ---------------------------------------------------------------------------------
#             Make the apps-test (mm-aenc-omxamr-test)
# ---------------------------------------------------------------------------------

include $(CLEAR_VARS)

mm-amr-enc-test-inc    := $(LOCAL_PATH)/inc
mm-amr-enc-test-inc    += $(LOCAL_PATH)/test

mm-amr-enc-test-inc    += $(TARGET_OUT_HEADERS)/mm-core/omxcore
LOCAL_MODULE            := mm-aenc-omxamr-test
LOCAL_MODULE_TAGS       := optional
LOCAL_CFLAGS            := $(libOmxAmrEnc-def)
LOCAL_C_INCLUDES        := $(mm-amr-enc-test-inc)
LOCAL_PRELINK_MODULE    := false
LOCAL_SHARED_LIBRARIES  := libmm-omxcore
LOCAL_SHARED_LIBRARIES  += libOmxAmrEnc
LOCAL_VENDOR_MODULE     := true
LOCAL_SRC_FILES         := test/omx_amr_enc_test.c

include $(BUILD_EXECUTABLE)

endif

# ---------------------------------------------------------------------------------
#                     END
# ---------------------------------------------------------------------------------

