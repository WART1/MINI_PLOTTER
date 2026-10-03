// --- LOAD DRAWING ---
void loadFile() {
  selectInput("Select a file to process:", "loadSelected", dataFile( "*.PLT"));
}
void loadSelected(File selection) {
  if (selection == null) {
    println("window closed");
  } else {
    println("User selected " + selection.getAbsolutePath());
    BufferedReader reader = createReader(selection.getAbsolutePath());
    fileName=selection.getName();
    String line = null;
    try {
      while ((line = reader.readLine()) != null) {
        String[] pieces = split(line, ",");
        cP[lineIndex] = int(pieces[0]);
        xP[lineIndex] = int(pieces[1]);
        yP[lineIndex] = int(pieces[2]);
        sP[lineIndex] = int(pieces[3]);
        if (cP[lineIndex]!=3) { // skip calibration
          lineIndex++;
        }
      }
      reader.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
  lineIndex--;
}

// --- SAVE DRAWING ---
void exportFile() {
  selectOutput("Save file as:", "saveSelected", dataFile( ".PLT")); // selectOutput(prompt, callback, file)
}
void saveSelected(File selection) {
  savingProcesing = true;
  if (selection == null) {
    println("window closed");
  } else {
    String path = selection.getAbsolutePath();
    // Sécurité : Ajoute l'extension si l'utilisateur l'a oubliée
    if (!path.toLowerCase().endsWith(".PLT")) {
      path += ".PLT";
    }
    fileName=selection.getName();
    println("exporting: "+path);
    output = createWriter(path); // creer un new fichier dans le path
    output.println("003,001,001,001"); // calibrate // ecrit en premier les commandes de calibration
    for (int i=0; i<=lineIndex; i++) { // draw all lines // lineIndex est incrémenté à chaque new click de souris sur le canvas
      exportLineTo(cP[i], xP[i], yP[i], sP[i]); // write coordinate to the file
    }
    output.flush();  
    output.close();
    isSaved = true; 
    startPrintingSequence(); // On lance l'impression juste après la sauvegarde
  }
  
}
void exportLineTo(int command, float newX, float newY, float servo) {  
  newX=constrain(newX, 1, 255); // constrain(val, low, high)
  newY=constrain(newY, 1, 255);
  servo=constrain(servo, 1, 255);
  command=constrain(command,1,255);
  output.println(command+","+(nf(newX, 3, 0))+","+(nf(newY, 3, 0))+","+(nf(servo, 3, 0))); // Write the coordinate to the file
  // nf(num, left, right) sert à formater les nombres, combien de digits > 034, 001, 100
}
