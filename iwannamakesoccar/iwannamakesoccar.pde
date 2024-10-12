/* Title: Iwannamakesoccar *\
|* Author: Louie Wang      *|
|* Description: rocket     *|
|* league sideswipe ahh    *|
\*_Date:_Oct.10,_2024______*/

import fisica.*;
import gifAnimation.*;

void settings() {
  Fisica.init(this);
  size(640,480);
}

FWorld myWorld;
FBox floor, lwall, rwall, roofe, lgol1, lgol2, rgol1, rgol2;
FPoly frame, fram2;
FCircle ball, tire1, tire2, tire3, tire4;
//FCircle[] tires;
FDistanceJoint[] axles;
boolean[] Keys = new boolean[20]; //0-5 keys 6&7 debounce for jump key 8-11 wheels touching floor? 12&13 can jump? 14&&15 body touching floor?
Gif bg;
int goalHeight = height*2;
int scor1 = 0;
int scor2 = 0;
int boos1 = 33;
int boos2 = 33;
byte jmp1 = 0;
byte jmp2 = 0;
float ballVelo = 0;

void setup() {
  java.util.Arrays.fill(Keys,false);
  bg = new Gif(this,"chip.gif");
  bg.loop();
  myWorld = new FWorld(-width*2,-goalHeight*5,width*3,height+100);
  myWorld.setGrabbable(false);
  myWorld.setGravity(0,500);
  floor = new FBox(width*4,100);
  floor.setStatic(true);
  floor.setPosition(width/2,height+15);
  roofe = new FBox(width*4,100);
  roofe.setStatic(true);
  roofe.setPosition(width/2,-height*2-15);
  lwall = new FBox(30,height*2-goalHeight);
  lwall.setStatic(true);
  lwall.setPosition(-width*1.5,-goalHeight);
  rwall = new FBox(30,height*2-goalHeight);
  rwall.setStatic(true);
  rwall.setPosition(width*2.5,-goalHeight);
  frame = new FPoly();
  frame.vertex(0,20);
  frame.vertex(20,20);
  frame.vertex(30,0);
  frame.vertex(70,0);
  frame.vertex(80,20);
  frame.vertex(100,20);
  frame.vertex(100,50);
  frame.vertex(0,50);
  frame.setPosition(0,height-105);
  frame.setDensity(3);
  fram2 = new FPoly();
  fram2.vertex(0,20);
  fram2.vertex(20,20);
  fram2.vertex(30,0);
  fram2.vertex(70,0);
  fram2.vertex(80,20);
  fram2.vertex(100,20);
  fram2.vertex(100,50);
  fram2.vertex(0,50);
  fram2.setPosition(width-100,height-105);
  fram2.setDensity(3);
  tire1 = new FCircle(30);
  tire2 = new FCircle(30);
  tire3 = new FCircle(30);
  tire4 = new FCircle(30);
  tire1.setPosition(20,height-60);
  tire2.setPosition(80,height-60);
  tire3.setPosition(width-20,height-60);
  tire4.setPosition(width-80,height-60);
  tire1.setFriction(10);
  tire2.setFriction(10);
  tire3.setFriction(10);
  tire4.setFriction(10);
  tire1.setBullet(true);
  tire2.setBullet(true);
  tire3.setBullet(true);
  tire4.setBullet(true);
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
  ball.setPosition(width/2,0);
  ball.setFriction(0.5);
  ball.setDensity(0.1);
  ball.setRestitution(1);
  ball.setBullet(true);
  ball.setAllowSleeping(false);
  frame.setGroupIndex(-1);
  tire1.setGroupIndex(-1);
  tire2.setGroupIndex(-1);
  fram2.setGroupIndex(-2);
  tire3.setGroupIndex(-2);
  tire4.setGroupIndex(-2);
  myWorld.add(floor);
  myWorld.add(roofe);
  myWorld.add(lwall);
  myWorld.add(rwall);
  myWorld.add(frame);
  myWorld.add(fram2);
  myWorld.add(tire1);
  myWorld.add(tire2);
  myWorld.add(tire3);
  myWorld.add(tire4);
  for(int i=0;i<4;i++) {
    axles[i].setDrawable(false);
    myWorld.add(axles[i]);
  }
  myWorld.add(ball);
}

