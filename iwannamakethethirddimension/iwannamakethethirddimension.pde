/* Title: Iwannamakethethirddimension  *\
|* Author: Louie Wang                  *|
|* Description: you know what they say *|
|* with new project comes longer title *|
\*_Date:_Jan.6,_2025___________________*/

PVector camPos = new PVector();
PVector camOri = new PVector();
PVector camDir = new PVector();
boolean[] Keys = new boolean[256];
float Speed = 1.0;
PImage img;
PGraphics ThreeD;
PGraphics oriCube;
PMatrix3D mytricks;

void settings() {
  size(640,480,P3D);//its 3d blast baby
}

void setup() {
  mytricks = getMatrix(mytricks);//thanks google
  img = loadImage("testbot my beloved.png");
  oriCube = createGraphics(75,75,P3D);
}

void draw() {
  pushMatrix();
  perspective(PI/2.0, (float)width/(float)height, 5.0, 1000.0);
  process();
  camera(camPos.x,camPos.y,camPos.z,camOri.x,camOri.y,camOri.z,0,1,0);
  background(200);
  cube(-10,10,-10,10);
  cube(20,20,-20,10,img);
  ball(30,30,30,10);
  popMatrix();
  this.setMatrix(mytricks);
  perspective();
  PVector oriPos = PVector.sub(camOri,camPos).mult(25);
  oriCube.beginDraw();
  oriCube.background(0);
  cube(0,0,0,10,oriCube);
  oriCube.camera(-oriPos.x,-oriPos.y,-oriPos.z,0,0,0,0,1,0);
  oriCube.endDraw();
  imageMode(CORNER);
  image(oriCube,width-75,0,75,75);
  println(camPos,camOri,camDir);
}

void process() {
  float s = Speed;
  if(Keys[16]) {
    s*=.2;
  }
  if(Keys[87]) {
    camPos.add(XZY(PVector.fromAngle(radians(camDir.x))).mult(s));
  }
  if(Keys[83]) {
    camPos.sub(XZY(PVector.fromAngle(radians(camDir.x))).mult(s));
  }
  if(Keys[74]) {
    camPos.add(XZY(PVector.fromAngle(radians(camDir.x-90))).mult(s));
  }
  if(Keys[76]) {
    camPos.add(XZY(PVector.fromAngle(radians(camDir.x+90))).mult(s));
  }
  if(Keys[65]) {
    camDir.x -= 2*s;
  }
  if(Keys[68]) {
    camDir.x += 2*s;
  }
  if(Keys[73]) {
    camDir.y -= 2*s;
  }
  if(Keys[75]) {
    camDir.y += 2*s;
  }
  if(Keys[69]) {
    camPos.add(new PVector(0,-1,0).mult(s));
    camOri.add(new PVector(0,-1,0).mult(s));
  }
  if(Keys[81]) {
    camPos.add(new PVector(0,1,0).mult(s));
    camOri.add(new PVector(0,1,0).mult(s));
  }
    PVector Pos = new PVector();
    Pos = XZY(PVector.fromAngle(radians(camDir.x)).normalize());
    PVector Y = PVector.fromAngle(radians(camDir.y)).normalize();
    Pos.setMag(Y.x);
    Pos.y = Y.y;
    Pos.normalize();
    camOri = PVector.add(camPos,Pos);
    //this took me so meowin long ToT
    //camOri = PVector.add(camPos,XZY(PVector.fromAngle(radians(camDir.x)).normalize()));
    //camOri = PVector.add(camOri,ZXY(PVector.fromAngle(radians(camDir.y)).normalize()));
}

void cube(float x, float y, float z, float size) {
  push();
  translate(x,y,z);
  box(size);
  pop();
}

void cube(float x, float y, float z, float size, PGraphics screen) {
  screen.push();
  screen.translate(x,y,z);
  //screen.beginDraw();
  screen.box(size);
  //screen.endDraw();
  screen.pop();
}

void ball(float x, float y, float z, float size) {
  push();
  translate(x,y,z);
  sphere(size);
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
