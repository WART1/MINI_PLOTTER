//---------------------------------------------------------------------------- play a short random melody with led ecffect
#include <Arduino.h>
void triTone() {
  int freq = random(200, 1000);

  for (int i = 0; i < 3; i++) {
    freq *= random(2) == 0 ? .5 : 2;
    if (freq<50)freq*=4;
    if (freq>1500)freq/=4;
    tone(PIEZO, freq, 100);
    delay(100);
  }

}