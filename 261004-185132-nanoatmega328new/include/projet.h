#pragma once
#include <Arduino.h>
#include <Servo.h>
#include "constants.h"

// --- COMMUNICATION.CPP ---
extern byte receive[6];
extern byte receiveIndex;
extern boolean newMessageFlag;
extern byte command, xPosIn, yPosIn, penIn;
extern int chksm;  // check sum = verify data integrity

boolean receivedMessage();
void establishContact();
// -----------------------
// --- LOW_LEVEL_HARDWARE_FUNCTIONS.CPP ---
void switchStepper(uint8_t stepper, int direction);
void stopSteppers();
void releaseMotor(uint8_t moteur);
void penDown();
void penUp();
// -----------------------
// --- MOVING.CPP ---
void move(int command, int xTargetMM, int yTargetMM, int penIn);
boolean homing();
// -----------------------
// --- SOUND.CPP ---
void triTone();
// -----------------------
// --- DEBUG.CPP ---
void sendRawCoord();
// -----------------------
// --- MAIN.CPP ---
extern Servo myservo;
extern uint8_t stepCountX;
extern uint8_t stepCountY;
extern int directionX;
extern int directionY;                                             

extern unsigned long lastStepX;
extern unsigned long lastStep;

extern long currentX;
extern long currentY;

extern boolean isHome;
extern bool drawing;  

extern int ledPin;         // Set the pin to digital I/O 13
extern boolean ledState;  //to toggle our LED
extern boolean handshake;

