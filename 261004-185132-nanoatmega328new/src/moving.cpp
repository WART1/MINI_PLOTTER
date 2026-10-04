// ------------- DEBUG algorithme de Breseham
#include <Arduino.h>
void move(int command, int xTargetMM, int yTargetMM, int penIn) {
  long targetStepsX = (long)(xTargetMM * stepsPerMM);
  long targetStepsY = (long)(yTargetMM * stepsPerMM);

   if (penIn == 255) {
    penDown();
  } else if (penIn == 1) {
    penUp();
  }

  // 1. Calcul des distances absolues
  long dx = abs(targetStepsX - currentX);
  long dy = abs(targetStepsY - currentY);
  
  // 2. Déterminer la direction
  int sx = (currentX < targetStepsX) ? 1 : -1;
  int sy = (currentY < targetStepsY) ? 1 : -1;

  // 3. Accumulateur d'erreur pour la synchronisation
  long err = dx - dy;

  while (currentX != targetStepsX || currentY != targetStepsY) {
    unsigned long now = micros();

    if (now - lastStepX >= NORMAL_SPEED) {
      lastStepX = now;

      // Logique Bresenham
      long e2 = 2 * err;

      if (e2 > -dy) {
        err -= dy;
        currentX += sx;
        switchStepper(1, sx);
      }

      if (e2 < dx) {
        err += dx;
        currentY += sy;
        switchStepper(2, sy);
      }
    }
  }
  stopSteppers();
}
// -------------------------- DEBUG 

boolean homing() {
  isHome = 0;
  if (drawing) {
    penUp();
  }
  while (digitalRead(X_ENDSWITCH) || digitalRead(Y_ENDSWITCH)) {
    unsigned long now = micros();

    // Vitesse normale pour le tracé (tu peux utiliser maxSpeed si command == 2)
    if (now - lastStep >= HOMING_SPEED) {

      // Axe X : on bouge tant qu'on ne touche pas le switch
      if (digitalRead(X_ENDSWITCH)) {
        switchStepper(1, -1);  // -1 direction vers le switch
      } else {
        releaseMotor(1);  // On stoppe l'axe arrivé
      }
      // Axe Y : idem
      if (digitalRead(Y_ENDSWITCH)) {
        switchStepper(2, -1);
      } else {
        releaseMotor(2);
      }
      lastStep = now;
    }
  }
  // 2. Petit dégagement (optionnel mais conseillé)
  // On s'éloigne de 2mm pour ne pas laisser les switchs sous pression
  move(2, 4, 4, 1);
  // 3. Une fois les deux switchs touchés, on définit le point ZERO
  currentX = 0;
  currentY = 0;
  stopSteppers();
  isHome = 1;
  //penDown();
  triTone();
  return isHome;
}
