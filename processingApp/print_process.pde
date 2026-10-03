// *********************************** PRINTING PROCESS ***********************************
// ****************************************************************************************
// --- PRINTING LOOP
void processPrinting() {
  // si on est en cours d'impression et que le dernier point a été validé on passe au suivant
  if (printStatus == 1 && !waitingForAck) {
    if (currentPrintingIndex <= printLineIndex) {
      // Envoi du point actuel
      byte c = byte(printCP[currentPrintingIndex]);
      byte x = byte(printXP[currentPrintingIndex]);
      byte y = byte(printYP[currentPrintingIndex]);
      byte s = byte(printSP[currentPrintingIndex]);

      sendSingleMessage(c, x, y, s);
      waitingForAck = true;
    } else {
      // ON A DÉPASSÉ LE DERNIER POINT : DIRECTION HOME
      printStatus = 3;
    }
  }

  // GESTION DU RETOUR AU HOME (État 3)
  if (printStatus == 3 && !waitingForAck) {
    println(".. back to home ..");
    sendSingleMessage(byte(3), byte(1), byte(1), byte(1));
    waitingForAck = true;
    printStatus = 4; // État d'attente du dernier ACK de l'Arduino
  }

  // RÉCEPTION DU ACK (Crucial pour la reprise après pause)
  if (waitingForAck && mySerial.available() > 0) {
    int inByte = mySerial.read();
    if (inByte == 6) {
      waitingForAck = false;

      if (printStatus == 1) {
        currentPrintingIndex++; // On avance dans le buffer
      } else if (printStatus == 4) {
        // Le Home est validé, on arrête tout
        printStatus = 0;
        currentPrintingIndex = 0;
        println("Finished !");
      }
    }
  }
}
// --- BUFFER AND SENDING
void startPrintingSequence() {
  saveToPrintBuffer();
  currentPrintingIndex = 0;
  printStatus = 1;
  println("Impression lancée !");
}
void sendDrawing() {
  pressPlay();
}
void saveToPrintBuffer() {
  if (lineIndex < 0) return;

  printLineIndex = lineIndex;
  for (int i = 0; i <= lineIndex; i++) {
    printCP[i] = cP[i];
    printXP[i] = xP[i];
    printYP[i] = yP[i];
    printSP[i] = sP[i];
  }
  println("Dessin sauvegardé dans le buffer d'impression.");
}
void sendSingleMessage(byte command, byte xPos, byte yPos, byte pen) {
  int v1 = command & 0xFF;
  int v2 = xPos & 0xFF;
  int v3 = yPos & 0xFF;
  int v4 = pen & 0xFF;
  int ichksm = ((v1 + v2 + v3 + v4) % 250) + 1;
  byte chksm = byte(ichksm);

  mySerial.write(byte(0)); // Header
  mySerial.write(command);
  mySerial.write(xPos);
  mySerial.write(yPos);
  mySerial.write(pen);
  mySerial.write(chksm);
}

// --- PRINTING BUTTONS
void pressPlay() {
  // On ne lance la sauvegarde que si on n'est pas déjà en train d'imprimer
  if (printStatus == 0) {
    if (lineIndex < 0) {
      println("Rien à imprimer !");
      return;
    }
    if (!isSaved) { // le lancement de l'impression est géré par la fonction de sauvegarde saveSelected()
      println("sauvegarde en cours avant impression...");
      exportFile(); // saving process // On force la sauvegarde avant impression
    } else {
      startPrintingSequence();
    }
  } else if (printStatus == 2) {
    printStatus = 1;
    println("Reprise...");
  }
}
void pressPause() {
  if (printStatus == 1) {
    printStatus = 2;
    println("Impression en PAUSE. Le plotter finira son segment actuel.");
  }
}
void pressStop() {
  printStatus = 0;
  waitingForAck = false;

  // On récupère la position du dernier point envoyé dans le buffer
  if (printLineIndex >= 0) {
    //byte lastX = byte(printXP[currentPrintingIndex]);
    //byte lastY = byte(printYP[currentPrintingIndex]);

    // On envoie l'ordre de lever le stylo (255) à cette même position
    sendSingleMessage(byte(1), byte(1), byte(1), byte(1));
  }

  println("Impression ANNULÉE.");
}

