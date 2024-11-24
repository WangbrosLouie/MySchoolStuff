/* Title: Iwannamaketophatturmoil *\
|* Author: Louie Wang             *|
|* Description: woo my unreleased *|
|* game that i havent started     *|
|* working on yet has moved from  *|
|* the sega genesis to processing *|
\*_Date:_Nov.1,_2024______________*/

import fisica.*;

class Gif extends PImage { //make custom loop points
  int frames = 0;//also custom frame orders
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
  
  Gif(int FRAMES, float INTERVAL, String[] filenames) {//gonna make the character files laters
    super(1,1,ARGB);
    frames = FRAMES;
    interval = INTERVAL;
    images = new PImage[frames];
    if(frames>1){
      for(int i=0;i<frames;i++)images[i] = loadImage(filenames[i]);
    } else images[0] = loadImage(filenames[0]);
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
  
  void updatePlayer() {//special for player gif
    if(images.length>1) {
      currentFrame+=interval;
    }
    int frm = floor(currentFrame)%frames;
    super.init(images[frm].width,images[frm].height,images[frm].format);
    images[frm].loadPixels();
    super.loadPixels();
    arrayCopy(camDir?images[frm].pixels:flipImagePix(images[frm]),super.pixels);
    images[frm].updatePixels();
    super.updatePixels();
  }
  
  void updatePlayer(float speed) {//special for player gif
    if(images.length>1) {
      currentFrame+=speed;
    }
    int frm = floor(currentFrame)%frames;
    super.init(images[frm].width,images[frm].height,images[frm].format);
    images[frm].loadPixels();
    super.loadPixels();
    arrayCopy(camDir?images[frm].pixels:flipImagePix(images[frm]),super.pixels);
    images[frm].updatePixels();
    super.updatePixels();
  }
  
  void reset() {//reset to frame 1
    if(images.length>1) {
      currentFrame=0;
    }
    int frm = floor(currentFrame)%frames;
    super.init(images[frm].width,images[frm].height,images[frm].format);
    images[frm].loadPixels();
    super.loadPixels();
    arrayCopy(camDir?images[frm].pixels:flipImagePix(images[frm]),super.pixels);
    images[frm].updatePixels();
    super.updatePixels();
  }
  
  void resizeGif(int x, int y) {
    for(PImage pic:images) {
      pic.resize(x,y);
    }
  }
}

class player extends FBox {
  int health = 5;
  Gif[] anim = new Gif[5];//idle moving jumping idlemoving hurting
  int animNum = 0;
  int invince = 0; //invincible until this frame
  int stunned = 0; //stunned until this frame
  player(int HEALTH) {//placeholder for now
    super(32,64);
    health = HEALTH;
    java.util.Arrays.fill(anim, new Gif(1,2.0/60,"spr/r0",".png"));
    anim[1] = new Gif(1,3.0/60,"spr/r0",".png");
    super.attachImage(anim[0]);
    super.setPosition(256*bi(map[map.length-30])+bi(map[map.length-29]),256*bi(map[map.length-28])+bi(map[map.length-27]));
    super.setRotatable(false);
    super.setFriction(100);
    super.setName("00");
  }
  
  byte[] process(byte[] keys) {
    animNum = 0;
    ArrayList<FContact> touchings = super.getContacts();
    keys[3] = 1;
    for(FContact bod:touchings) {
      int flags = 0;
      if(bod.getBody1()==this){
        String name = bod.getBody2().getName();
        flags = name!=null?unbinary(name):0;
      } else {
        String name = bod.getBody1().getName();
        flags = name!=null?unbinary(name):0;
      }
      //if(flags%0x2/1>0) bittest template
      if(flags%0x2/1>0)keys[3] = 0;
      if((flags%0x4/2>0)&&(invince<=frameCount)){animNum = 4;invince=frameCount+120;stunned=frameCount+30;}
      if(flags%0x8/4>0&&frameCount!=-1){frameCount=-1;mapNum+=1;}
    }
    if(debug)keys[3]=0;
    if(abs(super.getVelocityX())>100)animNum = 3;
    if(stunned<=frameCount) {
      if(!((keys[0]>1)&&(keys[1])>1)) {
        if(keys[0]>1) {
          //if(super.getVelocityX()>-200)super.addForce(-12000,0);
          super.setVelocity(-200,super.getVelocityY());
          animNum = 1;
          camDir = false;
        } else if(keys[1]>1) {
          //if(super.getVelocityX()<200)super.addForce(12000,0);
          super.setVelocity(200,super.getVelocityY());
          camDir = true;
          animNum = 1;
        } else {
          super.addImpulse(-super.getVelocityX()/5,0);
        }
      }
      if(keys[2]>1&&keys[3]==0) {
          keys[3] = 1;
          super.setVelocity(super.getVelocityX(),-200);
          animNum = 2;
      }
    }
    anim[animNum].updatePlayer();
    super.attachImage((invince>frameCount)&&(frameCount%4>1)?new PImage(0,0,RGB):anim[animNum]);
    for(int i=0;i<keys.length;i++)if(keys[i]==1)keys[i]=2;
    return keys;
  }
}

class Enemy extends FBox {//dont use please use the subclasses
  int health = 0;
  Enemy(int HEALTH, int high, int wide) {
    super(high,wide);
    health = HEALTH;
  }
}

class TestBot extends Enemy {
  int speed = 0;
  boolean dir = true;
  int timer = 0;
  byte state = 0;
  
