/* Title: Iwannamakethethirddimension  *\
|* Author: Louie Wang                  *|
|* Description: you know what they say *|
|* with new project comes longer title *|
\*_Date:_Jan.7,_2025___________________*/

PVector camPos = new PVector();
PVector camOri = new PVector();
int Dir = 0; //camera direction

void settings() {
  size(640,480,P3D);//its 3d blast baby
}

void setup() {
  
}

void draw() {
  background(200);
  box(10);
  camera(camPos.x,camPos.y,camPos.z,camOri.x,camOri.y,camOri.z,0,1,0);
  push();
  translate(30,30,30);
  sphere(10);
  pop();
  println(camPos,camOri,Dir);
}

void keyPressed() {
  switch(keyCode) {
  case 87:
    camPos.add(PVector.fromAngle(radians(Dir)));
    camOri = PVector.add(camPos,PVector.fromAngle(radians(Dir)).normalize());
    break;
  case 83:
    camPos.sub(PVector.fromAngle(radians(Dir)));
    camOri = PVector.add(camPos,PVector.fromAngle(radians(Dir)).normalize());
    break;
  case 65:
    Dir += 10;
    camOri = PVector.add(camPos,PVector.fromAngle(radians(Dir)).normalize());
    break;
  case 68:
    Dir -= 10;
    camOri = PVector.add(camPos,PVector.fromAngle(radians(Dir)).normalize());
    break;
  }
}
