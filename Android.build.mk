#
# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include $(CLEAR_VARS)

LOCAL_MODULE := $(module)
LOCAL_MODULE_TAGS := $(module_tag)
ifeq ($(build_type),host)
# Flags for host clang builds
LOCAL_CFLAGS := -Wno-header-guard \
    -Wno-absolute-value \
    -Wno-unknown-warning-option \
    -Wno-extern-c-compat

# Always make host multilib
LOCAL_MULTILIB := both
else
LOCAL_MULTILIB := $($(module)_multilib)
endif

ifneq ($(findstring LIBRARY, $(build_target)),LIBRARY)
ifeq ($(LOCAL_MULTILIB),both)
    LOCAL_MODULE_STEM_32 := $(module)32
    LOCAL_MODULE_STEM_64 := $(module)64
endif
endif

LOCAL_ADDITIONAL_DEPENDENCIES := \
    $(LOCAL_PATH)/Android.mk \
    $(LOCAL_PATH)/Android.build.mk \

LOCAL_CFLAGS += \
    $(common_cflags) \
    $(common_cflags_$(build_type)) \
    $($(module)_cflags) \
    $($(module)_cflags_$(build_type)) \

LOCAL_CONLYFLAGS += \
    $(common_conlyflags) \
    $(common_conlyflags_$(build_type)) \
    $($(module)_conlyflags) \
    $($(module)_conlyflags_$(build_type)) \

LOCAL_CPPFLAGS += \
    $(common_cppflags) \
    $($(module)_cppflags) \
    $($(module)_cppflags_$(build_type)) \

LOCAL_C_INCLUDES := \
    $(common_c_includes) \
    $($(module)_c_includes) \
    $($(module)_c_includes_$(build_type)) \

$(foreach arch,$(libunwind_arches), \
    $(eval LOCAL_C_INCLUDES_$(arch) := $(common_c_includes_$(arch))))

LOCAL_SRC_FILES := \
    $($(module)_src_files) \
    $($(module)_src_files_$(build_type)) \

$(foreach arch,$(libunwind_arches), \
    $(eval LOCAL_SRC_FILES_$(arch) :=  $($(module)_src_files_$(arch))))

LOCAL_STATIC_LIBRARIES := \
    $($(module)_static_libraries) \
    $($(module)_static_libraries_$(build_type)) \

LOCAL_WHOLE_STATIC_LIBRARIES := \
    $($(module)_whole_static_libraries) \
    $($(module)_whole_static_libraries_$(build_type)) \

LOCAL_SHARED_LIBRARIES := \
    $($(module)_shared_libraries) \
    $($(module)_shared_libraries_$(build_type)) \

LOCAL_LDLIBS := \
    $($(module)_ldlibs) \
    $($(module)_ldlibs_$(build_type)) \

LOCAL_LDFLAGS := \
    $($(module)_ldflags) \
    $($(module)_ldflags_$(build_type)) \

# Translate arm64 to aarch64 in c includes and src files.
LOCAL_C_INCLUDES_arm64 := \
    $(subst tdep-arm64,tdep-aarch64,$(LOCAL_C_INCLUDES_arm64))

LOCAL_SRC_FILES_arm64 := \
    $(subst src/arm64,src/aarch64,$(LOCAL_SRC_FILES_arm64))

ifeq ($(build_type),target)
  include $(BUILD_$(build_target))
endif

ifeq ($(build_type),host)
  # Only build if host builds are supported.
  ifeq ($(build_host),true)
    include $(BUILD_HOST_$(build_target))
  endif
endif
