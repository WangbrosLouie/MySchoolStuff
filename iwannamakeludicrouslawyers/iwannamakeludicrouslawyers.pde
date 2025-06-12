/* Title: Iwannamakeludisrouslawyers *\
|* Author: Louie Wang                *|
|* Description: my cool scratch game *|
\*_Date:_Apr._15,_2025_______________*/

class Sprite {
  int x;
  int y;
  PImage pic;
  int link;//just like the sega genesis's vdp
  int count = 0; //frame counter
  
  Sprite(int X, int Y, PImage PIC, int LINK) {
    x = X;
    y = Y;
    pic = PIC;
    link = LINK;
  }
}

int background = 0;
Sprite[] drawList = new Sprite[0];
float gameSpeed = 1.0;
float delta = 0.0;
int anim1 = 0;//main sprite thing
int anim2 = 0;//background i guess
int g = 0;

void settings() {
  size(640,480,P2D);
}

void setup() {
  
}

void draw() {
  //for(int i=0;i<drawList.length;i++) {
  //  image(drawList[i].pic,drawList[i].x,drawList[i].y);
  //}
  delta += gameSpeed;
  while(delta>0) {
    delta -= 1;
    game();
  }
  switch(background){
  case 0:
    background(200);
    break;
  default:
    background(0);
  }
  if(drawList.length>0) {
    int cur = 0;
    while(cur!=-1) {
      image(drawList[cur].pic,drawList[cur].x,drawList[cur].y);
    }
  }
}

void game() {
  switch(g) {
  case 0:
  //the circle doesnt circle
    circle(10,10,10);
    break;
  default:
    //please put a blue screen here
  }
}

/*woo hoo the comment section back baby
Draw Cycle
every draw cycle the background will be drawn.
linked sprite in the sprites list are also drawn.
here the original i made
https://scratch.mit.edu/projects/811317148/
im gonna either use
1. a thread for the main function so that
oopsie i forgot to finish writing this stuff
continuing from before...
the game can run while it draws
2. a seperate game function every draw
3. the "shove everything into draw and hope i can read it a few days later" tactic
im just gonna use the second way
*/
