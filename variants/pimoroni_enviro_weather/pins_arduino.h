#pragma once

// Pin definitions taken from:
//    https://datasheets.raspberrypi.org/pico/pico-datasheet.pdf
//    https://cdn.shopify.com/s/files/1/0174/1800/files/enviro_weather_schematic.pdf

extern bool  __isPicoW;

// LEDs
#define PIN_LED        (32u)

// Serial
#define PIN_SERIAL1_TX (0u)
#define PIN_SERIAL1_RX (1u)

#define PIN_SERIAL2_TX (8u)  // Conflicts with RTC alarm interrupt input
#define PIN_SERIAL2_RX (9u)  // Conflicts with anemometer

// SPI
#define PIN_SPI0_MISO  (16u)
#define PIN_SPI0_MOSI  (19u)
#define PIN_SPI0_SCK   (18u)
#define PIN_SPI0_SS    (17u)

#define PIN_SPI1_MISO  (12u)
#define PIN_SPI1_MOSI  (15u)
#define PIN_SPI1_SCK   (14u)
#define PIN_SPI1_SS    (13u)

// Wire
#define PIN_WIRE0_SDA  (4u)
#define PIN_WIRE0_SCL  (5u)
#define PIN_WIRE0_INT  (3u)

#define PIN_WIRE1_SDA  (26u)  // Conflicts with Wind wane
#define PIN_WIRE1_SCL  (27u)

#define SERIAL_HOWMANY (3u)
#define SPI_HOWMANY    (2u)
#define WIRE_HOWMANY   (2u)

/*
 This board has extremely agressive power savings when on battery
 Pin must be held HIGH for the PicoW to receive power after wake interrupts are cleared
 System can be woken by
  - status button
  - rain tipping bucket (pulse length somewhere around 100ms)
  - external RTC alarm/timer interrupt
 PIN_LED_ALARM is connected to the RTCs CLKOUT pin,
 and is the only LED that can be powered wile in power save mode.
 It can be switched between OFF and 50% PWM with frequencies 1Hz, 1k, 2k, 4k, 8k, 16k and 32k
 where 32k is poweron default.
*/
#define PIN_HOLD_VSYS_EN    (2u)

#define PIN_LED_ACT         (6u)
#define PIN_BUTTON          (7u)
#define PIN_STATUS_INT      PIN_BUTTON
#define PIN_RTC_ALARM_INT   (8u)
#define PIN_ANEMOMETER      (9u)
#define PIN_RAIN_INT        (10u)
#define PIN_WIND_WANE       (26u)
//#define PIN_LED_ALARM     (32u + CYW43_WL_GPIO_COUNT)

#include "../generic/common.h"
