/* Title: Iwannamakeamover *\
|* Author: Louie Wang      *|
|* Description: 移動して！ *|
|* ps. view with mono font *|
|* with japanese support   *|
\*_Date:Sept.26,2024_______*/

class Mover {
  int X;
  int Y;
  int Size;
  color Col;
  Mover(){
    X = round(random(0,width));
    Y = round(random(0,height));
    Size = round(random(50,100));
    Col = color(random(0,255),random(0,255),random(0,255));
  }
  Mover(int Xpos, int Ypos){
    X = Xpos;
    Y = Ypos;
    Size = round(random(50,100));
    Col = color(random(0,255),random(0,255),random(0,255));
  }
  Mover(int Xpos, int Ypos, int S){
    X = Xpos;
    Y = Ypos;
    Size = S;
    Col = color(random(0,255),random(0,255),random(0,255));
  }
  Mover(int Xpos, int Ypos, int S, color Colour){
    X = Xpos;
    Y = Ypos;
    Size = S;
    Col = Colour;
  }
  void draw() {
    push();
    fill(Col);
    circle(X,Y,Size);
    pop();
  }
  void draw(int how) {
    push();
    fill(Col);
    ellipseMode(how);
    circle(X,Y,Size);
    pop();
  }
  void move() {
    X += round(random(-2,2));
    Y += round(random(-2,2));
    if(X<0)X=0;
    if(X>width)X=width;
    if(Y<0)Y=0;
    if(Y>width)Y=width;
  }
  void move(int Seed) {
    randomSeed(Seed);
    X += round(random(-2,2));
    Y += round(random(-2,2));
    if(X<0)X=0;
    if(X>width)X=width;
    if(Y<0)Y=0;
    if(Y>width)Y=width;
  }
  void move(int newX, int newY) {
    X = newX;
    Y = newY;
    if(X<0)X=0;
    if(X>width)X=width;
    if(Y<0)Y=0;
    if(Y>width)Y=width;
  }
  void resize() {
    Size = round(random(50, 100));
  }
  void resize(int S) {
    Size = S;
  }
  void recolor() {
    Col = color(random(0, 255),random(0, 255),random(0, 255));
  }
  void recolor(int C) {
    Col = color(C);
  }
  void recolor(int R, int G, int B) {
    Col = color(R, G, B);
  }
}

Mover[] a = new Mover[10];
int Mode = 0x43;

void setup() {
  size(640,480);
  for(int i = 0; i < a.length; i++) a[i] = new Mover();
}

void draw() {
  if(Mode%0x80/0x40>0) {
    if(Mode%0x2>0)background(200);
    for(int i = 0; i < a.length; i++) {
      a[i].draw(CENTER);
      if(Mode%0x4/2>0)a[i].move();
      if(Mode%0x8/4>0)a[i].resize();
      if(Mode%0x10/8>0)a[i].recolor();
    }
    if(Mode%0x40/0x20>0)text("WARNING! If you press 4 again, the circles will start rapidly flashing.\nIf you experience seizures, please reset the sketch to prevent seeing this.",100,100);
  }
}

void keyPressed() {
  switch(keyCode){
  case 49:
    Mode ^= 0x1;//background clear
    break;
  case 50:
    Mode ^= 0x2;//moving
    break;
  case 51:
    Mode ^= 0x4;//size changing
    break;
  case 52:
    if(Mode%0x20/0x10>0) {
      Mode |= 0x20;
      Mode ^= 0x28;//colour changing, clear warning
    }
    else {
      Mode |= 0x10;//warning bit
      Mode |= 0x20;//draw warning
    }
    break;
  case 32:
    Mode ^= 0x40;//stop drawing
    break;
  }
}

//nothin here, sorry. see ranttomakeamover instead.
//oops i mean
/*-----------------------*\
||W E ' R E   M O V I N G||
\\  Our new location is: //
||  ranttomakeamover.pde ||
//     Thank you for     \\
||     your patronage    ||
\*-----------------------*/
//..moving, movers, get it?
