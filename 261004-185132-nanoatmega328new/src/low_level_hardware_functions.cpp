// ------ voir carnet pour explication si besoin
// ------------------ 28BYJ stepper | 4 coils | 5V | 5wires | 4096 stp/rev | UNIPOLAR
// ------------------ (8) half step patten : A-AB-B-BC-C-CD-D-DA (CW) AD-D-DC-C-CB-B-BA(CCW)
//---------------------------------------------------------------------------- switch the stepper coils

#include <Arduino.h>
#include "../include/projet.h"
const uint8_t stepperPins[2][4] = {
  // stepper coil pins
  { in1_A_X, in2_B_X, in3_C_X, in4_D_X },  // stepper 1 X
  { in1_A_Y, in2_B_Y, in3_C_Y, in4_D_Y }  // stepper 2 Y
};

const uint8_t halfStepPatterns[8][4] = {
  { 1, 0, 0, 0 },
  { 1, 1, 0, 0 },
  { 0, 1, 0, 0 },
  { 0, 1, 1, 0 },
  { 0, 0, 1, 0 },
  { 0, 0, 1, 1 },
  { 0, 0, 0, 1 },
  { 1, 0, 0, 1 }
};

void switchStepper(uint8_t stepper, int direction) {
  uint8_t stepperIndex = stepper - 1;  // pour lire le tableau stepperPins

  if (stepper == 1) {                                       // stepper X
    stepCountX = (8 + direction + stepCountX) % 8;          // global state of step position // de 0 à 7
    const uint8_t* pattern = halfStepPatterns[stepCountX];  // la sequence
    for (int i = 0; i < 4; i++) {                           // pour envoyer une impulsion aux bonnes bobines selon la sequence
      digitalWrite(stepperPins[stepperIndex][i], pattern[i]);
    }
  } else if (stepper == 2) {                        // stepper Y
    stepCountY = (8 + direction + stepCountY) % 8;  // global state of step position
    const uint8_t* pattern = halfStepPatterns[stepCountY];
    for (int i = 0; i < 4; i++) {
      digitalWrite(stepperPins[stepperIndex][i], pattern[i]);
    }
  }
}

//---------------------------------------------------------------------------- unpower stepper coils
void stopSteppers() {  // Stop all steppers
  for (int i = 0; i < 4; i++) {
    digitalWrite(stepperPins[0][i], LOW);
    digitalWrite(stepperPins[1][i], LOW);
  }
}

void releaseMotor(uint8_t moteur) {  // 1, 2, 3  stop selected stepper
  uint8_t stepperIndex = moteur - 1;
  for (int i = 0; i < 4; i++) {
    digitalWrite(stepperPins[stepperIndex][i], LOW);
  }
}

//---------------------------------------------------------------------------- pen up and down (servo)
void penDown() { // original penUP
  stopSteppers();
  if (drawing) {
    myservo.attach(SERVO);
    myservo.write(servoPenDown);
    delay(400);
    myservo.detach();
  }
  drawing = false;  // global state of pen position
}

void penUp() { // original penDown
  stopSteppers();
  if (!drawing) {
    myservo.attach(SERVO);
    myservo.write(servoPenUp);
    delay(400);
    myservo.detach();
  }
  drawing = true;  // global state of pen position
}