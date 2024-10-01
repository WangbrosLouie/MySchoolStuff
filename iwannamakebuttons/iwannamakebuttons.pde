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
  String text = "";
  color TOut = color(0,0,0);
  color TIn = color(0,0,0);
  Button(int tYPE, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, int DOwHAT, String TEXT, color toUT, color tiN) {
    if(tYPE<0||x<0||y<0||xsIZE<0||ysIZE<0||DOwHAT<0) {
      Type = 1;
      X = 0;
      Y = 0;
      XSize = 0;
      YSize = 0;
      Out = 0;
      In = 0;
      doWhat = 0;
    } else {
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
}

Button[] Btns = {
new Button(1,0,0,100,50,color(50,50,50),100,1),
new Button(1,0,100,100,50,color(50,50,50),100,2)
};
PGraphics Hitbox;

void setup() {
  noSmooth();
  size(640,480);
  Hitbox = createGraphics(640,480);
}

void draw() {
  Hitbox.beginDraw();
  Hitbox.background(0);
  background(200);
  Hitbox.noStroke();
  for(int i=0;i<Btns.length;i++) {//draw button hitboxes
    Hitbox.fill(i2col(i+1));
    switch(Btns[i].Type) {
    case 1:
      Hitbox.rect(Btns[i].X,Btns[i].Y,Btns[i].XSize,Btns[i].YSize);
      break;
    case 2:
      Hitbox.ellipse(Btns[i].X,Btns[i].Y,Btns[i].XSize,Btns[i].YSize);
    }
  }
  Hitbox.endDraw();
  for(int i=0;i<Btns.length;i++) {//draw buttons
    fill(Btns[i].In);
    stroke(Btns[i].Out);
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
  int Action = Hitbox.get(mouseX,mouseY);
  Action = round(red(Action))*0x100+round(green(Action))*0x100+ceil(blue(Action));
  println(Action);
  switch(Action) {
  case 1:
    print("yay");
    break;
  default:
  }
}

color i2col(int i) {
  return color(i%0x1000000/0x10000,i%0x10000/0x100,i%0x100);
}
