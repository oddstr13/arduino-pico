#pragma once

#define ENVIRO_BOOT_REASON_RTC_PIN 8
#define ENVIRO_BOOT_REASON_RTC_BITS 1
#define ENVIRO_BOOT_REASON_RTC_OFFSET 0

#define ENVIRO_BOOT_REASON_BUTTON_PIN 7
#define ENVIRO_BOOT_REASON_BUTTON_BITS 3
#define ENVIRO_BOOT_REASON_BUTTON_OFFSET 1

#define ENVIRO_BOOT_REASON_RAIN_PIN 10
#define ENVIRO_BOOT_REASON_RAIN_BITS 7
#define ENVIRO_BOOT_REASON_RAIN_OFFSET 2


#ifndef __ASSEMBLER__
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif


uint32_t enviro_vars_get_boot_reason_flags();


#ifdef __cplusplus
}
#endif

#endif // __ASSEMBLER__