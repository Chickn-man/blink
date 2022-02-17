#include "reg.h"
#include "time.h"

#define LED 0b00100000

void _start() {
  DDRB = LED;
  for (;;) {
    PORTB = LED;
    delay(1000);
    PORTB = 0b00000000;
    delay(1000);
  }
}