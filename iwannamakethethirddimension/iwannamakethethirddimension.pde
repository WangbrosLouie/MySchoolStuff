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

void settings() {
  size(640,480,P3D);//its 3d blast baby
}

void setup() {
  perspective(PI/3.0, (float)width/(float)height, 10.0, 1000.0);
}

void draw() {
  process();
  background(200);
  cube(-10,10,-10,10);
  push();
  translate(30,30,30);
  sphere(10);
  pop();
  camera(camPos.x,camPos.y,camPos.z,camOri.x,camOri.y,camOri.z,0,1,0);
  println(camPos,camOri,Dir);
}

void process() {
  float s = Speed;
  if(Keys[16]) {
    s*=.2;
  }
  if(Keys[87]) {
    camPos.add(XZY(PVector.fromAngle(radians(Dir))).mult(s));
    camOri = PVector.add(camPos,XZY(PVector.fromAngle(radians(Dir)).normalize()));
  }
  if(Keys[83]) {
    camPos.sub(XZY(PVector.fromAngle(radians(Dir))).mult(s));
    camOri = PVector.add(camPos,XZY(PVector.fromAngle(radians(Dir)).normalize()));
  }
  if(Keys[65]) {
    Dir -= 2*s;
    camOri = PVector.add(camPos,XZY(PVector.fromAngle(radians(Dir)).normalize()));
  }
  if(Keys[68]) {
    Dir += 2*s;
    camOri = PVector.add(camPos,XZY(PVector.fromAngle(radians(Dir)).normalize()));
  }
  if(Keys[69]) {
    camPos.add(new PVector(0,-1,0).mult(s));
    camOri.add(new PVector(0,-1,0).mult(s));
  }
  if(Keys[81]) {
    camPos.add(new PVector(0,1,0).mult(s));
    camOri.add(new PVector(0,1,0).mult(s));
  }
}

void cube(float x, float y, float z, float size) {
  push();
  translate(x,y,z);
  box(size);
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