  TestBot(int HEALTH, int TYPE) {
    super(HEALTH,32,32);
    switch(TYPE) {
    default://type 0 in here too
      speed = 50;
    }
  }
  
  void process() {
    timer++;
    if(random(0,500)>timer)state=(byte)(state++%2);
    switch(state) {
    case 0:
      super.setVelocity(dir?50:-50,super.getVelocityY());
      break;
    case 1:
      if(timer==0)new Missile(10,40).addToWorld(world);
    default:
      println("GUHHHHHHH???????????");
    }
  }
}

class Missile extends FBox {
  int mass = 0;
  PVector direction;
  
  Missile(int high, int wide) {
    super(high,wide);
  }
}

class Button {
  int Type = 0; //positive type is text, negative type is image
  int X = 0;
  int Y = 0;
  int XSize = 0;
  int YSize = 0;
  float tSize = 0;
  color Out = color(0,0,0);// idle outline
  color In = color(0,0,0);// idle fill
  int doWhat = 0;
  String text = "";
  PImage img = new PImage();
  color TOut = color(0,0,0);// text/tint unpressed
  color TIn = color(0,0,0);// text/tint depressed
  color POut = color(0,0,0);// pressed outline
  color PIn = color(0,0,0);// pressed fill
  color THov = color(0,0,0);// text/tint hover
  color HOut = color(0,0,0);// hover outline
  color HIn = color(0,0,0);// hover fill
  //text button constructor
  Button(int tYPE, int DOwHAT, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, color hoUT, color hiN, color poUT, color piN, color toUT, color thOV, color tiN, String TEXT, float TsIZE) {
    if(tYPE<0||x<0||y<0||xsIZE<0||ysIZE<0||DOwHAT<0) {
      Type = 1;
    } else {
      Type = abs(tYPE);
      X = x;
      Y = y;
      XSize = xsIZE;
      YSize = ysIZE;
      Out = oUT;
      In = iN;
      doWhat = DOwHAT;
      text = TEXT;
      TOut = toUT;
      THov = thOV;
      TIn = tiN;
      POut = poUT;
      PIn = piN;
      HIn = hiN;
      HOut = hoUT;
      tSize = TsIZE;
    }
  }
  //image button constructor
  Button(int tYPE, int DOwHAT, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, color hoUT, color hiN, color poUT, color piN, color toUT, color thOV, color tiN, PImage IMG) {
    if(tYPE<0||x<0||y<0||xsIZE<0||ysIZE<0||DOwHAT<0) {
      Type = -1;
    } else {
      Type = -abs(tYPE);
      X = x;
      Y = y;
      XSize = xsIZE;
      YSize = ysIZE;
      Out = oUT;
      In = iN;
      doWhat = DOwHAT;
      img = IMG;
      TOut = toUT;
      THov = thOV;
      TIn = tiN;
      POut = poUT;
      PIn = piN;
      HIn = hiN;
      HOut = hoUT;
    }
  }
  
  void draw(byte Active) {//2 is pressed, 1 is hover, 0 is idle
    if(Type==0||Type==-0) {
      println("Warning: Uninitialized button.");
    } else {
      if(Type>0) {
        push();
        textAlign(CENTER,CENTER);
        //println(tSize);
        textSize(tSize);
        switch(Active) {
        case 0:
          fill(TOut);
          push();
          stroke(Out);
          fill(In);
          break;
        case 1:
          fill(THov);
          push();
          stroke(HOut);
          fill(HIn);
          break;
        case 2:
          fill(TIn);
          push();
          stroke(POut);
          fill(PIn);
          break;
        default:
          println("Naked grandma!");
        }
        switch(Type) {
        case 1:
          rect(X,Y,XSize,YSize);
          pop();
          text(text,XSize/2+X,YSize/2+Y);
          break;
        case 2:
          ellipse(X,Y,XSize,YSize);
          pop();
          text(text,XSize/2+X,YSize/2+Y);
        }
        pop();
      } else {
        push();
        switch(Active) {
        case 0:
          tint(TOut);
          stroke(Out);//ya need to keep these parts in case of transparent images
          fill(In);
          break;
        case 1:
          tint(THov);
          stroke(HOut);
          fill(HIn);
          break;
        case 2:
          tint(TIn);
          stroke(POut);
          fill(PIn);
          break;
        default:
          println("Naked huh?");
        }
        switch(-Type) {
        case 1:
          rect(X,Y,XSize,YSize);
          image(img,X,Y,XSize,YSize);
          break;
        case 2:
          ellipse(X,Y,XSize,YSize);
          text(text,XSize/2+X,YSize/2+Y);
        }
        pop();
      }
    }
  }
  
