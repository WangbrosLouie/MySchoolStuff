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
//remind me to do the stuff on this here web page https://answers.microsoft.com/en-us/outlook_com/forum/all/how-to-stop-the-new-outlook-from-automatically/34246983-2a13-4462-8a8a-df618c36ca3f?page=4
boolean loading = true;
String[] maps = new String[]{"map01.lvl"};
byte[] map;
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
  background(200);
  cameraX = width/2-player.getX();
  cameraY = height/2-player.getY();
  translate(cameraX,cameraY);
  world.draw();
}

void makeLevel() {
  int lWidth = bi(map[16])+1;
  int lHeight = bi(map[17])+1;
  println(lWidth,lHeight);
  chunks = new FCompound[lWidth*lHeight];
  world = new FWorld(-128,-128,lWidth*128+128,lHeight*128+128);
  for(int j=0;j<lHeight;j++){
    for(int i=0;i<lWidth;i++) {
      makeChunk(i,j);
    }
  }
  player = new FBox(32,64);
  player.setPosition(256*bi(map[18])+bi(map[19]),256*bi(map[20])+bi(map[21]));
  player.setRotatable(false);
  player.setFriction(100);
  player.setName("00");
  world.add(player);
}

void makeChunk(int i,int j) {
  int lWidth = bi(map[16])+1;
  int chunk = j*lWidth+i;
  byte ID = map[chunk+33+bi(map[32])];
  switch(ID){
  case 0:
    chunks[chunk] = null;
    break;
  case 1:
    chunks[chunk] = new FCompound();
    FBox gnd = new FBox(128,127);
    gnd.setPosition(65,65.5);
    gnd.setName("00");
    FLine jmp = new FLine(1,1,129,1);
    jmp.setName("01");
    chunks[chunk].addBody(gnd);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i-1,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 2:
    chunks[chunk] = new FCompound();
    FPoly slo = new FPoly();
    slo.vertex(1,128);
    slo.vertex(128,1);
    slo.vertex(128,128);
    slo.setFriction(0.1);
    slo.setName("00");
    jmp = new FLine(0,128,128,0);
    jmp.setName("01");
    chunks[chunk].addBody(slo);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 3:
    chunks[chunk] = new FCompound();
    slo = new FPoly();
    slo.vertex(0,1);
    slo.vertex(127,128);
    slo.vertex(0,128);
    slo.setFriction(0.1);
    slo.setName("00");
    jmp = new FLine(0,0,128,128);
    jmp.setName("01");
    chunks[chunk].addBody(slo);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
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
  ArrayList<FContact> touchings = player.getContacts();
  for(FContact bod:touchings) {
    int flags;
    if(bod.getBody1()==player) {
      flags = unbinary(bod.getBody2().getName());
      println(bod.getBody2());
    } else {
      flags = unbinary(bod.getBody1().getName());
      println(bod.getBody1());
    }
    //if(flags%0x2/1>0) bittest template
    if(flags%0x2/1>0)keys[4] = false;
  }
  if(!(keys[1]&&keys[3])) {
    if(keys[1]) {
      player.setVelocity(-200,player.getVelocityY());
    }
    if(keys[3]) {
      player.setVelocity(200,player.getVelocityY());
    }
  }
  if(keys[0]&&!keys[4]) {
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
