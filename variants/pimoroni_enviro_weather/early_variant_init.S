#ifdef ARDUINO_PIMORONI_ENVIRO_WEATHER

#include "hardware/platform_defs.h"

#include "hardware/regs/addressmap.h"
#include "hardware/regs/io_bank0.h"
#include "hardware/regs/pads_bank0.h"
#include "hardware/regs/psm.h"
#include "hardware/regs/resets.h"
#include "hardware/regs/rosc.h"
#include "hardware/regs/sio.h"

#include "enviro_vars.h"

.syntax unified
.cpu cortex-m0plus
.thumb

.data
.global enviro_boot_reason_flags
enviro_boot_reason_flags:
    .word 0


.text
#define IO_FUNCTION_SIO 0x05

.type early_variant_init,%function
.thumb_func
.global early_variant_init
early_variant_init:
    // Increase ROSC frequency to ~48MHz (range 14.4 - 96)
    // Startup drops from ~160ms to ~32ms on Pico W MicroPython
    ldr r0, =(ROSC_BASE + ROSC_DIV_OFFSET)
    ldr r1, =0xaa2
    str r1, [r0]


    // Enable SIO PSM
    ldr r0, =(PSM_BASE + PSM_FRCE_ON_OFFSET)
    ldr r1, =(PSM_FRCE_ON_SIO_BITS)
    str r1, [r0]
    ldr r0, =(PSM_BASE + PSM_DONE_OFFSET)
sio_power_loop: // Wait for SIO to be powered on
    ldr r2, [r0]
    ands r2, r2, r1
    cmp r1, r2
    bne sio_power_loop


    // Disable reset on SIO
    ldr r0, =(RESETS_BASE + RESETS_RESET_OFFSET)
    ldr r1, =(RESETS_RESET_PADS_BANK0_BITS | RESETS_RESET_IO_BANK0_BITS)
    ldr r2, [r0]
    bics r2, r2, r1
    str r2, [r0]
    ldr r0, =(RESETS_BASE + RESETS_RESET_DONE_OFFSET)
sio_reset_loop:  // Wait for SIO reset to complete
    ldr r2, [r0]
    ands r2, r2, r1
    cmp r1, r2
    bne sio_reset_loop

    // #### Assert HOLD_VSYS_EN (GPIO2) to keep system powered on
    // gpio_init(2)
    ldr r0, =(PADS_BANK0_BASE + PADS_BANK0_GPIO2_OFFSET)
    ldr r1, [r0]
    ldr r2, =(PADS_BANK0_GPIO2_OD_BITS)
    bics r1, r1, r2 // Clear output disable
    ldr r2, =(PADS_BANK0_GPIO2_IE_BITS)
    orrs r1, r1, r2
    str r1, [r0]

    ldr r0, =(IO_BANK0_BASE + IO_BANK0_GPIO2_CTRL_OFFSET)
    ldr r1, =(IO_FUNCTION_SIO)
    str r1, [r0]

    // pinMode(2, OUTPUT)
    ldr r0, =(SIO_BASE + SIO_GPIO_OE_SET_OFFSET)
    ldr r1, =(1<<2) // Pin 2
    str r1, [r0]

    // digitalWrite(2, HIGH)
    ldr r0, =(SIO_BASE + SIO_GPIO_OUT_SET_OFFSET)
    ldr r1, =(1<<2) // Pin 2
    str r1, [r0]

    // #### Read wake pins to determine reason(s) for waking up
    // gpio_init(10)
    ldr r0, =(PADS_BANK0_BASE + PADS_BANK0_GPIO10_OFFSET)
    ldr r1, [r0]
    ldr r2, =(PADS_BANK0_GPIO10_OD_BITS)
    bics r1, r1, r2 // Clear output disable
    ldr r2, =(PADS_BANK0_GPIO10_IE_BITS)
    orrs r1, r1, r2
    str r1, [r0]

    ldr r0, =(IO_BANK0_BASE + IO_BANK0_GPIO10_CTRL_OFFSET)
    ldr r1, =(IO_FUNCTION_SIO)
    str r1, [r0]

    ldr r0, =(IO_BANK0_BASE + IO_BANK0_GPIO7_CTRL_OFFSET)
    ldr r1, =(IO_FUNCTION_SIO)
    str r1, [r0]

    ldr r0, =(IO_BANK0_BASE + IO_BANK0_GPIO8_CTRL_OFFSET)
    ldr r1, =(IO_FUNCTION_SIO)
    str r1, [r0]

    ldr r0, =(SIO_BASE + SIO_GPIO_IN_OFFSET)
    ldr r1, [r0]
    ldr r3, =0x80

    ldr r4, =(~(1<<ENVIRO_BOOT_REASON_RAIN_PIN))
    mov r2, r1
    bics r2, r2, r4
    lsrs r2, (ENVIRO_BOOT_REASON_RAIN_PIN - ENVIRO_BOOT_REASON_RAIN_OFFSET)
    orrs r3, r3, r2

    ldr r4, =(~(1<<ENVIRO_BOOT_REASON_BUTTON_PIN))
    mov r2, r1
    bics r2, r2, r4
    lsrs r2, (ENVIRO_BOOT_REASON_BUTTON_PIN - ENVIRO_BOOT_REASON_BUTTON_OFFSET)
    orrs r3, r3, r2

    ldr r4, =(~(1<<ENVIRO_BOOT_REASON_RTC_PIN))
    mov r2, r1
    bics r2, r2, r4
    lsrs r2, (ENVIRO_BOOT_REASON_RTC_PIN - ENVIRO_BOOT_REASON_RTC_OFFSET)
    orrs r3, r3, r2

    ldr r0, =enviro_boot_reason_flags
    str r3, [r0]

    bx lr

#endif