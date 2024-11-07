/* Title: Iwannamaketophatturmoil *\
|* Author: Louie Wang             *|
|* Description: woo my unreleased *|
|* game that i havent started     *|
|* working on yet has moved from  *|
|* the sega genesis to processing *|
\*_Date:_Nov.1,_2024______________*/

import fisica.*;

void settings() {
  size(640,480);
}

boolean loading = true;
String[] maps = new String[]{"map01.lvl"};
byte[] map; //i guess we doin 7 bit integers now
String mapName;
color[] pal1 = new color[]{color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0)};
boolean[] keys = new boolean[13];
PFont lucid;
float cameraX, cameraY;
PVector playerVec;
FWorld world;
FBox player;
FCompound[] chunks;

void setup() {
  lucid = createFont("Lucida Console",14,false);
  Fisica.init(this);
  //draw thy loading screen
}

void draw() {
  if(loading){
    loading = false;
    map = loadBytes(maps[0]);
    mapName = tostring(char(subset(map,33,map[32]+1)));
    println(mapName);
    makeLevel();
  }
  processKeys();
  world.step();
  background(0);
  cameraX = width/2-player.getX();
  cameraY = height/2-player.getY();
  translate(cameraX,cameraY);
  world.draw();
}

void makeLevel() {
  int lWidth = map[16]+1;
  int lHeight = map[17]+1;
  chunks = new FCompound[lWidth*lHeight];
  world = new FWorld(0,0,lWidth*128,lHeight*128);
  for(int j=0;j<lHeight;j++){
    for(int i=0;i<lWidth;i++) {
      makeChunk(i,j);
    }
  }
  player = new FBox(32,32);
  player.setPosition(256*bi(map[18])+bi(map[19]),256*bi(map[20])+bi(map[21]));
  player.setRotatable(false);
  player.setFriction(100);
  world.add(player);
}

void makeChunk(int i,int j) {
  int lWidth = map[16]+1;
  int chunk = j*lWidth+i;
  byte ID = map[chunk+34+map[16]];
  switch(ID){
  case 0:
    chunks[chunk] = null;
    break;
  case 1:
    chunks[chunk] = new FCompound();
    FBox gnd = new FBox(128,128);
    chunks[chunk].addBody(gnd);
    chunks[chunk].setPosition(128*i+64,128*j+64);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 2:
    break;
  case 3:
    break;
  }
}

String tostring(char[] chars) { //oh lua how i wish i were programming in thy scrypt
  String retVal = "";
  for(char c:chars) {
    retVal += str(c);
  }
  return retVal;
}

int bi(byte b) {//byte to int
  return unbinary(binary(b));
}//alas, unsigned byte problem, i hath defeated thee!

//input events and controller support here
void blueDead(String CALLEDFR, String STOPCODE, String INFOSCND) { //funny
  noLoop();
  background(#000080);
  fill(255);
  textFont(lucid);
  textAlign(LEFT,TOP);
  text("A problem has been detected and this application has been halted to prevent\nfurther problems from occuring.\n\nThis application has called for\n"+CALLEDFR+"\nbut it was not found.\n\nIf this is the first time you've seen this STOP error screen,\nrestart the application. If this screen appears again, try these steps:\n\nCheck to make sure that you haven't modified the application in any way\nshape or form. It may be corrupted. Check that there are no warnings in the\nProcessing console if you are running this application from Processing.\n\nIf problems continue, contact the developer of the application and see if\nthey have an updated version of the application that has bug fixes that may\npertain to this issue. Alternatively, give the information below to the\ndeveloper to aid them in the fixing of this problem.\n\nTechnical information:\n\n*** STOP: "+STOPCODE+"\n\n***    "+INFOSCND, 0, 24);
}

void processKeys() {
  if(!(keys[1]&&keys[3])) {
    if(keys[1]) {
      player.setVelocity(-100,player.getVelocityY());
    }
    if(keys[3]) {
      player.setVelocity(100,player.getVelocityY());
    }
  }
  if(keys[1]&&!keys[4]) {
      keys[4] = true;
      player.setVelocity(player.getVelocityX(),-200);
  }
}

void keyPressed() {
  switch(keyCode){
  case 87:
    keys[0] = true;
    break;
  case 65:
    keys[1] = true;
    break;
  case 83:
    keys[2] = true;
    break;
  case 68:
    keys[3] = true;
    break;
    //addin actions n stuff later
  }
}

void keyReleased() {
  switch(keyCode){
  case 87:
    keys[0] = false;
    break;
  case 65:
    keys[1] = false;
    break;
  case 83:
    keys[2] = false;
    break;
  case 68:
    keys[3] = false;
    break;
  }
}