void draw() {
  ballVelo = lerp(ballVelo,round(pow((dist(0,0,ball.getVelocityX(),ball.getVelocityY())+1)*0.01,2)/0.5)*0.5,0.01);
  if(ballVelo<0.5)ballVelo = 0;
  if(ballVelo>50)ballVelo = 50;
  background(200);
  processKeys();
  myWorld.step();
  float bgScale = 300;
  for(int i=-1;i<1+height/bgScale;i++) {
    for(int j=-1;j<1+width/bgScale;j++) {
      image(bg,(j*bgScale)+(-ball.getX()/10%bgScale),(i*bgScale)-(-ball.getY()/10%bgScale),bgScale,bgScale);
    }
  }
  push();
  translate(round((width-ball.getX())/2)+ballVelo,round((height-ball.getY())/2)+ballVelo);
  scale(0.5-ballVelo/400);
  myWorld.draw();
  pop();
  textSize(50);
  textAlign(LEFT,CENTER);
  text(scor1,30,30);
  textAlign(RIGHT,CENTER);
  text(scor2,width-30,30);
  println(ball.isSleeping());
}

void processKeys() {
  if(Keys[0]){
    tire1.addTorque(-100);
    tire2.addTorque(-100);
    if(!Keys[8]&&!Keys[9])frame.addTorque(-500);
  }
  if(Keys[1]){
    tire1.addTorque(100);
    tire2.addTorque(100);
    if(!Keys[8]&&!Keys[9])frame.addTorque(500);
  }
  if(Keys[2]&&!Keys[6]&&Keys[12]){
    PVector jump = PVector.fromAngle(frame.getRotation()-HALF_PI).mult(15000);
    frame.addImpulse(jump.x,jump.y,0,25);
    Keys[12] = false;
  } else if(Keys[2]&&!Keys[6]&&!(Keys[8]&&Keys[9])&&Keys[14]) {//flip car
    frame.setAngularVelocity(-frame.getRotation()*4);
  }
  if(!(Keys[16]&&Keys[17])) {
    if(Keys[16]) {PVector jump = PVector.fromAngle(frame.getRotation()-PI).mult(500);
      frame.addImpulse(jump.x,jump.y,0,0);
    }
    if(Keys[17]) {PVector jump = PVector.fromAngle(frame.getRotation()).mult(500);
      frame.addImpulse(jump.x,jump.y,0,0);
    }
  }
  if(Keys[3]){
    tire3.addTorque(-100);
    tire4.addTorque(-100);
    if(!Keys[10]&&!Keys[11])fram2.addTorque(-500);
  }
  if(Keys[4]){
    tire3.addTorque(100);
    tire4.addTorque(100);
    if(!Keys[10]&&!Keys[11])fram2.addTorque(500);
  }
  if(Keys[5]&&!Keys[7]&&Keys[13]){
    PVector jump = PVector.fromAngle(fram2.getRotation()-HALF_PI).mult(15000);
    fram2.addImpulse(jump.x,jump.y,0,25);
    Keys[13] = false;
  } else if(Keys[5]&&!Keys[7]&&!(Keys[10]&&Keys[11])&&Keys[15]) {//flip car
    fram2.setAngularVelocity(-fram2.getRotation()*4);
  }
  if(!(Keys[18]&&Keys[19])){
    if(Keys[18]&&boos2>0) {PVector jump = PVector.fromAngle(fram2.getRotation()-PI).mult(500);
      fram2.addImpulse(jump.x,jump.y,0,0);
      boos2 -= 2;
    }
    if(Keys[19]&&boos2>0) {PVector jump = PVector.fromAngle(fram2.getRotation()).mult(500);
      fram2.addImpulse(jump.x,jump.y,0,0);
      boos2 -= 2;
    }
  }
  if(Keys[2]&&!Keys[6])Keys[6]=true;
  if(Keys[6]&&!Keys[2])Keys[6]=false;
  if(Keys[8]||Keys[9])Keys[12]=true;
  if(Keys[5]&&!Keys[7])Keys[7]=true;
  if(Keys[7]&&!Keys[5])Keys[7]=false;
  if(Keys[10]||Keys[11])Keys[13]=true;
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
  case 81:
    Keys[16] = true;
    break;
  case 69:
    Keys[17] = true;
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
  case 81:
    Keys[16] = false;
    break;
  case 69:
    Keys[17] = false;
    break;
  }
}

void contactStarted(FContact contact) {
  if(contact.contains(tire1,floor))Keys[8]=true;
  if(contact.contains(tire2,floor))Keys[9]=true;
  if(contact.contains(tire3,floor))Keys[10]=true;
  if(contact.contains(tire4,floor))Keys[11]=true;
  if(contact.contains(frame,floor))Keys[14]=true;
  if(contact.contains(fram2,floor))Keys[15]=true;
}

void contactEnded(FContact contact) {
  if(contact.contains(tire1,floor))Keys[8]=false;
  if(contact.contains(tire2,floor))Keys[9]=false;
  if(contact.contains(tire3,floor))Keys[10]=false;
  if(contact.contains(tire4,floor))Keys[11]=false;
  if(contact.contains(frame,floor))Keys[14]=false;
  if(contact.contains(fram2,floor))Keys[15]=false;
}
