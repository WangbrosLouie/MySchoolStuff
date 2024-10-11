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
FPoly frame, fram2;
FCircle ball, tire1, tire2, tire3, tire4;
//FCircle[] tires;
FDistanceJoint[] axles;
boolean[] Keys = new boolean[12];


void setup() {
  java.util.Arrays.fill(Keys,false);
  myWorld = new FWorld();
  myWorld.setGrabbable(false);
  myWorld.setGravity(0,500);
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
  frame.vertex(0,50);
  fram2 = new FPoly();
  fram2.vertex(0,20);
  fram2.vertex(20,20);
  fram2.vertex(30,0);
  fram2.vertex(70,0);
  fram2.vertex(80,20);
  fram2.vertex(100,20);
  fram2.vertex(100,50);
  fram2.vertex(0,50);
  fram2.setPosition(width-100,0);
  //tires = new FCircle[4];
  //java.util.Arrays.fill(tires,new FCircle(20));
  tire1 = new FCircle(20);
  tire2 = new FCircle(20);
  tire3 = new FCircle(20);
  tire4 = new FCircle(20);
  tire1.setPosition(20,50);
  tire2.setPosition(80,50);
  tire3.setPosition(width-20,50);
  tire4.setPosition(width-80,50);
  tire1.setFriction(1);
  tire2.setFriction(1);
  tire3.setFriction(1);
  tire4.setFriction(1);
  axles = new FDistanceJoint[] {new FDistanceJoint(frame,tire1),
  new FDistanceJoint(frame,tire2),
  new FDistanceJoint(fram2,tire3),
  new FDistanceJoint(fram2,tire4)};
  for(int i=0;i<2;i++) {
    axles[i*2].setAnchor1(20,50);
    axles[i*2].setAnchor2(0,0);
    axles[i*2].setLength(0);
    axles[i*2].setDamping(0);
    axles[i*2+1].setAnchor1(80,50);
    axles[i*2+1].setAnchor2(0,0);
    axles[i*2+1].setLength(0);
    axles[i*2+1].setDamping(0);
  }
  ball = new FCircle(60);
  ball.setPosition(width/2,height/2);
  ball.setFriction(0.5);
  ball.setDensity(0.01);
  ball.setRestitution(0.8);
  frame.setGroupIndex(-1);
  tire1.setGroupIndex(-1);
  tire2.setGroupIndex(-1);
  fram2.setGroupIndex(-2);
  tire3.setGroupIndex(-2);
  tire4.setGroupIndex(-2);
  myWorld.add(floor);
  myWorld.add(frame);
  myWorld.add(fram2);
  myWorld.add(tire1);
  myWorld.add(tire2);
  myWorld.add(tire3);
  myWorld.add(tire4);
  for(int i=0;i<4;i++) {
    myWorld.add(axles[i]);
  }
  myWorld.add(ball);
}

void draw() {
  float ballVelo = pow((dist(0,0,ball.getVelocityX(),ball.getVelocityY())+1)*0.01,2);
  if(ballVelo<0.5)ballVelo = 0;
  translate(round(width/2-ball.getX())+ballVelo,round(height/2-ball.getY())+ballVelo);
  scale(1-ballVelo/400);
  background(200);
  //tire1.addTorque(100);
  //tire2.addTorque(100);
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
