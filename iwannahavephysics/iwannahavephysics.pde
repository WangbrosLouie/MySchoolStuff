/* Title: Iwannahavephysics *\
|* Author: Louie Wang       *|
|* Description: aww man i   *|
|* havent taken physics yet *|
\*_Date:_Oct.9,_2024________*/

import fisica.*;

void settings() {
  Fisica.init(this);
  org.jbox2d.common.Settings.maxPairs = 1;//how to set settings in something with no documentation?
  
  
  size(640,480);
}

FWorld wodeshijie; //means my world in chinese
FBox luobulesiren; //robloxian
FBlob suraimu; //slime
FPoly tongzi; //bucket i think
//note to self initialize everything in setup or later

void setup() {
  wodeshijie = new FWorld();
  luobulesiren = new FBox(10,50);
  suraimu = new FBlob();
  suraimu.setAsCircle(60);
  suraimu.setFillColor(color(255,100,200));
  suraimu.setGrabbable(true);
  tongzi = new FPoly();
  tongzi.vertex(50,50);
  tongzi.vertex(70,50);
  tongzi.vertex(80,430);
  tongzi.vertex(560,430);
  tongzi.vertex(570,50);
  tongzi.vertex(590,50);
  tongzi.vertex(580,440);
  tongzi.vertex(60,440);
  tongzi.setStatic(true);
  tongzi.setGrabbable(false);
  wodeshijie.add(tongzi);
  wodeshijie.add(suraimu);
  suraimu.setPosition(width/2,0);
  wodeshijie.add(luobulesiren);
  luobulesiren.setPosition(width/2,-100);
  wodeshijie.setGrabbable(true);
}

void draw() {
  background(200);
  wodeshijie.add(suraimu);
  wodeshijie.step();
  wodeshijie.draw();
}
