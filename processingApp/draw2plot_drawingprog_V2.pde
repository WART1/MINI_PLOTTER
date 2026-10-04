// Code inspiré par Niklas Roy Graffomat
// -> https://www.niklasroy.com/graffomat/
// MERCI Niklas ;-)
// *******************************************************************************************************
// **  V2 - 11/05/26
// **  - refactorisation du code de communication pour le rendre non bloquant
// *******************************************************************************************************
// *******************************************************************************************************
// -> print stauts :: 0 = ARRÊTÉ, 1 = EN COURS, 2 = PAUSE



// --- COMMUNICATION ---
import processing.serial.*;
Serial mySerial;
//String arduinoPort = "/dev/ttyUSB0"; // pour linux
String arduinoPort = "COM9"; // pour windows
String inString;
boolean arduinoReady = false;

// --- CANVAS ---
int     xMax=100; // canvas size in mm
int     yMax=100;
int     xOff=10;  // origin of canvas on the screen
int     yOff=10;
float   oldX=0; // coordinates of printhead after drawing line
float   oldY=0;
int     scale=8;

// --- DRAWING ---
int     lineIndex=0;
boolean pMousePressed=false;
boolean nMousePressed=false;
boolean mouseOnCanvas=false;
int     grid=4;
int     lineSize=5;
int     lineColor  = #2706fe;
boolean showGrid=true;
boolean showPath=false;



// --- INTERFACE ---
// ICON BTN
PImage playIcon;
PImage stopIcon; 
PImage pauseIcon;
PImage printIcon;
PImage trashIcon;  
PImage undoIcon;
PImage loadIcon;
PImage plusIcon;
PImage moinsIcon;
PImage showGridIcon;
PImage hideGridIcon;
// LOAD/SAVE
String  fileName="---";
PrintWriter output; // Pour ecrire des données dans un fichier

// --- POSITIONS ---
int[] xP = new int[30000]; //x-position
int[] yP = new int[30000]; //y-position
int[] sP = new int[30000]; //servo
int[] cP = new int[30000]; //command



// --- V2 
// États possibles : 0 = ARRÊTÉ, 1 = EN COURS, 2 = PAUSE
int printStatus = 0; 
boolean waitingForAck = false;
int currentPrintingIndex = 0;
// Tableaux de sauvegarde 
int[] printCP = new int[5000]; 
int[] printXP = new int[5000];
int[] printYP = new int[5000];
int[] printSP = new int[5000];
int printLineIndex = 0; // Le nombre de lignes à imprimer pour cette session

// process animation 
// int curentPointX, curentPointY = 0;
int lastPointX, lastPointY = 0;
PGraphics processLayer;
String overLabel = "";
boolean isSaved = false;
boolean savingProcesing = false;

void setup() {
  size(1350, 840);
  loadIcons();
  print("port dispo : ");
  // printArray(Serial.list());
  // arduinoPort = Serial.list()[0];
  //mySerial = new Serial(this, arduinoPort, 38400);
  smooth(0);
  xP[0]=1;
  yP[0]=1;
  cP[0]=2;
  sP[0]=1;
  arduinoReady = false;
  //mySerial.clear();     // Vide les "ready" envoyés pendant le boot
}

void draw() {
  overLabel = "";
  nMousePressed=mousePressed;
  background(64,64,64);
  

  drawCanvas();

  // -- draw on canvas
  mouseOnCanvas=(mouseX>=xOff && mouseX<=xOff+xMax*scale && mouseY>=yOff && mouseY<=yOff+yMax*scale); // check si la souris est dans la zone de dessin
  if  (mouseOnCanvas) { //if mouse is on canvas:
    drawCursor();
    if (mousePressed && !pMousePressed && (mouseButton == LEFT)) { // get clicked and add new point
      lineIndex++;
      xP[lineIndex]=mX;
      yP[lineIndex]=mY;
      cP[lineIndex]=1;
      sP[lineIndex]=1;
      if (lineIndex>1) {
        sP[lineIndex]=255; //pour activer le spray
      }
    }

    if (mousePressed && !pMousePressed && (mouseButton == RIGHT)) { // get clicked and add new point (a un autre endroit)
      lineIndex++;
      xP[lineIndex]=mX;
      yP[lineIndex]=mY;
      cP[lineIndex]=2; // move to target position with maximum speed without spraying
      sP[lineIndex]=1; // remet à 1 pour desactiver le spray le long du trajet 
    }
  }

  drawLines();

  // -- menu
  renderMenu();
  if (!overLabel.equals("")) {
    displayLabel(overLabel);
  }
  
  pMousePressed = nMousePressed;
  
  processPrinting();
}






// -----------------
// SERIAL EVENT HANDSHAKE
void serialEvent(Serial mySerial) {
  inString = mySerial.readStringUntil('\n');
  if(inString == null) return;
  inString = trim(inString);
  if (!arduinoReady) {
      if (inString.equals("ready")) {
        //arduinoReady = true;
        mySerial.write(byte(65)); // Envoi du code Handshake 'A'
        println("Signal 'A' envoye, en attente de l'Arduino...");
    } else if(inString.equals("OK")) {
      arduinoReady = true;
      mySerial.clear();
      println("Handshake reussi. Arduino prêt !");
    }
  } else {
    println("en attente de handshake ...");
  }
}
