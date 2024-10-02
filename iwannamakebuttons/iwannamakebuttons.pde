/* Title: Iwannamakebuttons *\
|* Author: Louie Wang       *|
|* Description: Windows 95  *|
|* in processing when       *|
\*_Date:Sept.29, 2024_______*/

class Button {
  int Type = 0; //positive type is text, negative type is image
  int X = 0;
  int Y = 0;
  int XSize = 0;
  int YSize = 0;
  color Out = color(0,0,0);// idle outline
  color In = color(0,0,0);// idle fill
  int doWhat = 0;
  String text = "";
  PImage img = new PImage();
  color TOut = color(0,0,0);// text unpressed
  color TIn = color(0,0,0);// text depressed
  color POut = color(0,0,0);// pressed outline
  color PIn = color(0,0,0);// pressed fill
  color THov = color(0,0,0);// text hover
  color HOut = color(0,0,0);// hover outline
  color HIn = color(0,0,0);// hover fill
  //text button constructor
  Button(int tYPE, int DOwHAT, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, color hoUT, color hiN, color poUT, color piN, color toUT, color thOV, color tiN, String TEXT) {
    if(tYPE<0||x<0||y<0||xsIZE<0||ysIZE<0||DOwHAT<0) {
      Type = 1;
    } else {
      Type = abs(tYPE);
      X = x;
      Y = y;
      XSize = xsIZE;
      YSize = ysIZE;
      Out = oUT;
      In = iN;
      doWhat = DOwHAT;
      text = TEXT;
      TOut = toUT;
      TIn = tiN;
      POut = poUT;
      PIn = piN;
      HIn = hiN;
      HOut = hoUT;
    }
  }
  //image button constructor
  Button(int tYPE, int DOwHAT, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, color hoUT, color hiN, color poUT, color piN, color toUT, color thOV, color tiN, PImage IMG) {
    if(tYPE<0||x<0||y<0||xsIZE<0||ysIZE<0||DOwHAT<0) {
      Type = -1;
    } else {
      Type = -abs(tYPE);
      X = x;
      Y = y;
      XSize = xsIZE;
      YSize = ysIZE;
      Out = oUT;
      In = iN;
      doWhat = DOwHAT;
      img = IMG;
      TOut = toUT;
      TIn = tiN;
      POut = poUT;
      PIn = piN;
      HIn = hiN;
      HOut = hoUT;
    }
  }
  
  void draw(byte Active) {//2 is pressed, 1 is hover, 0 is idle
    if(Type==0||Type==-0) {
      println("Warning: Uninitialized button.");
    } else {
      push();
      textAlign(CENTER,CENTER);
      switch(Active) {
      case 0:
        fill(TOut);
        push();
        stroke(Out);
        fill(In);
        break;
      case 1:
        fill(THov);
        push();
        stroke(HOut);
        fill(HIn);
        break;
      case 2:
        fill(TIn);
        push();
        stroke(POut);
        fill(PIn);
        break;
      default:
        println("Naked huh?");
      }
      switch(abs(Type)) {
      case 1:
        rect(X,Y,XSize,YSize);
        pop();
        text(text,XSize/2+X,YSize/2+Y);
        break;
      case 2:
        ellipse(X,Y,XSize,YSize);
        pop();
        text(text,XSize/2+X,YSize/2+Y);
      }
      pop();
    }
  }
  
  void drawHit(int i) {
    i++;
    Hitbox.fill(color(i%0x1000000/0x10000,i%0x10000/0x100,i%0x100));
    switch(abs(Type)) {
    case 1:
      Hitbox.rect(X,Y,XSize,YSize);
      break;
    case 2:
      Hitbox.ellipse(X,Y,XSize,YSize);
    }
  }
}
Button[] Btns = {
new Button(1,1,50,50,150,50,color(0),color(200),color(0),color(150),color(0),color(100),color(0),color(0),color(0),"NYA")
};
PGraphics Hitbox;
int Button = 0;
int BGCol = 0;

void setup() {
  size(640,480);
  Hitbox = createGraphics(640,480);
  Hitbox.noSmooth();//yooshi yattazo!
  Hitbox.noStroke();
}

void draw() {
  Hitbox.beginDraw();
  Hitbox.background(0);
  background(255);
  for(int i=0;i<Btns.length;i++)Btns[i].drawHit(i);
  for(int i=0;i<Btns.length;i++) {//draw buttons
    byte Status = 0;
    int Hover = Hitbox.get(mouseX,mouseY);
    Hover = round(red(Hover))*0x100+round(green(Hover))*0x100+ceil(blue(Hover));
    print(Hover);
    if(Hover-1==i)Status = 1;
    if(Button-1==i)Status = 2;
    Btns[i].draw(Status);
  }
  Hitbox.endDraw();
}

void mousePressed() {
  int Action = Hitbox.get(mouseX,mouseY);
  Button = round(red(Action))*0x100+round(green(Action))*0x100+ceil(blue(Action));
}

void mouseReleased() {
  int Action = Hitbox.get(mouseX,mouseY);
  Action = round(red(Action))*0x100+round(green(Action))*0x100+ceil(blue(Action));
  if(Action==Button&&Action!=0) {
    Action = Btns[Action-1].doWhat;
    switch(Action) {
    case 1:
      print("yay");
      //increase bg col
      break;
    case 2:
      //decrease bg col
    default:
    }
  Button = 0;
  }
}
