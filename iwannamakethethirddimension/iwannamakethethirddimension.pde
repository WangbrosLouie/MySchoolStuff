/* Title: Iwannamakethethirddimension  *\
|* Author: Louie Wang                  *|
|* Description: you know what they say *|
|* with new project comes longer title *|
\*_Date:_Jan.6,_2025___________________*/

import java.awt.*;

PVector camPos = new PVector();
PVector camOri = new PVector();
PVector camDir = new PVector();
boolean[] Keys = new boolean[256];
float Speed = 1.0;
PImage img, level;
PGraphics ThreeD;
PGraphics oriCube;
PMatrix3D mytricks;
Robot kitta;
int winX, winY, oX, oY;

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
  level = loadImage("level.png");
  noCursor();
}

void draw() {if(frameCount==2){oX = ceil(width/2)-mouseX;oY = ceil(height/2)-mouseY;camDir=new PVector();}//gotta find a workaround to this one fast
  perspective(PI/2.0,(float)width/height,5.0,10000.0); //FOV=???
  process();
  camera(camPos.x,camPos.y,camPos.z,camOri.x,camOri.y,camOri.z,0,1,0);
  background(200);
  //cube(-10,10,-10,10);//good ol white cube
  //cube(20,20,-20,10,15,20,img);//testbot my beloved
  //ball(30,30,30,10);//baller
  //grid(0,50,25);
  level.loadPixels();
  for(int i=0;i<level.height;i++) {
    for(int j=0;j<level.width;j++) {
      switch(level.pixels[i*level.width+j]) {
      case -1237980:
        cube(j*16+8-(level.height*8),-64,i*16+8-(level.width*8),16,128,16);
        break;
      case -32985:
        cube(j*16+8-(level.height*8),-56,i*16+8-(level.width*8),16,112,16);
        break;
      case -14066:
        cube(j*16+8-(level.height*8),-48,i*16+8-(level.width*8),16,96,16);
        break;
      case -3584:
        cube(j*16+8-(level.height*8),-40,i*16+8-(level.width*8),16,80,16);
        break;
      case -4856291:
        cube(j*16+8-(level.height*8),-32,i*16+8-(level.width*8),16,64,16);
        break;
      case -14503604:
        cube(j*16+8-(level.height*8),-24,i*16+8-(level.width*8),16,48,16);
        break;
      case -16735512:
        cube(j*16+8-(level.height*8),-16,i*16+8-(level.width*8),16,32,16);
        break;
      case -12629812:
        cube(j*16+8-(level.height*8),-8,i*16+8-(level.width*8),16,16,16);
        break;
      case -6075996:
        cube(j*16+8-(level.height*8),0,i*16+8-(level.width*8),16,0,16);
        break;
      default:
        println("meow");
      }
    }
  }
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
  oriCube.text("Back",0,0,50.1);
  oriCube.rotateY(radians(90));
  oriCube.text("Right",0,0,50.1);
  oriCube.rotateY(radians(90));
  oriCube.text("Front",0,0,50.1);
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
  /*old fashioned ahh*/text("If the camera is moving automatically, restart program and make sure mouse does not move while booting program.\nTo close program:\nPush the Esc key or,\nUnfocus program and close with taskbar, task manager, stop button (if applicable), etc. or,\nuse OS dependent keyboard combination if present.\nCONTROLS:\nPositional Movement on the: Z Axis = WS. X Axis = AD. Y Axis = EQ\nCamera Movement on the: X Axis = JL. Y Axis = IK.\nShift to go slower. Use mouse if present for camera.",width/2,height-100);
  image(oriCube,width-75,0,75,75);
  pop();
}

void process() {
  /* Calculates player movement for now.*/
  float s = Speed;
  if(Keys[kSHIFT]) { //SPEED SHIFT
    s*=200;
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
    camDir.x += (mouseX-ceil(width/2))*s;
    camDir.y += (mouseY-ceil(height/2))*s;
  }
  camDir.y = constrain(camDir.y,-89.99,89.99); //Restrict Camera's Y Direction
  PVector Pos = new PVector(); //ORIENTATION VECTOR
  Pos = XZY(PVector.fromAngle(radians(camDir.x)).normalize());
  PVector Y = PVector.fromAngle(radians(camDir.y)).normalize();
  Pos.setMag(Y.x);
  Pos.y = Y.y;
  Pos.normalize();
  if(Keys[kW]) { //MOVE FORWARD
    camPos.add(mousePressed?Pos.copy().mult(s):XZY(PVector.fromAngle(radians(camDir.x))).mult(s));
  }
  if(Keys[kS]) { //MOVE BACK
    camPos.sub(mousePressed?Pos.copy().mult(s):XZY(PVector.fromAngle(radians(camDir.x))).mult(s));
  }
  if(Keys[kA]) { //MOVE LEFT
    camPos.add(XZY(PVector.fromAngle(radians(camDir.x-90))).mult(s));
  }
  if(Keys[kD]) { //MOVE RIGHT
    camPos.add(XZY(PVector.fromAngle(radians(camDir.x+90))).mult(s));
  }
  if(Keys[kE]) { //MOVE UP
    camPos.add(mousePressed?XZY(PVector.fromAngle(radians(camDir.x)).normalize()).setMag(PVector.fromAngle(radians(camDir.y-90)).normalize().x).add(new PVector(0,PVector.fromAngle(radians(camDir.y-90)).normalize().y,0)).mult(s):new PVector(0,-1,0).mult(s));
  }
  if(Keys[kQ]) { //MOVE DOWN
    camPos.sub(mousePressed?XZY(PVector.fromAngle(radians(camDir.x)).normalize()).setMag(PVector.fromAngle(radians(camDir.y-90)).normalize().x).add(new PVector(0,PVector.fromAngle(radians(camDir.y-90)).normalize().y,0)).mult(s):new PVector(0,-1,0).mult(s));
  }
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
final int KSPACE = 32;
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

/*temporary rant segment
jan21 i have forgotten to push my changes from another computer again. wee.
i have finally figured out why long lines distort in p3d. the renderer uses
a very thin tri to draw the line, but when the length is long enough, the
length to thickness ratio causes the line to be thick. in an extreme case,
it can fill the entire screen. so i guess the way to do it now is to avoid
using extremely long lines. i am gonna work on tophat turmoil a lot more
starting february so im probably gonna abandon processing or something. but
i will work on that genesis game until march. so at least thats something.

at this point i should just make a blog on my github pages. if i formatted
all of my rants to be 75 characters wide like this one id probably have
like 1000 lines or something like that. thats 75000 characters for an
estimated 12500 words with 1 word = 5 letters + a space. but thats only my
guess. i hate the new outlook. it replaces my favourite mail app windows
mail just because microsoft wasnt making enough money having an ad free and
extremely quick simple mail app as an alternative to the ad ridden slow web
browser of an app. good thing the only thing i have to do is to uninstall
outlook every time it reinstalls to use the old mail. even better, i can
just disable the windows store because it is rather useless and cut outlook
from being downloaded in the first place. i even prefer outlook classic to
the new outlook. theres a reason why i nicknamed the new outlook $#!+look.
*/
