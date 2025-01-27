/* Title: Iwannamakethethirddimension  *\
|* Author: Louie Wang                  *|
|* Description: you know what they say *|
|* with new project comes longer title *|
\*_Date:_Jan.6,_2025___________________*/

import java.awt.*;
import processing.sound.*;

PVector camPos = new PVector();
PVector camOri = new PVector();
PVector camDir = new PVector();
boolean[] Keys = new boolean[256];
float Speed = 1.0;
float ySpeed;
float camHeight = 16;
PImage img;
PGraphics ThreeD;
PGraphics oriCube;
PMatrix3D mytricks;
Robot kitta;
int winX, winY, oX, oY;
int[] heightMap;
ArrayList<thing> things = new ArrayList<thing>();
final PApplet dis = this;

class thing {
  
  PVector pos;
  PVector vel;
  
  thing(PVector p, PVector v) {
    pos = p;
    vel = v;
  }
  
  void process(ArrayList<thing> stuff) {
    println("hey you dont got a process for this class ("+typeof(this)+") dingus");
  }
  
}

class metalpipe extends thing {
  
  PImage texture;
  SoundFile snd;
  
  metalpipe(PVector p, PVector v) {
    super(p,v);
    texture = loadImage("metalpipe.png");
    snd = new SoundFile(dis,"metalpipe.mp3");//from https://www.myinstants.com/en/instant/jixaw-metal-pipe-falling-sound-28270/
  }
  
  void process(ArrayList<thing> stuff) {
    for(float i=vel.mag();i>0;i--) {
      PVector newPos = PVector.add(pos,vel.copy().mult(3));
      try{
        if(-pos.y>=heightMap[floor(heightMap[1]/2+(newPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(newPos.x/16))+2]) {
          pos.add(vel.copy().mult(i<1?i:1));
        } else {
         stuff.remove(this);
         for(int j=0;j<10;j++) {
           stuff.add(new shrapnel(pos,new PVector(0,0,0)));
         }
         i = 0;
        }
      } catch (Exception e) {
        //destroy();
      }
    }
      
  }
  
}

class shrapnel extends thing {
  
  SoundFile snd;
  
  shrapnel(PVector p,PVector v) {
    super(p,v);
    snd = new SoundFile(dis,"ting.wav");
  }
  
