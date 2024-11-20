/* Title: Iwannamaketophatturmoil *\
|* Author: Louie Wang             *|
|* Description: woo my unreleased *|
|* game that i havent started     *|
|* working on yet has moved from  *|
|* the sega genesis to processing *|
\*_Date:_Nov.1,_2024______________*/

import fisica.*;

class Gif extends PImage {
  int frames = 0;
  float currentFrame = 0;
  float interval = 0;
  PImage[] images;
  Gif(int FRAMES, float INTERVAL, String filename, String suffix) {
    super(1,1,ARGB);
    frames = FRAMES;
    interval = INTERVAL;
    images = new PImage[frames];
    if(frames>1){
      for(int i=0;i<frames;i++)images[i] = loadImage(filename+i+suffix);
    } else images[0] = loadImage(filename+suffix);
    super.init(images[0].width,images[0].height,images[0].format);
    images[0].loadPixels();
    super.loadPixels();
    arrayCopy(images[0].pixels,super.pixels);
    images[0].updatePixels();
    super.updatePixels();
  }
  
  Gif() {
    super(1,1,ARGB);
    frames = 1;
    interval = 1;
    images = new PImage[]{new PImage(1,1,ARGB)};
  }
  
  //void update() {
  //  if(images.length>1) {
  //    currentFrame++;
  //    int frm = floor(currentFrame/interval)%frames;
  //    super.init(images[frm].width,images[frm].height,ARGB);
  //    images[frm].loadPixels();
  //    int[] temp = new int[images[frm].pixels.length];
  //    arrayCopy(images[frm].pixels,temp);
  //    images[frm].updatePixels();
  //    super.loadPixels();
  //    arrayCopy(temp,super.pixels);
  //    super.updatePixels();
  //  }
  //}
  
  void update() {
    if(images.length>1) {
      currentFrame+=interval;
      int frm = floor(currentFrame)%frames;
      super.init(images[frm].width,images[frm].height,images[frm].format);
      images[frm].loadPixels();
      super.loadPixels();
      arrayCopy(images[frm].pixels,super.pixels);
      images[frm].updatePixels();
      super.updatePixels();
    }
  }
  
  void resizeGif(int x, int y) {
    for(PImage pic:images) {
      pic.resize(x,y);
    }
  }
}

void settings() {
  size(640,480);
}

boolean loading = true;
boolean debug = false;
String[] maps = new String[]{"map01.lvl","map02.lvl","map03.lvl","map03tex.lvl","map04.lvl"};
byte[] map;
String mapName;
byte mapNum = 3;
Gif[] tex = new Gif[255];
boolean[] keys = new boolean[13];
PFont lucid;
PVector playerVec, camVec;
boolean camDir = true;
FWorld world;
FBox player;
FCompound[] chunks;
Gif bg;

void setup() {
  loading = true;
  lucid = createFont("Lucida Console",14,false);
  Fisica.init(this);
  image(loadImage("spr/loudo.png"),0,0,width,height);
  //draw thy loading screen
}

void draw() {
  try {
    if(loading){
      loading = false;
      println(mapNum,maps.length);
      map = loadBytes(maps[mapNum%maps.length]);
      mapName = tostring(char(subset(map,map.length-33-map[map.length-26],map[map.length-26]+1)));
      println(mapName);
      makeLevel();
      playerVec = new PVector(player.getX(),player.getY());
      camVec = new PVector(playerVec.x+sqrt2(player.getVelocityX()*30)+(camDir?50:-50),playerVec.y+sqrt2(player.getVelocityY()*30));
    }
    processKeys(); //<>//
    for(Gif pic:tex)pic.update();
    world.step();
    background(0xFF00FF);
    playerVec.set(player.getX(),player.getY());
    camVec.lerp(PVector.add(playerVec,new PVector(sqrt2(player.getVelocityX()*30)+(camDir?50:-50),sqrt2(player.getVelocityY()*30))),0.1);
    translate(width/2-camVec.x,height/2-camVec.y);
    world.draw();
  } catch (Exception e) {
    blueDead(e);
    noLoop();
  }
}

