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

void setup() {
  lucid = createFont("Lucida Console",14,false);
}

void draw() {
  if(loading){
    loading = false;
    map = loadBytes(maps[0]);
    mapName = tostring(char(subset(map,17,map[16]+1)));
    makeLevel();
  }
  //read map info from header and create level
}

//make level chunk generation here
void makeLevel() {
  
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

/*chunk reference
0 = air
1 = flat ground
2 = slope up
3 = slope down
4 = half block
*/
