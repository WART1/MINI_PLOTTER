/*
La focntion 'button' dessine un bouton rond avec une icône et un label. Elle retourne true si le bouton est pressé, sinon false.
*/
boolean button(int buttonX, int buttonY, int buttonW, int buttonH, PImage icon, String label) {
  int padding = 10; 
  boolean pressed=false;

  boolean over=(mouseX>=buttonX && mouseY>=buttonY && mouseX<= buttonX+buttonW && mouseY<=buttonY+buttonH);

  if (over) {
    fill(122,229,93);
    overLabel = label;

    if (nMousePressed && pMousePressed==false) {
      pressed=true;
      fill(160);
    }
  } else {
    fill(213,229,93);
  }

  noStroke();
  ellipse(buttonX+buttonW/2, buttonY+buttonH/2, buttonW+padding, buttonH+padding); // bouton rond

  if (icon != null) {
    imageMode(CENTER);
    // On redimensionne l'image pour qu'elle tienne dans le bouton (80% de la hauteur)
    image(icon, buttonX + buttonW/2, buttonY + buttonH/2, buttonH * 0.8, buttonH * 0.8);
  }

  return pressed;
}
// --- DISPLAY BUTTONS ---
void displayLabel(String label) {
  pushMatrix(); // Sauvegarde l'état du dessin
  
  // Petit rectangle de fond pour la lisibilité
  fill(0, 150); // Noir transparent
  noStroke();
  float txtWidth = textWidth(label) + 20;
  rect(mouseX+50, mouseY, txtWidth, 40, 5); // Positionner près de ta zone de légende
  
  // Le texte
  fill(255); // Blanc
  textSize(22);
  // textAlign(CENTER, CENTER);
  text(label, mouseX+70, mouseY+25); 
  
  popMatrix(); // Restaure l'état
}
void displayButtons(int menuY) {
   if (button(900, menuY, 80, 80, loadIcon, "Charger un dessin")) {
    loadFile();
  }
  if (button(900, menuY+=120, 80, 80, !showGrid?showGridIcon:hideGridIcon, !showGrid?"Show":"Hide")) {
    showGrid=!showGrid;
  }
  if (button(900, menuY+=100, 40, 40, plusIcon, "Plus")) {
    //grid++;
    grid=constrain(grid+2, 2, 10);
  }  
  if (button(950, menuY, 40, 40, moinsIcon, "Moins")) {
    grid=constrain(grid-2, 2, 10);
  }
  if (button(900, menuY+=120, 80, 80, undoIcon, "Efface la dernière ligne")) {
    undo();
  }
  if (button(1020, menuY, 80, 80, trashIcon, "Efface tout")) {
    lineIndex=0;
    isSaved = false;
  }
  if(button(900, menuY+=120, 100, 100, printIcon, "Lance l'impression")) {
    if(lineIndex > 0){
      pressPlay();
    } 
  }
  if(printStatus !=0){
    if(button(900, menuY+=120, 100, 100, stopIcon, "Arrêter l'impression")) {
      pressStop();
    }
    if(button(1020, menuY, 100, 100, pauseIcon, "Pause l'impression")){
      pressPause();
    }
  }
  if(printStatus == 2){
    if(button(1140, menuY, 100, 100, playIcon, "Reprendre l'impression")){
      pressPlay();
    }
  }
}
void displayLegends(int menuY) {
  String arduinoStatus = "";
  textSize(28);
  textAlign(LEFT);
  
  fill(255,255,2);
  text("DRAW2PLOT (v2.1): ", 1180, menuY+=20);

  if(arduinoReady){
    arduinoStatus = "Prêt";
    fill(0,255,0);
  } else {
    arduinoStatus = "En attente...";
    fill(255,0,0);
  }

  text("ARDUINO : " + arduinoStatus, 1180, menuY+=30);
  fill(255);
  text("LINES: "+lineIndex, 1180, menuY+=30);
  text("GRID:  "+grid+" cm", 1180, menuY+=30);
  //text("CAP SIZE: "+capSize, 1160, menuY+=30);
  text("X: "+mX+" cm", 1180, menuY+=30);
  text("Y: "+mY+" cm", 1180, menuY+=30);
}
void renderMenu() {
  int menuY=20;
  displayButtons(menuY);
  displayLegends(menuY);
}

// --- LOAD ICONES IMAGES ---
void loadIcons() {
  playIcon = loadImage("icons/play.png");
  stopIcon = loadImage("icons/stop.png");
  pauseIcon = loadImage("icons/pause.png");
  printIcon = loadImage("icons/printer.png");
  trashIcon = loadImage("icons/trash.png");
  undoIcon = loadImage("icons/undo.png");
  loadIcon = loadImage("icons/load.png");
  plusIcon = loadImage("icons/plus.png");
  moinsIcon = loadImage("icons/moins.png");
  showGridIcon = loadImage("icons/showGrid.png");
  hideGridIcon = loadImage("icons/hideGrid.png");
}
// --- COLOR PICKER (non used yet) ---
int colorButton(int buttonX, int buttonY, int buttonW, int buttonH, int buttonColor) {
  int returnColor=lineColor;

  noStroke();
  boolean over=(mouseX>=buttonX && mouseY>=buttonY && mouseX<= buttonX+buttonW && mouseY<=buttonY+buttonH);
  if (over) {
    stroke(255);
    strokeWeight(1);
    if (nMousePressed && pMousePressed==false) {
      returnColor=buttonColor;
      println("change color");
    }
  }
  fill(buttonColor);
  rect(buttonX, buttonY, buttonW, buttonH);
  return returnColor;
}