void makeLevel() {
  if(!(new String(subset(map,map.length-16,16)).equals("Tophat Turmoil 1")||new String(subset(map,map.length-16,16)).equals("Tophat Turmoil 2")))throw new RuntimeException("Ayo the map invalid");
  int lWidth = bi(map[map.length-32])+1;
  int lHeight = bi(map[map.length-31])+1;
  if(map[map.length-1]=='2')loadTextures();
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
  //java.util.Arrays.fill(tex,new PImage(1,1));
  //for(int i=0;i<map[map.length-19];i++){}
}

void makeChunk(int i,int j) {
  int lWidth = bi(map[map.length-32])+1;
  int chunk = j*lWidth+i;
  byte ID = map[map[map.length-1]=='1'?chunk:chunk*2];
  int texture = map[map.length-1]=='1'?-1:map[chunk*2+1]-1;
  chunks[chunk] = new FCompound();
  switch(ID){
  case 0:
    FBox img;
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
    }
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 1:
    FBox gnd = new FBox(128,127);
    gnd.setPosition(65,65.5);
    gnd.setName("00");
    FLine jmp = new FLine(1,1,129,1);
    jmp.setName("01");
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(65,65);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i-1,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 2:
    gnd = new FBox(128,128);
    gnd.setPosition(64,64);
    gnd.setName("00");
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 3:
    FPoly slo = new FPoly();
    slo.vertex(1,128);
    slo.vertex(128,1);
    slo.vertex(128,128);
    slo.vertex(1,128);
    slo.setName("00");
    jmp = new FLine(0,128,127,1);
    jmp.setName("01");
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      slo.setNoFill();
      slo.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(slo);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 4:
    slo = new FPoly();
    slo.vertex(0,1);
    slo.vertex(127,128);
    slo.vertex(0,128);
    slo.vertex(0,1);
    slo.setName("00");
    jmp = new FLine(1,1,128,128);
    jmp.setName("01");
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      slo.setNoFill();
      slo.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(slo);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 5:
    gnd = new FBox(128,63);
    gnd.setPosition(65,97.5);
    gnd.setName("00");
    jmp = new FLine(1,65,129,65);
    jmp.setName("01");
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(65,65);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i-1,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 6:
    gnd = new FBox(128,64);
    gnd.setPosition(64,112);
    gnd.setName("00");
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].setPosition(128*i,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 7:
    gnd = new FBox(128,127);
    gnd.setPosition(65,65.5);
    gnd.setName("00");
    gnd.setFillColor(0xFFAFAFFF);
    gnd.setFriction(0);
    jmp = new FLine(1,1,129,1);
    jmp.setName("01");
    jmp.setFriction(0);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(65,65);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i-1,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 8:
    gnd = new FBox(128,128);
    gnd.setPosition(64,64);
    gnd.setName("00");
    gnd.setFillColor(0xFFAFAFFF);
    gnd.setFriction(0);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 9:
    slo = new FPoly();
    slo.vertex(1,128);
    slo.vertex(128,1);
    slo.vertex(128,128);
    slo.vertex(1,128);
    slo.setFriction(0);
    slo.setName("00");
    slo.setFillColor(0xFFAFAFFF);
    slo.setFriction(0);
    jmp = new FLine(0,128,127,1);
    jmp.setName("01");
    jmp.setFriction(0);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      slo.setNoFill();
      slo.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(slo);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 0xA:
    slo = new FPoly();
    slo.vertex(0,1);
    slo.vertex(127,128);
    slo.vertex(0,128);
    slo.vertex(0,1);
    slo.setFriction(0);
    slo.setName("00");
    slo.setFillColor(0xFFAFAFFF);
    slo.setFriction(0);
    jmp = new FLine(1,1,128,128);
    jmp.setName("01");
    jmp.setFriction(0);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      slo.setNoFill();
      slo.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(slo);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 0xB:
    gnd = new FBox(128,63);
    gnd.setPosition(65,97.5);
    gnd.setName("00");
    gnd.setFillColor(0xFFAFAFFF);
    gnd.setFriction(0);
    jmp = new FLine(1,65,129,65);
    jmp.setName("01");
    jmp.setFriction(0);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(65,65);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i-1,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 0xC:
    gnd = new FBox(128,64);
    gnd.setPosition(64,112);
    gnd.setName("00");
    gnd.setFillColor(0xFFAFAFFF);
    gnd.setFriction(0);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 0xD:
    gnd = new FBox(128,127);
    gnd.setPosition(65,65.5);
    gnd.setName("00");
    gnd.setFillColor(0xFF000000);
    gnd.setRestitution(3);
    jmp = new FLine(1,1,129,1);
    jmp.setName("01");
    jmp.setRestitution(3);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(65,65);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i-1,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 0xE:
    gnd = new FBox(128,127);
    gnd.setPosition(65,65.5);
    gnd.setName("00");
    gnd.setFillColor(0xFF3F009F);
    gnd.setRestitution(50);
    jmp = new FLine(1,1,129,1);
    jmp.setName("01");
    jmp.setRestitution(50);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(65,65);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
      jmp.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].addBody(jmp);
    chunks[chunk].setPosition(128*i-1,128*j-1);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  case 0xF:
    chunks[chunk] = new FCompound();
    gnd = new FBox(128,128);
    gnd.setPosition(64,64);
    gnd.setName("100");
    gnd.setSensor(true);
    gnd.setFillColor(0x7F3FFF3F);
    if(map[map.length-1]=='2'&&texture!=-1){
      img = new FBox(128,128);
      img.attachImage(tex[texture]);
      img.setSensor(true);
      img.setStatic(true);
      img.setName("0");
      img.setPosition(64,64);
      chunks[chunk].addBody(img);
      gnd.setNoFill();
      gnd.setNoStroke();
    }
    chunks[chunk].addBody(gnd);
    chunks[chunk].setPosition(128*i,128*j);
    chunks[chunk].setStatic(true);
    world.add(chunks[chunk]);
    break;
  }
}