  void drawHit(int i, PGraphics H) {
    i++;
    H.fill(color(i%0x1000000/0x10000,i%0x10000/0x100,i%0x100));
    switch(abs(Type)) {
    case 1:
      H.rect(X,Y,XSize,YSize);
      break;
    case 2:
      H.ellipse(X,Y,XSize,YSize);
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
byte mapNum = 0;
Gif[] tex = new Gif[255];
byte[] keys = new byte[13];
boolean textures = true;
boolean backgnd = true;
boolean halfFPS = true;
PFont lucid;
PVector playerVec, camVec;
float scl = 1;
boolean camDir = true;
FWorld world;
player you;
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
      playerVec = new PVector(you.getX(),you.getY());
      camVec = new PVector(playerVec.x+sqrt2(you.getVelocityX()*30)+(camDir?50:-50),playerVec.y+sqrt2(you.getVelocityY()*30));
    }
    keys = you.process(keys); //<>//
    for(Gif pic:tex)pic.update();
    world.step();
    playerVec.set(you.getX(),you.getY());
    camVec.lerp(PVector.add(playerVec,new PVector(sqrt2(you.getVelocityX()*30)+(camDir?50:-50),sqrt2(you.getVelocityY()*30))),0.05);
    scl = lerp(scl,constrain(1.0-dist(0,0,you.getVelocityX()/2500.0,you.getVelocityY()/2500.0),0.5,1),0.1);
    if(!(frameCount%2>0&&halfFPS)) {
      background(0xFF00FF);
      scale(scl);
      translate((int)(width/2-camVec.x-((width-(width/scl))/2)),(int)(height/2-camVec.y-((height-(height/scl))/2)));
      world.draw();
    }
  } catch (Exception e) {
    blueDead(e);
    noLoop();
  }
}

void makeLevel() {
  if(!(new String(subset(map,map.length-16,16)).equals("Tophat Turmoil 1")||new String(subset(map,map.length-16,16)).equals("Tophat Turmoil 2")))throw new RuntimeException("Ayo the map invalid");
  int lWidth = bi(map[map.length-32])+1;
  int lHeight = bi(map[map.length-31])+1;
  tex = new Gif[255];
  java.util.Arrays.fill(tex,new Gif());
  if(map[map.length-1]=='2')loadTextures();
  chunks = new FCompound[lWidth*lHeight];
  world = new FWorld(-128,-128,lWidth*128+128,lHeight*128+128);
  for(int j=0;j<lHeight;j++){
    for(int i=0;i<lWidth;i++) {
      makeChunk(i,j);
    }
  }
  //player = new FBox(32,64);
  //player.setPosition(256*bi(map[map.length-30])+bi(map[map.length-29]),256*bi(map[map.length-28])+bi(map[map.length-27]));
  //player.setRotatable(false);
  //player.setFriction(100);
  //player.setName("00");
  //player.attachImage(loadImage("spr/r0.png"));
  you = new player(3);
  world.add(you);
}

void makeChunk(int i,int j) {
  int lWidth = bi(map[map.length-32])+1;
  int chunk = j*lWidth+i;
  byte ID = map[map[map.length-1]=='1'?chunk:chunk*2];
  int texture = map[map.length-1]=='1'||!textures?-1:map[chunk*2+1]-1;
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
  case 0x10:
    gnd = new FBox(128,128);
    gnd.setPosition(64,64);
    gnd.setName("10");
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
  }
}

void loadTextures() {
  String[] texList = split(new String(subset(map,0,map.length-33-map[map.length-26])),(char)0);
  if(texList.length>=map[map.length-25]){
    texList = subset(texList,texList.length-map[map.length-25]);
    for(int i=0;i<map[map.length-25];i++) {
      int gifLen = texList[i].getBytes()[0]&0xFFFFFFFF; //<>//
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

int[] flipImagePix(PImage pic) {
  int[] flipped = new int[pic.width*pic.height];
  pic.loadPixels();
  for(int i=0;i<pic.height;i++) {
    for(int j=0;j<pic.width;j++) {
      flipped[i*pic.width+j] = pic.pixels[(i+1)*pic.width-j-1];
    }
  }
  pic.updatePixels();
  return flipped;
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

void keyPressed() {
  switch(keyCode){
  case 65:
    if(keys[0]==0)keys[0] = 1;
    break;
  case 68:
    if(keys[1]==0)keys[1] = 1;
    break;
  case 32:
    if(keys[2]==0)keys[2] = 1;
    break;
    //addin actions n stuff later
  }
}

void keyReleased() {
  switch(keyCode){
  case 65:
    keys[0] = 0;
    break;
  case 68:
    keys[1] = 0;
    break;
  case 32:
    keys[2] = 0;
    break;
  }
}
