// ---- DEBUG DIAGO 
// coord crée avec : https://www.niklasroy.com/robotfactory/vector_editor.html
uint8_t coordinates[6][3] = {
  {1, 1, 1},
  {32, 40, 1},
  {52, 12, 255},
  {68, 36, 255},
  {1, 1, 1}, // home
  {1,1,255}
};


void sendRawCoord(){
  for(int i = 0; i < 6; i++){
    int xVal = coordinates[i][0];
    int yVal = coordinates[i][1];
    int penVal = coordinates[i][2];
    move(2, xVal, yVal, penVal);
  }
}