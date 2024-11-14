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
boolean debug = false;
String[] maps = new String[]{"map02.lvl"};
byte[] map;
String mapName;
byte mapNum = 0;
color[] pal1 = new color[]{color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0),color(0)};
boolean[] keys = new boolean[13];
PFont lucid;
PVector playerVec, camVec;
boolean camDir = true;
FWorld world;
FBox player;
FCompound[] chunks;

void setup() {
  lucid = createFont("Lucida Console",14,false);
  Fisica.init(this);
  image(loadImage("spr/loudo.png"),0,0,width,height);
  //draw thy loading screen
}

void draw() {
  try {
    if(loading){
      loading = false;
      map = loadBytes(maps[mapNum]);
      mapName = tostring(char(subset(map,map.length-33-map[map.length-26],map[map.length-26]+1)));
      println(mapName);
      makeLevel();
      playerVec = new PVector(player.getX(),player.getY());
      camVec = new PVector(playerVec.x+sqrt2(player.getVelocityX()*30)+(camDir?50:-50),playerVec.y+sqrt2(player.getVelocityY()*30));
    }
    processKeys();
    world.step();
    background(200);
    playerVec.set(player.getX(),player.getY());
    camVec.lerp(PVector.add(playerVec,new PVector(sqrt2(player.getVelocityX()*30)+(camDir?50:-50),sqrt2(player.getVelocityY()*30))),00.1);
    translate(width/2-camVec.x,height/2-camVec.y);
    world.draw();
  } catch (Exception e) {
    blueDead(e);
    noLoop();
  }
}

void makeLevel() {
  int lWidth = bi(map[map.length-32])+1;
  int lHeight = bi(map[map.length-31])+1;
  println(lWidth,lHeight);
  chunks = new FCompound[lWidth*lHeight];
  world = new FWorld(-128,-128,lWidth*128+128,lHeight*128+128);
  for(int j=0;j<lHeight;j++){
    for(int i=0;i<lWidth;i++) {
      makeChunk(i,j);
    }
  }
  player = new FBox(32,64);
  player.setPosition(256*bi(map[map.length-30])+bi(map[map.length-29]),256*bi(map[map.length-28])+bi(map[map.length-27]));
  player.setRotatable(false);
  player.setFriction(100);
  player.setName("00");
  player.attachImage(loadImage("spr/r0.png"));
  world.add(player);
}

void makeChunk(int i,int j) {
  int lWidth = bi(map[map.length-32])+1;
  int chunk = j*lWidth+i;
  byte ID = map[chunk];
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
    gnd = new FBox(128,128);
    gnd.setPosition(64,64);
    gnd.setName("00");
    chunks[chunk].addBody(gnd);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 3:
    chunks[chunk] = new FCompound();
    FPoly slo = new FPoly();
    slo.vertex(1,128);
    slo.vertex(128,1);
    slo.vertex(128,128);
    slo.vertex(1,128);
    slo.setFriction(0.1);
    slo.setName("00");
    jmp = new FLine(0,128,127,1);
    jmp.setName("01");
    chunks[chunk].addBody(slo);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 4:
    chunks[chunk] = new FCompound();
    slo = new FPoly();
    slo.vertex(0,1);
    slo.vertex(127,128);
    slo.vertex(0,128);
    slo.vertex(0,1);
    slo.setFriction(0.1);
    slo.setName("00");
    jmp = new FLine(1,1,128,128);
    jmp.setName("01");
    chunks[chunk].addBody(slo);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 5:
    chunks[chunk] = new FCompound();
    gnd = new FBox(128,63);
    gnd.setPosition(65,97.5);
    gnd.setName("00");
    jmp = new FLine(1,65,129,65);
    jmp.setName("01");
    chunks[chunk].addBody(gnd);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i-1,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 6:
    chunks[chunk] = new FCompound();
    gnd = new FBox(128,64);
    gnd.setPosition(64,112);
    gnd.setName("00");
    chunks[chunk].addBody(gnd);
    chunks[chunk].setPosition(128*i,128*j-1);
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

float sqrt2(float num) {
  return num<0?-sqrt(0-num):sqrt(num);
}

//input events and controller support here
void blueDead(Exception e) { //funny
  noLoop();
  background(#000080);
  fill(255);
  textFont(lucid);
  textAlign(LEFT,TOP);
  text("A problem has been detected and this application has been halted to prevent\nfurther problems from occuring.\n\nThis application has thrown a(n)\n"+e.toString()+"\nand halted itself.\n\nIf this is the first time you've seen this STOP error screen,\nrestart the application. If this screen appears again, try these steps:\n\nCheck to make sure that you haven't modified the application in any way\nshape or form. It may be corrupted. Check that there are no warnings in the\nProcessing console if you are running this application from Processing.\n\nIf problems continue, contact the developer of the application and see if\nthey have an updated version of the application that has bug fixes that may\npertain to this issue. Alternatively, give the information below to the\ndeveloper to aid them in the fixing of this problem.\n\nTechnical information:\n\n*** STOP: "+e.getMessage()+"\n\n***    "+e.getStackTrace()[0].toString(), 0, 24);
  e.printStackTrace();
}

void processKeys() {
  ArrayList<FContact> touchings = player.getContacts();
  keys[3] = true;
  for(FContact bod:touchings) {
    int flags = 0;
    if(bod.getBody1()==player){
      String name = bod.getBody2().getName();
      flags = name!=null?unbinary(name):0;
      //println(bod.getBody2());
    } else {
      String name = bod.getBody1().getName();
      flags = name!=null?unbinary(name):0;
      //println(bod.getBody1());
    }
    //if(flags%0x2/1>0) bittest template
    if(flags%0x2/1>0)keys[3] = false;
  }
  if(!(keys[0]&&keys[1])) {
    if(keys[0]) {
      player.setVelocity(-200,player.getVelocityY());
      camDir = false;
    }
    if(keys[1]) {
      player.setVelocity(200,player.getVelocityY());
      camDir = true;
    } else {
      player.addForce(-player.getVelocityX()/5,0);
    }
  }
  if(keys[2]&&!keys[3]) {
      keys[3] = true;
      player.setVelocity(player.getVelocityX(),-200);
  }
}

void keyPressed() {
  switch(keyCode){
  case 65:
    keys[0] = true;
    break;
  case 68:
    keys[1] = true;
    break;
  case 32:
    keys[2] = true;
    break;
    //addin actions n stuff later
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
  case 32:
    keys[2] = false;
    break;
  }
}
