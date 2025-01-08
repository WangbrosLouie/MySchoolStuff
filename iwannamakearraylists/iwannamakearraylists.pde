/* Title: Iwannamakearraylists *\
|* Author: Louie Wang          *|
|* Description: Oh ArrayLists  *|
|* where have you been all my  *|
|* life why am I just learning *|
|* about it now and not before *|
\*_Date:_Oct.4,_2024___________*/

class Thing {//it's a thing. what more is there to say?
  PVector P = new PVector();//position
  int S = 0;//size
  PVector D = new PVector();//direction
  Thing(PVector p, int s, PVector d){
    P = p;
    S = s;
    D = d;
  }
  Thing(){
    P = new PVector(random(0,width),random(0,height));
    S = 60;
    D = PVector.fromAngle(random(0,TAU));
  }
  void draw(ArrayList<Thing> Stuff) {
    for(int i=0;i<5;i++) {
      P.add(D);
      if(P.x<S/2||P.x>width-(S/2)){P.x = constrain(P.x,S/2,width-(S/2));D.x = -D.x;}
      if(P.y<S/2||P.y>height-(S/2)){P.y = constrain(P.y,S/2,height-(S/2));D.y = -D.y;}
    }
    fill(#3972A7);
    circle(P.x,P.y,S);
    for (Thing thin : Stuff) {
      float dist = P.dist(thin.P)*5;
      push();
      stroke(255,255-(dist/3));
      line(P.x,P.y,thin.P.x,thin.P.y);
      pop();
    }
  }
}

ArrayList<Thing> Things = new ArrayList<Thing>();//how da heck i make them initial

void setup() {
  size(640,480);
  for(int i=0;i<10;i++)Things.add(new Thing());
}

void draw() {
  colorMode(ARGB);
  background(0x7F3FFF,1);
  for(Thing thang : Things) {
    thang.draw(Things);
  }
}
