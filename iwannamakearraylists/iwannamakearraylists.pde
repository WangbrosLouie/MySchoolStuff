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
    S = round(random(10,40));
    D = PVector.fromAngle(random(0,TAU));
  }
  void draw(ArrayList<Thing> Stuff) {
    P.add(D);
    if(P.x<0||P.x>width){P.x = constrain(P.x,0,width);D.x = -D.x;}
    if(P.y<0||P.y>width){P.y = constrain(P.y,0,width);D.y = -D.y;}
    circle(P.x,P.y,S);
    for (Thing thin : Stuff) {
      float dist = P.dist(thin.P)*5;
      push();
      stroke(255,255-dist);
      line(P.x,P.y,thin.P.x,thin.P.y);
      pop();
    }
  }
  
}

ArrayList<Thing> Things = new ArrayList<Thing>();

void setup() {
  size(640,480);
}

void draw() {
  
}