  void process(ArrayList<thing> stuff) {
    vel.y++;
    for(float i=vel.mag();i>0;i--) {
      PVector newPos = PVector.add(pos,vel.copy().mult(3));
      try{
        if(-pos.y>=heightMap[floor(heightMap[1]/2+(newPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(newPos.x/16))+2]) {
          pos.add(vel.copy().mult(i<1?i:1));
        } else {
         stuff.remove(this);
         for(int j=0;j<10;j++) {
           stuff.add(new shrapnel(pos,new PVector(0,0,0)));
         }
         i = 0;
        }
      } catch (Exception e) {
        //destroy();
      }
    }
    cube(pos.x,pos.y,pos.z,5,5,25,img);
  }
}

void settings() {
  size(640,480,P3D);//its 3d blast baby
}

void setup() {
  mytricks = getMatrix(mytricks);//thanks google
  try{kitta = new Robot();} catch(Exception e){print("Robot broke");}
  kitta.mouseMove(ceil(winX+width/2),ceil(winY+height/2));
  winX = (displayWidth/2)-(width/2);
  winY = (displayHeight/2)-(height/2);
  windowMove(winX,winY);
  img = loadImage("testbot my beloved.png");
  oriCube = createGraphics(150,150,P3D);
  heightMap = loadLevel(loadImage("level.png"));
  noCursor();
}

void draw() {if(frameCount==2){oX = ceil(width/2)-mouseX;oY = ceil(height/2)-mouseY;camDir=new PVector();}//gotta find a workaround to this one fast
  print(frameCount);
  perspective(PI/2.0,(float)width/height,0.1,10000.0); //FOV=???
  process();
  camera(camPos.x,camPos.y,camPos.z,camOri.x,camOri.y,camOri.z,0,1,0);
  background(200);
  //cube(-10,10,-10,10);//good ol white cube
  cube(60,-10,0,20,20,20,img);//testbot my beloved
  //ball(30,30,30,10);//baller
  //grid(0,50,25);
  drawLevel(heightMap);
  
  this.setMatrix(mytricks);//grab that unmodified matrix
  perspective();//reset FOV
  PVector oriPos = PVector.sub(camOri,camPos).mult(150);//orientation cube stuff
  oriCube.beginDraw();
  oriCube.clear();
  oriCube.perspective(PI/2.0,1,5.0,1000.0);
  oriCube.fill(255);
  cube(0,0,0,100,oriCube);
  oriCube.textAlign(CENTER,CENTER);
  oriCube.fill(0);
  oriCube.textSize(32);
  oriCube.text("Front",0,0,50.1);
  oriCube.rotateY(radians(90));
  oriCube.text("Right",0,0,50.1);
  oriCube.rotateY(radians(90));
  oriCube.text("Back",0,0,50.1);
  oriCube.rotateY(radians(90));
  oriCube.text("Left",0,0,50.1);
  oriCube.rotateY(radians(90));
  oriCube.rotateX(radians(90));
  oriCube.text("Top",0,0,50.1);
  oriCube.rotateX(radians(-180));
  oriCube.text("Bottom",0,0,50.1);
  oriCube.camera(-oriPos.x,-oriPos.y,-oriPos.z,0,0,0,0,1,0);
  oriCube.endDraw();
  push();
  imageMode(CORNER);
  textAlign(CENTER,CENTER);
  fill(127);
  /*old fashioned ahh*/text("If the camera is moving automatically, restart program and make sure mouse does not move while booting program.\nTo close program:\nPush the Esc key or,\nUnfocus program and close with taskbar, task manager, stop button (if applicable), etc. or,\nuse OS dependent keyboard combination if present.\nCONTROLS:\nPositional Movement on the: Z Axis = -W,+S. X Axis = -A,+D. Y Axis = -Space\nCamera Movement on the: X Axis = JL. Y Axis = IK.\nShift to go slower. Use mouse if present for camera.",width/2,height-100);
  image(oriCube,width-75,0,75,75);
  pop();
}

int[] loadLevel(PImage img) {
  int[] map = new int[img.width*img.height+2];
  map[0] = img.width;
  map[1] = img.height;
  img.loadPixels();
  for(int i=0;i<img.height;i++) {
    for(int j=0;j<img.width;j++) {
      switch(img.pixels[i*img.width+j]) {
      case -1237980:
        map[i*img.width+j+2] = 9001;
        break;
      case -32985:
        map[i*img.width+j+2] = 112;
        break;
      case -14066:
        map[i*img.width+j+2] = 96;
        break;
      case -3584:
        map[i*img.width+j+2] = 80;
        break;
      case -4856291:
        map[i*img.width+j+2] = 64;
        break;
      case -14503604:
        map[i*img.width+j+2] = 48;
        break;
      case -16735512:
        map[i*img.width+j+2] = 32;
        break;
      case -12629812:
        map[i*img.width+j+2] = 16;
        break;
      case -6075996:
        map[i*img.width+j+2] = 0;
        break;
      default:
        println("meow");
      }
    }
  }
  return map;
}

void drawLevel(int[] map) {
  for(int i=0;i<map[1];i++) {
    for(int j=0;j<map[0];j++) {
      switch(map[i*map[1]+j+2]) {
      case -1:
        cube(j*16+8-(map[1]*8),-4500.5,i*16+8-(map[0]*8),16,9001,16);
        break;
      default:
        cube(j*16+8-(map[1]*8),-map[i*map[0]+j+2]/2,i*16+8-(map[0]*8),16,map[i*map[0]+j+2],16);
      }
    }
  }
}

void process() {
  /* Calculates player movement for now.*/
  float s = Speed;
  if(Keys[kSHIFT]) { //SPEED SHIFT
    s*=1.5;
  }
  if(Keys[kCTRL]) {
    s/=2;
  }
  if(Keys[kJ]) { //CAM LEFT
    camDir.x -= 2*s;
  }
  if(Keys[kL]) { //CAM RIGHT
    camDir.x += 2*s;
  }
  if(Keys[kI]) { //CAM UP
    camDir.y -= 2*s;
  }
  if(Keys[kK]) { //CAM DOWN
    camDir.y += 2*s;
  }
  if(focused){ //MOUSE MOVEMENT
    kitta.mouseMove(ceil(oX+winX+width/2),ceil(oY+winY+height/2));
    camDir.x += (mouseX-ceil(width/2));
    camDir.y += (mouseY-ceil(height/2));
  }
  camDir.y = constrain(camDir.y,-89.9,89.9); //Restrict Camera's Y Direction
  PVector Pos = new PVector(); //ORIENTATION VECTOR
  Pos = XZY(PVector.fromAngle(radians(camDir.x)).normalize());
  if(Keys[kSPACE]) {//JUMP
    try {
      if(-heightMap[floor(heightMap[1]/2+(camPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(camPos.x/16))+2]<=camPos.y+camHeight) {
        ySpeed = -3;
      }
    } catch (Exception e) {
    }
  }
  ySpeed+=0.1;
  camPos.y += ySpeed;
  try {
    if(-heightMap[floor(heightMap[1]/2+(camPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(camPos.x/16))+2]<=camPos.y+camHeight) {
      ySpeed = 0;
      camPos.y = -heightMap[floor(heightMap[1]/2+(camPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(camPos.x/16))+2]-camHeight;
    }
  } catch (Exception e) {
    camPos.y = -camHeight;
  }
  if(Keys[kW]) { //MOVE FORWARD
    for(float i=s;i>0;i--) {
      PVector newPos = PVector.add(camPos,Pos.copy().mult(3));
      try{
        if(mousePressed|-camPos.y>=heightMap[floor(heightMap[1]/2+(newPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(newPos.x/16))+2]) {
          camPos.add(XZY(PVector.fromAngle(radians(camDir.x))).mult(i<1?i:1));
        } else i = 0;
      } catch (Exception e) {
        camPos.add(XZY(PVector.fromAngle(radians(camDir.x))).mult(i<1?i:1));
      }
    }
  }
  if(Keys[kS]) { //MOVE BACK
    for(float i=s;i>0;i--) {
      PVector newPos = PVector.sub(camPos,Pos.copy().mult(3));
      try {
        if(mousePressed|-camPos.y>=heightMap[floor(heightMap[1]/2+(newPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(newPos.x/16))+2]) {
          camPos.sub(XZY(PVector.fromAngle(radians(camDir.x))).mult(i<1?i:1));
        } else i = 0;
      } catch (Exception e) {
        camPos.sub(XZY(PVector.fromAngle(radians(camDir.x))).mult(i<1?i:1));
      }
    }
  }
  if(Keys[kA]) { //MOVE LEFT
    for(float i=s;i>0;i--) {
      PVector newPos = PVector.sub(camPos,nZYX(Pos).mult(3));
      try {
        if(mousePressed|-camPos.y>=heightMap[floor(heightMap[1]/2+(newPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(newPos.x/16))+2]) {
          camPos.add(XZY(PVector.fromAngle(radians(camDir.x-90))).mult(i<1?i:1));
        } else i = 0;
      } catch (Exception e) {
        camPos.add(XZY(PVector.fromAngle(radians(camDir.x-90))).mult(i<1?i:1));
      }
    }
  }
  if(Keys[kD]) { //MOVE RIGHT
    for(float i=s;i>0;i--) {
      PVector newPos = PVector.add(camPos,nZYX(Pos).mult(3));
      try {
        if(mousePressed|-camPos.y>=heightMap[floor(heightMap[1]/2+(newPos.z/16))*heightMap[0]+floor(heightMap[0]/2+(newPos.x/16))+2]) {
          camPos.add(XZY(PVector.fromAngle(radians(camDir.x+90))).mult(i<1?i:1));
        } else i = 0;
      } catch (Exception e) {
        camPos.add(XZY(PVector.fromAngle(radians(camDir.x-90))).mult(i<1?i:1));
      }
    }
  }
  if(Keys[kE]) {//metal pipe
    things.add(new metalpipe(camPos,camDir.copy().mult(3)));
  }
  for(int i=things.size()-1;i>-1;i--) {
    things.get(i).process(things);
  }
  PVector Y = PVector.fromAngle(radians(camDir.y)).normalize();
  Pos.setMag(Y.x);
  Pos.y = Y.y;
  camOri = PVector.add(camPos,Pos); //CAMERA ORIENTATION
  //this took me so meowin long ToT
}

void cube(float x, float y, float z, float size) {
  push();
  translate(x,y,z);
  box(size);
  pop();
}

void cube(float x, float y, float z, float w, float h, float d) {
  push();
  translate(x,y,z);
  box(w,h,d);
  pop();
}

void cube(float x, float y, float z, float size, PGraphics screen) {
  screen.push();
  screen.translate(x,y,z);
  screen.box(size);
  screen.pop();
}

void cube(float x, float y, float z, float w, float h, float d, PGraphics screen) {
  screen.push();
  screen.translate(x,y,z);
  screen.box(w,h,d);
  screen.pop();
}

void ball(float x, float y, float z, float size) {
  push();
  translate(x,y,z);
  sphere(size);
  pop();
}

void cube(float x, float y, float z, float w, float h, float d, PImage tex) {
  float hw = w/2;
  float hh = h/2;
  float hd = d/2;
  push();
  translate(x,y,z);
  textureMode(NORMAL);
  beginShape();
  texture(tex);
  vertex(-hw,-hh,hd,0,0);
  vertex(hw,-hh,hd,1,0);
  vertex(hw,hh,hd,1,1);
  vertex(-hw,hh,hd,0,1);
  endShape(CLOSE);
  beginShape();
  texture(tex);
  vertex(hw,-hh,hd,0,0);
  vertex(hw,-hh,-hd,1,0);
  vertex(hw,hh,-hd,1,1);
  vertex(hw,hh,hd,0,1);
  endShape(CLOSE);
  beginShape();
  texture(tex);
  vertex(hw,-hh,-hd,0,0);
  vertex(-hw,-hh,-hd,1,0);
  vertex(-hw,hh,-hd,1,1);
  vertex(hw,hh,-hd,0,1);
  endShape(CLOSE);
  beginShape();
  texture(tex);
  vertex(-hw,-hh,-hd,0,0);
  vertex(-hw,-hh,hd,1,0);
  vertex(-hw,hh,hd,1,1);
  vertex(-hw,hh,-hd,0,1);
  endShape(CLOSE);
  beginShape();
  texture(tex);
  vertex(-hw,-hh,-hd,0,0);
  vertex(hw,-hh,-hd,1,0);
  vertex(hw,-hh,hd,1,1);
  vertex(-hw,-hh,hd,0,1);
  endShape(CLOSE);
  beginShape();
  texture(tex);
  vertex(hw,hh,hd,0,0);
  vertex(-hw,hh,hd,1,0);
  vertex(-hw,hh,-hd,1,1);
  vertex(hw,hh,-hd,0,1);
  endShape(CLOSE);
  pop();
}

void cube(float x, float y, float z, float size, PImage tex) {
  float h = size/2;
  push();
  translate(x,y,z);
  textureMode(NORMAL);
  beginShape();
  texture(tex);
  vertex(-h,-h,h,0,0);
  vertex(h,-h,h,1,0);
  vertex(h,h,h,1,1);
  vertex(-h,h,h,0,1);
  endShape(CLOSE);
  beginShape();
  texture(tex);
  vertex(h,-h,h,0,0);
  vertex(h,-h,-h,1,0);
  vertex(h,h,-h,1,1);
  vertex(h,h,h,0,1);
  endShape(CLOSE);
  beginShape();
  texture(tex);
  vertex(h,-h,-h,0,0);
  vertex(-h,-h,-h,1,0);
  vertex(-h,h,-h,1,1);
  vertex(h,h,-h,0,1);
  endShape(CLOSE);
  beginShape();
  texture(tex);
  vertex(-h,-h,-h,0,0);
  vertex(-h,-h,h,1,0);
  vertex(-h,h,h,1,1);
  vertex(-h,h,-h,0,1);
  endShape(CLOSE);
  pop();
}

void grid(float y, float d, float s) {//y coord, draw distance, size of grid block
  for(int i=floor(camPos.x/s)-floor(d/s/2)+1;i<ceil(camPos.x/s)+floor(d/s/2);i++) {
    line(i*s,y,(-d/2)+camPos.z,i*s,y,(d/2)+camPos.z);
  }
  for(int i=floor(camPos.z/s)-floor(d/s/2)+1;i<ceil(camPos.z/s)+floor(d/s/2);i++) {
    line((-d/2)+camPos.x,y,i*s,(d/2)+camPos.x,y,i*s);
  }
}

String typeof(Object o) {// good ol roblox ahh function
  return o.getClass().getSimpleName();
}

PVector XnYZ(PVector v) {
  return new PVector(v.x,-v.y,v.z);
}

PVector XZY(PVector v) {
  return new PVector(v.x,v.z,v.y);
}

PVector YXZ(PVector v) {
  return new PVector(v.y,v.x,v.z);
}

PVector YZX(PVector v) {
  return new PVector(v.y,v.z,v.x);
}

PVector ZXY(PVector v) {
  return new PVector(v.z,v.x,v.y);
}

PVector ZYX(PVector v) {
  return new PVector(v.z,v.y,v.x);
}

PVector nZYX(PVector v) {
  return new PVector(-v.z,v.y,v.x);
}

void keyPressed() {
  try {
    Keys[keyCode] = true;
  } catch(Exception e) {
    
  }
}

void keyReleased() {
  try {
    Keys[keyCode] = false;
  } catch(Exception e) {
    
  }
}

final int kBSP = 8;
final int kTAB = 9;
final int kENTER = 10;
final int kSHIFT = 16;
final int kCTRL = 17;
final int kALT = 18;
final int kCLOCK = 20; //caps lock
final int kSPACE = 32;
final int kA = 65;
final int kB = 66;
final int kC = 67;
final int kD = 68;
final int kE = 69;
final int kF = 70;
final int kG = 71;
final int kH = 72;
final int kI = 73;
final int kJ = 74;
final int kK = 75;
final int kL = 76;
final int kM = 77;
final int kN = 78;
final int kO = 79;
final int kP = 80;
final int kQ = 81;
final int kR = 82;
final int kS = 83;
final int kT = 84;
final int kU = 85;
final int kV = 86;
final int kW = 87;
final int kX = 88;
final int kY = 89;
final int kZ = 90;