void loadTextures() {
  //String[] texList = split(reverse(new String(subset(map,(map[map.length-32]+1)*(map[map.length-31]+1)*2,map.length-33-map[map.length-26]-((map[map.length-32]+1)*(map[map.length-31]+1)*2)))),(char)0);
  String[] texList = split(new String(subset(map,0,map.length-33-map[map.length-26])),(char)0);
  tex = new Gif[255];
  java.util.Arrays.fill(tex,new Gif());
  if(texList.length>=map[map.length-25]){
    texList = subset(texList,texList.length-map[map.length-25]);
    for(int i=0;i<map[map.length-25];i++) {
      int gifLen = texList[i].getBytes()[0]&0xFF; //<>//
      if(gifLen>0) {
        String[] fileName = split(new String(subset(texList[i].getBytes(),2,texList[i].length()-2)),'.');
        tex[i] = new Gif(gifLen,mf(texList[i].getBytes()[1]),join(subset(fileName,0,fileName.length-1),"."),"."+fileName[fileName.length-1]);
        tex[i].resizeGif(128,128);
      } else {
        tex[i] = new Gif();
      }
    }
  }
}

String tostring(char[] chars) { //oh lua how i wish i were programming in thy scrypt
  String retVal = "";
  for(char c:chars) {
    retVal += str(c);
  }
  return retVal;
}

String reverse(String str) {
  return new String(reverse(str.getBytes()));
}

int bi(byte b) {//byte to int
  return unbinary(binary(b));
}//alas, unsigned byte problem, i hath defeated thee!

float sqrt2(float num) {
  return num<0?-sqrt(0-num):sqrt(num);
}

float mf(byte b) {//myfloat (so many calculations...)
  int flags = b&0xFF;
  return (flags/0x80>0?4:0)+(flags%0x80/0x40>0?2:0)+(flags%0x40/0x20>0?1:0)+(flags%0x20/0x10>0?0.5:0)+(flags%0x10/0x8>0?0.25:0)+(flags%0x8/0x4>0?0.125:0)+(flags%0x4/0x2>0?0.0625:0)+(flags%0x2>0?0.03125:0);
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
    if(flags%0x8/4>0&&frameCount!=-1){frameCount=-1;mapNum+=1;}
  }
  if(debug)keys[3]=false;
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
