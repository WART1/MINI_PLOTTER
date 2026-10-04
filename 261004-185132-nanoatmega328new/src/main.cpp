/*
 ____  ____      ___        __  ____    ____  _     ___ _____ 
|  _ \|  _ \    / \ \      / / |___ \  |  _ \| |   / _ \_   _|
| | | | |_) |  / _ \ \ /\ / /    __) | | |_) | |  | | | || |  
| |_| |  _ <  / ___ \ V  V /    / __/  |  __/| |__| |_| || |  
|____/|_| \_\/_/   \_\_/\_/    |_____| |_|   |_____\___/ |_|  
                                                              
// Inspire de : https://niklasroy.com/graffomat/ THANKS Niklas!

Protocol:

  BYTE 0: Start   (0)      /  start signal
  BYTE 1: Command (1-255) // not used
  BYTE 2: X-POS   (1-100)  //-> X-POS va de 1 à 100 mm
  BYTE 3: Y-POS   (1-100) //-> Y-pos va de 1 à 100 mm
  BYTE 4: PEN   (1-255)  UP - DOWN
  BYTE 5: CHKSM   (B0+B1+B2+B3+B4)%250+1 
  
*/
#include <Arduino.h>
#include <Servo.h>
#include "constants.h"
Servo myservo;           //                                                   servo to lift / lower the pen


uint8_t stepCountX = 0;  //                                                   global step counter motor X
uint8_t stepCountY = 0;  //                                                   global step counter motor Y

int directionX = 1;
int directionY = 1;  //                                                      current moving direction

unsigned long lastStepX = 0;
unsigned long lastStep = 0;

long currentX = 0;
long currentY = 0;

boolean isHome = 0;
bool drawing = false;     //                                                    pen position (true = pen is down / false = pen is up)


int ledPin = 13;         // Set the pin to digital I/O 13
boolean ledState = LOW;  //to toggle our LED
boolean handshake = false;

void setup() {
  pinMode(in1_A_X,     OUTPUT);
  pinMode(in2_B_X,     OUTPUT);
  pinMode(in3_C_X,     OUTPUT);
  pinMode(in4_D_X,     OUTPUT);

  pinMode(in1_A_Y,     OUTPUT);
  pinMode(in2_B_Y,     OUTPUT);
  pinMode(in3_C_Y,     OUTPUT);
  pinMode(in4_D_Y,     OUTPUT);
  pinMode(X_ENDSWITCH, INPUT_PULLUP);
  pinMode(Y_ENDSWITCH, INPUT_PULLUP);
  pinMode(PIEZO,       OUTPUT);
  pinMode(SERVO,       OUTPUT);
  pinMode(ledPin,      OUTPUT);
  Serial.begin(38400);
  //triTone();
  tone(PIEZO, 2000, 100);
  delay(200);
  establishContact();  // send a byte to establish contact until receiver responds
  homing();
  //sendRawCoord();
}


void loop() {
  if (receivedMessage()) {
    // ICI : Ton code pour faire bouger les moteurs
    // Exemple : movePlotter(xPosIn, yPosIn, penIn);

    digitalWrite(ledPin, HIGH);
    delay(10);  // Petit flash LED pour confirmer la réception
    digitalWrite(ledPin, LOW);
  }
  // penUp();
  // delay(3000);
  // penDown();
  // delay(3000);
}





void blink() {
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);
}

///////////////////////////////////
// TO DO NEXT TIME
//////////////////////////////////
/*
-> Ajouter un bouton d'arrêt si ça part mal, qui arrête la communication, revient au home et relance le dessin  
-> lorsque je met le servo sur le 5V d'arduino ça fou tout en l'air, ça fait reboot l'arduino > mettre le +5v du servo sur la pile 
*/
