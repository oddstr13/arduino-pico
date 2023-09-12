#include "enviro_vars.h"
#include <hardware/structs/watchdog.h>

#define ENVIRO_BOOT_FLAGS_UNINITIALIZED 0xffffffff

uint32_t _enviro_vars_boot_reason_flags = ENVIRO_BOOT_FLAGS_UNINITIALIZED;
uint32_t enviro_vars_get_boot_reason_flags() {
    if (_enviro_vars_boot_reason_flags == ENVIRO_BOOT_FLAGS_UNINITIALIZED) {
        _enviro_vars_boot_reason_flags = watchdog_hw->scratch[0];
    }
    return _enviro_vars_boot_reason_flags;
}