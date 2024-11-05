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
byte[] map;
String mapName;
color[] pal1 = new color[]{color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0)};
boolean[] keys = new boolean[13];
PFont lucid;
PVector camera;
PVector playerVec;
FWorld world;
FBox player;
FCompound[] chunks;

void setup() {
  lucid = createFont("Lucida Console",14,false);
  Fisica.init(this);
  java.util.Arrays.fill(chunks,null);
}

void draw() {
  if(loading){
    loading = false;
    map = loadBytes(maps[0]);
    mapName = tostring(char(subset(map,33,map[32]+1)));
    println(mapName);
    makeLevel();
  }
  world.step();
  world.draw();
}

void makeLevel() {
  int lWidth = map[16]+1;
  int lHeight = map[17]+1;
  world = new FWorld(0,0,lWidth*128,lHeight*128);
  for(int j=0;j<lHeight;j++){
    for(int i=0;i<lWidth;i++) {
      makeChunk(j*lWidth+i);
    }
  }
}

void makeChunk(int chunk) {
  byte ID = map[chunk+32];
  switch(ID){
  case 0:
    chunks[chunk] = null;
    break;
  case 1:
    FCompound add = new FCompound();
    FBox gnd = new FBox(128,128);
    add.addBody(gnd);
    //move into place and make static
    chunks[chunk] = add;
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

//input events and controller support here
void blueDead(String CALLEDFR, String STOPCODE, String INFOSCND) { //funny
  noLoop();
  background(#000080);
  fill(255);
  textFont(lucid);
  textAlign(LEFT,TOP);
  text("A problem has been detected and this application has been halted to prevent\nfurther problems from occuring.\n\nThis application has called for\n"+CALLEDFR+"\nbut it was not found.\n\nIf this is the first time you've seen this STOP error screen,\nrestart the application. If this screen appears again, try these steps:\n\nCheck to make sure that you haven't modified the application in any way\nshape or form. It may be corrupted. Check that there are no warnings in the\nProcessing console if you are running this application from Processing.\n\nIf problems continue, contact the developer of the application and see if\nthey have an updated version of the application that has bug fixes that may\npertain to this issue. Alternatively, give the information below to the\ndeveloper to aid them in the fixing of this problem.\n\nTechnical information:\n\n*** STOP: "+STOPCODE+"\n\n***    "+INFOSCND, 0, 24);
}

void keyPressed() {
  switch(keyCode){
  case 65:
    keys[0] = true;
    break;
  case 68:
    keys[1] = true;
    break;
  case 87:
    keys[2] = true;
    break;
  case 127:
    keys[3] = true;
    break;
  case 34:
    keys[4] = true;
    break;
  case 36:
    keys[5] = true;
    break;
  case 81:
    keys[16] = true;
    break;
  case 69:
    keys[17] = true;
    break;
  case 155://insert on windows
    keys[18] = true;
    break;
  case 156://insert on mac
    keys[18] = true;
    break;
  case 33:
    keys[19] = true;
    break;
  case 83:
    keys[20] = true;
    break;
  case 35:
    keys[21] = true;
    break;
  }
}

void keyReleased() {
  switch(keyCode){
  case 65:
    keys[0] = false;
    break;
  case 68:
    keys[1] = false;
    break;
  case 87:
    keys[2] = false;
    break;
  case 127:
    keys[3] = false;
    break;
  case 34:
    keys[4] = false;
    break;
  case 36:
    keys[5] = false;
    break;
  case 81:
    keys[16] = false;
    break;
  case 69:
    keys[17] = false;
    break;
  case 155:
    keys[18] = false;
    break;
  case 156:
    keys[18] = false;
    break;
  case 33:
    keys[19] = false;
    break;
  case 83:
    keys[20] = false;
    break;
  case 35:
    keys[21] = false;
    break;
  }
}
