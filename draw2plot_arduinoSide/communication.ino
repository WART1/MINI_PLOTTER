/*
This function use ACK (acknowledge) - NACK (not acknowledge) protocol to communication trough serial port with a processing sketch
This protocol send a byte(6) if the checksum received is the same as the one locally calculated, or a byte(21) if there is an error
*/
byte receive[6];
byte receiveIndex = 0;
boolean newMessageFlag = 0;
byte command, xPosIn, yPosIn, penIn;
int chksm;  // check sum = verify data integrity
// https://www.geeksforgeeks.org/system-design/understanding-checksum-algorithm-for-data-integrity/


boolean receivedMessage() {
  newMessageFlag = 0;

  while (Serial.available() > 0) {
    int inByte = Serial.read();
    // if (handshake == false) {
    //   if (inByte == 65) {  // processing handshake byte
    //     handshake = true;
    //     Serial.println("OK"); // GEMINI // on a retiré la partie "recu"
    //     return false; // receivedMessage = false
    //   }
    // } else {              // si le handshake a ete fait // on receptionne le mesg positions
    if (inByte == 0) {  // header // ca commence
      receiveIndex = 0;
      receive[0] = 0;
    } else {
      receiveIndex++;
      //tone(PIEZO, 2000, 100); //OK ICI
      if (receiveIndex < 6) {  // on lit le byte suivant
        receive[receiveIndex] = inByte;
        if (receiveIndex == 5) {  // complete message
          command = receive[1];
          xPosIn = receive[2];
          yPosIn = receive[3];
          penIn = receive[4];
          chksm = receive[5];

          boolean chksmOK = false;
          // verification integrite checksum // calcul
          if (chksm == (((receive[1] + receive[2] + receive[3] + receive[4]) % 250) + 1)) {
            chksmOK = true;
          }
          if (chksmOK) {              // si checksum valide > new mesg has arrived
            if (command == 4) {       // COMMANDE STOP
              stopSteppers();         // Coupe le courant des moteurs immédiatement
              homing();               // Retour à l'origine
              Serial.write(byte(6));  // ACK pour dire que le Stop + Homing est fini
            } 
            move(command, xPosIn, yPosIn, penIn);
            //tone(PIEZO, 1000, 100);
            Serial.write(byte(6));  // ACK
            isHome = 0;
            newMessageFlag = 1;

          } else {
            //Serial.write(byte(21)); // NACK // chksm error
            int calcul = (((receive[1] + receive[2] + receive[3] + receive[4]) % 250) + 1);
            Serial.print("ERR::");
            Serial.println(calcul);
            receiveIndex = 0;  // pour la nouvelle tentative // code gemini
          }
        }
      } else {
        Serial.write(byte(21));  // NACK // message trop long (> 6)
        receiveIndex = 0;        // pour la nouvelle tentative // code gemini
      }
      // }
    }
  }
  return newMessageFlag;
}
////////////////////////////////
//      HANDSHAKE FUNCTION
void establishContact() {
  while (handshake == false) {
    Serial.println("ready");  // Envoie ready en boucle
    if (Serial.available() > 0) {
      int inByte = Serial.read();
      if (inByte == 65) {  // Attend spécifiquement le 'A' (65)
        handshake = true;
        triTone();             // Signal sonore de succès
        Serial.println("OK");  // Confirme à Processing que l'Arduino est prêt
      }
    }
    delay(100);
  }
}
