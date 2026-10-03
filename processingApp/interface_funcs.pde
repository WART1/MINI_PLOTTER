
int mX=0;
int mY=0;
void drawCursor() { // contraint les valeur de mouseX et mouseY dans les valeur max du plotter

  mX=(mouseX-xOff)/scale; // mX pos - bordure / 4
  mY=(mouseY-yOff)/scale;
 
  // pour que le cursor soit aimanté sur la grille
  float mXGrid=(int(float(mX)/(grid)+.5))*(grid); 
  float mYGrid=(int(float(mY)/(grid)+.5))*(grid);
  
  // contrain to size of plotter
  mX=constrain(int(mXGrid), 1, xMax);
  mY=constrain(int(mYGrid), 1, yMax);
  
  
  // couleur du curseur
  strokeWeight(2);
  stroke(0, 255, 25);
  // draw the cursor
  line((mX+5)*scale+xOff, (mY+5)*scale+yOff, (mX-5)*scale+xOff, (mY-5)*scale+yOff);
  line((mX-5)*scale+xOff, (mY+5)*scale+yOff, (mX+5)*scale+xOff, (mY-5)*scale+yOff);
}

void lineTo(int command, float newX, float newY, float servo) {
  command=constrain(command, 1, 255);
  newX=constrain(newX, 1, 255);
  newY=constrain(newY, 1, 255);
  servo=constrain(servo, 1, 255);

 
  stroke(lineColor, int(servo)*.75);
  strokeWeight(lineSize);

  line(oldX*scale+xOff, oldY*scale+yOff, newX*scale+xOff, newY*scale+yOff);
  
  oldX=newX;
  oldY=newY;
}

// --- DRAW CANVAS AND GRID ---
void drawCanvas() {
  noStroke();
  
  rect(xOff, yOff, 100*scale, 100*scale); // la partie blanche
  fill(0,0,250);
  circle((xOff+(50*scale)), (yOff+(50*scale)), 10); // dessiner le point au centre

  stroke(255,0,0);
  if (showGrid) {
    strokeWeight(1);
    for (int i=0; i<=xMax; i+=grid) {
      line(i*scale+xOff, yOff, i*scale+xOff, yOff+yMax*scale);
    }
    for (int i=0; i<=yMax; i+=grid) {
      line(xOff, i*scale+yOff, xOff+xMax*scale, i*scale+yOff);
    }
  }
}

// -- DRAW ALL LINES --
void drawLines() {  

  oldX=1; // devient newX lineTo()
  oldY=1; // devient newY

  for (int i=0; i<=lineIndex; i++) { 
    lineTo(cP[i], xP[i], yP[i], sP[i]);
  }
  if (lineIndex > 0 && mouseOnCanvas)lineTo(1, mX, mY, 64); // la ligne en opacité qui suit le cursor
}

// -- undo last line
void undo() {
  if (lineIndex>0)lineIndex--;
}


// --- DISPLAY PROCESS ---
void processStatus(){
  // pouvoir suivre la progression de l'impression
}