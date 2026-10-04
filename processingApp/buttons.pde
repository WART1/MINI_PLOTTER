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
//Dessine un bouton rond avec une icône et un label. Elle retourne true si le bouton est pressé, sinon false.
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
// Affiche un label à côté du curseur de la souris lorsqu'on passe sur le bouton 
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
// Affiche les boutons sur l'interface
void displayButtons(int menuY, int menuX, int buttonSize) {
   if (button(menuX, menuY, buttonSize, buttonSize, loadIcon, "Charger un dessin")) {
    loadFile();
  }
  if (button(menuX, menuY+=120, buttonSize, buttonSize, !showGrid?showGridIcon:hideGridIcon, !showGrid?"Show":"Hide")) {
    showGrid=!showGrid;
  }
  if (button(menuX + buttonSize + 20, menuY+=10, buttonSize/3, buttonSize/3, plusIcon, "Plus")) {
    //grid++;
    grid=constrain(grid+2, 2, 10);
  }  
  if (button(menuX + buttonSize + 20, menuY+=buttonSize/2, buttonSize/3, buttonSize/3, moinsIcon, "Moins")) {
    grid=constrain(grid-2, 2, 10);
  }
  if (button(menuX, menuY+=120, buttonSize, buttonSize, undoIcon, "Efface la dernière ligne")) {
    undo();
  }
  if (button(menuX + buttonSize + 20, menuY, buttonSize, buttonSize, trashIcon, "Efface tout")) {
    lineIndex=0;
    isSaved = false;
  }
  if(button(menuX, menuY+=120, buttonSize, buttonSize, printIcon, "Lance l'impression")) {
    if(lineIndex > 0){
      pressPlay();
    } 
  }
  if(printStatus !=0){
    if(button(menuX, menuY+=120, buttonSize, buttonSize, stopIcon, "Arrêter l'impression")) {
      pressStop();
    }
    if(button(menuX, menuY, buttonSize, buttonSize, pauseIcon, "Pause l'impression")){
      pressPause();
    }
  }
  if(printStatus == 2){
    if(button(menuX, menuY, buttonSize, buttonSize, playIcon, "Reprendre l'impression")){
      pressPlay();
    }
  }
}
// Affiche les infos liées à la communication avec arduino et au dessin en cours
void displayLegends(int menuY, int menuX) {
  String arduinoStatus = "";
  textSize(28);
  textAlign(LEFT);
  
  fill(255,255,2);
  text("DRAW2PLOT (v2.1): ", menuX+=200, menuY+=20);

  if(arduinoReady){
    arduinoStatus = "Prêt";
    fill(0,255,0);
  } else {
    arduinoStatus = "En attente...";
    fill(255,0,0);
  }

  text("ARDUINO : " + arduinoStatus, menuX, menuY+=30);
  fill(255);
  text("LINES: "+lineIndex, menuX, menuY+=30);
  text("GRID:  "+grid+" cm", menuX, menuY+=30);
  //text("CAP SIZE: "+capSize, 1160, menuY+=30);
  text("X: "+mX+" cm", menuX, menuY+=30);
  text("Y: "+mY+" cm", menuX, menuY+=30);
}
// Affichage du menu complet (boutons + légendes)
void renderMenu() {
  int menuY=20;
  int menuX=100*scale+40; // la taille du canvas + un offset de 20px
  int buttonSize=80;
  displayButtons(menuY, menuX, buttonSize);
  displayLegends(menuY, menuX);
}

