/* Title: Iwannamakethethirddimension  *\
|* Author: Louie Wang                  *|
|* Description: you know what they say *|
|* with new project comes longer title *|
\*_Date:_Jan.6,_2025___________________*/

PVector camPos = new PVector();
PVector camOri = new PVector();
float Dir = 0; //camera direction
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
  perspective(PI/2.0, (float)width/(float)height, 5.0, 1000.0);
  img = loadImage("testbot my beloved.png");
  ThreeD = createGraphics(width,height,P3D);//if i cant figure out how to draw 2D graphics im gonna use this
  oriCube = createGraphics(50,50,P3D);
  mytricks = getMatrix(mytricks);
}

void draw() {
  pushMatrix();
  process();
  camera(camPos.x,camPos.y,camPos.z,camOri.x,camOri.y,camOri.z,0,1,0);
  background(200);
  cube(-10,10,-10,10);
  cube(20,20,-20,10,img);
  ball(30,30,30,10);
  popMatrix();
  this.setMatrix(mytricks);
  PVector oriPos = PVector.sub(camOri,camPos).mult(25);
  oriCube.beginDraw();
  oriCube.background(0);
  cube(0,0,0,10,oriCube);
  oriCube.camera(-oriPos.x,-oriPos.y,-oriPos.z,0,0,0,0,1,0);
  oriCube.endDraw();
  imageMode(CORNER);
  image(oriCube,mouseX,mouseY,50,50);
  println(camPos,camOri,Dir);
}

void process() {
  float s = Speed;
  if(Keys[16]) {
    s*=.2;
  }
  if(Keys[87]) {
    camPos.add(XZY(PVector.fromAngle(radians(Dir))).mult(s));
  }
  if(Keys[83]) {
    camPos.sub(XZY(PVector.fromAngle(radians(Dir))).mult(s));
  }
  if(Keys[65]) {
    Dir -= 2*s;
  }
  if(Keys[68]) {
    Dir += 2*s;
  }
  if(Keys[69]) {
    camPos.add(new PVector(0,-1,0).mult(s));
    camOri.add(new PVector(0,-1,0).mult(s));
  }
  if(Keys[81]) {
    camPos.add(new PVector(0,1,0).mult(s));
    camOri.add(new PVector(0,1,0).mult(s));
  }
    camOri = PVector.add(camPos,XZY(PVector.fromAngle(radians(Dir)).normalize()));
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
