/* Title: Iwannamakesoccar *\
|* Author: Louie Wang      *|
|* Description: rocket     *|
|* league sideswipe ahh    *|
\*_Date:_Oct.10,_2024______*/

import fisica.*;

void settings() {
  Fisica.init(this);
  size(640,480);
}

FWorld myWorld;
FBox floor;
FPoly frame;
FCircle tire, tire2, ball;
FCompound car1;
FCompound car2;
FDistanceJoint[] axles;
boolean[] Keys = new boolean[6];
boolean[] deKeys = new boolean[6];

void setup() {
  myWorld = new FWorld();
  floor = new FBox(width,30);
  floor.setStatic(true);
  floor.setPosition(width/2,height-15);
  frame = new FPoly();
  frame.vertex(0,20);
  frame.vertex(20,20);
  frame.vertex(30,0);
  frame.vertex(70,0);
  frame.vertex(80,20);
  frame.vertex(100,20);
  frame.vertex(100,50);
  frame.vertex(90,50);
  frame.vertex(80,40);
  frame.vertex(70,50);
  frame.vertex(30,50);
  frame.vertex(20,40);
  frame.vertex(10,50);
  frame.vertex(0,50);
  car1 = new FCompound();
  car2 = new FCompound();
  car1.addBody(frame);
  car2.addBody(frame);
  tire = new FCircle(20);
  tire2 = new FCircle(20);
  tire.setPosition(20,50);
  car1.addBody(tire);
  car2.addBody(tire);
  tire2.setPosition(80,50);
  car1.addBody(tire2);
  car2.addBody(tire2);
  axles = new FDistanceJoint[] {new FDistanceJoint((FBody)car1.getBodies().get(0),(FBody)car1.getBodies().get(1)),
  new FDistanceJoint((FBody)car1.getBodies().get(0),(FBody)car1.getBodies().get(2)),
  new FDistanceJoint((FBody)car2.getBodies().get(0),(FBody)car2.getBodies().get(1)),
  new FDistanceJoint((FBody)car2.getBodies().get(0),(FBody)car2.getBodies().get(1))};
  for(int i=0;i<2;i++) {
    axles[i].setAnchor1(20,50);
    axles[i].setAnchor2(10,10);
    axles[i+1].setAnchor1(80,50);
    axles[i+1].setAnchor2(10,10);
  }
  ball = new FCircle(60);
  ball.setPosition(width/2,height/2);
  myWorld.add(floor);
  myWorld.add(car1);
  car2.setPosition(width-100,0);
  myWorld.add(car2);
  for(int i=0;i<4;i++) {
    myWorld.add(axles[i]);
  }
  myWorld.add(ball);
  java.util.Arrays.fill(deKeys,false);
}

void draw() {
  background(200);
  FBody temp = (FBody)car1.getBodies().get(1);
  temp.setAngularVelocity(1);
  myWorld.step();
  myWorld.draw();
}

void keyPressed() {
  switch(keyCode){
  case 65:
    Keys[0] = true;
    break;
  case 68:
    Keys[1] = true;
    break;
  case 87:
    Keys[2] = true;
    break;
  case 37:
    Keys[3] = true;
    break;
  case 39:
    Keys[4] = true;
    break;
  case 38:
    Keys[5] = true;
    break;
  }
}

void keyReleased() {
  switch(keyCode){
  case 65:
    Keys[0] = false;
    break;
  case 68:
    Keys[1] = false;
    break;
  case 87:
    Keys[2] = false;
    break;
  case 37:
    Keys[3] = false;
    break;
  case 39:
    Keys[4] = false;
    break;
  case 38:
    Keys[5] = false;
    break;
  }
}
