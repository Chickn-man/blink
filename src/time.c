#include "time.h"

void delay(uint16_t ms) {
  for (; ms != 0; ms--) {
    for (uint16_t i = 0; i < 1600; i++) ;
  }
}