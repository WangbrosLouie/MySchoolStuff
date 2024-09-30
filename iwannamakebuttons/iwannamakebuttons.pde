/* Title: Iwannamakebuttons *\
|* Author: Louie Wang       *|
|* Description: Windows 95  *|
|* in processing when       *|
\*_Date:Sept.29, 2024_______*/

class Button {
  int Type = -1;
  int X = -1;
  int Y = -1;
  int XSize = -1;
  int YSize = -1;
  color Out = color(0,0,0);
  color In = color(0,0,0);
  int doWhat = -1;
  Button(int tYPE, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, int DOwHAT) {
    if(tYPE<0||x<0||y<0||xsIZE<0||ysIZE<0, color oUT, color iN, int DOwHAT
    Type = tYPE;
    X = x;
    Y = y;
    XSize = xsIZE;
    YSize = ysIZE;
    Out = oUT;
    In = iN;
    doWhat = DOwHAT;
  }
}

Button[] Btns = new Button[10];
PGraphics Hitbox;

void setup() {
  size(640,480);
  Hitbox = createGraphics(640,480);
}

void draw() {
  noSmooth();
  for(int i=0;i<Btns.length;i++) {//draw button hitboxes
    fill(Btns[i].doWhat);
    switch(Btns[i].Type) {
    case 1:
      rect(Btns[i].X,Btns[i].Y,Btns[i].XSize,Btns[i].YSize);
      break;
    case 2:
      ellipse(Btns[i].X,Btns[i].Y,Btns[i].XSize,Btns[i].YSize);
    }
  }
  smooth();
  for(int i=0;i<Btns.length;i++) {//draw button hitboxes
    fill(Btns[i].doWhat);
    switch(Btns[i].Type) {
    case 1:
      rect(Btns[i].X,Btns[i].Y,Btns[i].XSize,Btns[i].YSize);
      break;
    case 2:
      ellipse(Btns[i].X,Btns[i].Y,Btns[i].XSize,Btns[i].YSize);
    }
  }
}

void mousePressed() {
  int Action = get(mouseX,mouseY);
  switch(Action) {
  case 1:
    break;
  default:
  }
}
