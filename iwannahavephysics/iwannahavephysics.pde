/* Title: Iwannahavephysics *\
|* Author: Louie Wang       *|
|* Description: aww man i   *|
|* havent taken physics yet *|
\*_Date:_Oct.9,_2024________*/

import fisica.*;

void settings() {
  Fisica.init(this);
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
  wodeshijie.add(tongzi);
  wodeshijie.add(suraimu);
  wodeshijie.add(luobulesiren);
  luobulesiren.setPosition(width/2,-100);
}

void draw() {
  background(200);
  wodeshijie.step();
  wodeshijie.draw();
}
