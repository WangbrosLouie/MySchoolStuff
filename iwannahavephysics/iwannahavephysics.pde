/* Title: Iwannahavephysics *\
|* Author: Louie Wang       *|
|* Description: aww man i   *|
|* havent taken physics yet *|
\*_Date:_Oct.9,_2024________*/

import fisica.*;

void settings() {
  Fisica.init(this);
  size(640,480);
  fullScreen();
}

FWorld wodeshijie; //means my world in chinese
FBox luobulesiren; //robloxian
FBlob suraimu; //slime
FPoly tongzi; //bucket i think
FDistanceJoint jiaru; //add
FCircle body1;
FBox body2;
//note to self initialize everything in setup or later

void setup() {
  wodeshijie = new FWorld();
  luobulesiren = new FBox(10,50);
  suraimu = new FBlob();
  suraimu.setFillColor(color(255,100,200));
  suraimu.setAsCircle(width/2,0,60);
  tongzi = new FPoly();
  tongzi.vertex(100,100);
  tongzi.vertex(120,100);
  tongzi.vertex(130,430);
  tongzi.vertex(460,430);
  tongzi.vertex(470,100);
  tongzi.vertex(490,100);
  tongzi.vertex(480,440);
  tongzi.vertex(110,440);
  tongzi.setStatic(true);
  tongzi.setGrabbable(false);
  body1 = new FCircle(30);
  body1.setPosition(width/2,300);
  body1.setFriction(1);
  body2 = new FBox(30,30);
  body1.setPosition(width/2,350);
  jiaru = new FDistanceJoint(body1,body2);
  jiaru.setAnchor1(5,5);
  jiaru.setAnchor2(5,5);
  jiaru.setLength(50);
  wodeshijie.add(tongzi);
  wodeshijie.add(suraimu);
  wodeshijie.add(luobulesiren);
  wodeshijie.add(body1);
  wodeshijie.add(body2);
  wodeshijie.add(jiaru);
  luobulesiren.setPosition(width/2,150);
}

void draw() {
  background(200);
  body1.setAngularVelocity(10);
  wodeshijie.step();
  wodeshijie.draw();
}
