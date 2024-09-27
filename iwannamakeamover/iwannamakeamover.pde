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
int Mode = 0;

void setup() {
  size(640,480);
  for(int i = 0; i < a.length; i++) a[i] = new Mover();
}

void draw() {
  for(int i = 0; i < a.length; i++) {
    a[i].draw(CENTER);
    a[i].move();
  }
}

void keyPressed() {
  switch(keyCode){
  case 49:
    Mode ^= 0x1;
    break;
  case 50:
    Mode ^= 0x2;
    break;
  case 51:
    Mode ^= 0x4;
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
