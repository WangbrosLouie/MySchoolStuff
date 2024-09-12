/* Title: Iwannadrawkitta *\
|* Author: Louie Wang     *|
|* Description: yay, time *|
|* to draw my favourite   *|
|* robot cat from T.T. :3 *|
|* nyanyanyanya:3:3:3:3:3 *|
\*_Date:Sept.10,2024______*/
//PS that :3 was obligatory
//PPS those cat whatevers too

//variables go here (do i even need variables?)

void setup() {
  size(400,640);
  //initialization garbage goes here
}

void draw() {
  //graphics buffer writing stuff goes here
  background(0);
  head(0,150,0,100,100);
  eye(0,0,0,50,75,#307fFF,#000000);
  //arm(0,100,100,-40,200);
  leg(0,100,100,40,200);
}

//individual parts of kitta go here
void head(int rot, int X, int Y, int Sx, int Sy) {
  translate(X, Y);
  rotate(rot);
  rect(0,0,Sx,Sy,Sy/3);
}

void eye(int rot, int X, int Y, int Sx, int Sy, color BCol, color ECol) {
  push();
  translate(X, Y);
  rotate(rot);
  noStroke();
  fill(BCol);
  rect(0,0,Sx,Sy,(Sx+Sy)/8,(Sx+Sy)/4,(Sx+Sy)/8,abs(Sx+Sy)/8);
  fill(ECol);
  rect(Sx/11*3,Sy/5,Sx/9*5,Sy/5*3,abs(Sx+Sy)/8);
  pop();
}

void arm(float rot, int X, int Y, int Sx, int Sy) {//(rot)ation, (X)-coordinate, (Y)-coordinate, (S)ize (x), (S)ize (y)
  translate(X, Y);
  rotate(rot/360*TAU);
  rect(0,0,Sx,(Sy-(1.3*abs(Sx))+(abs(Sx)/10))/2,abs(Sx/2),abs(Sx/2),abs(Sx/4),abs(Sx/4));
  rect(0,(Sy-(1.3*abs(Sx))+(abs(Sx)/20))/2,Sx,(Sy-(1.3*abs(Sx))+(abs(Sx)/10))/2,abs(Sx/4),abs(Sx/4),abs(Sx/4),abs(Sx/4));
  rect(0,Sy-(0.6*abs(Sx))-(abs(Sx)/30),Sx,0.6*abs(Sx)+(abs(Sx)/15),abs(Sx/8),abs(Sx/8),abs(Sx/3),abs(Sx/3));
  rect(0,Sy-(1.3*abs(Sx))-(abs(Sx)/30),Sx,0.7*abs(Sx)+(abs(Sx)/15),abs(Sx/8),abs(Sx/8),abs(Sx/8),abs(Sx/8));
}

void leg(float rot, int X, int Y, int Sx, int Sy) {//(rot)ation, (X)-coordinate, (Y)-coordinate, (S)ize (x), (S)ize (y)
  translate(X, Y);
  rotate(rot/360*PI);
  rect(0,0,Sx,(Sy-(0.7*abs(Sx))+(abs(Sx)/10))/2,abs(Sx/8),abs(Sx/8),abs(Sx/8),abs(Sx/8));
  rect(0,(Sy-(0.7*abs(Sx))+(abs(Sx)/20))/2,Sx,(Sy-(0.7*abs(Sx))+(abs(Sx)/10))/2,abs(Sx/8),abs(Sx/8),abs(Sx/8),abs(Sx/8));
  rect(-Sx*0.15,Sy-(0.7*abs(Sx))-(abs(Sx)/30),Sx*1.3,0.7*abs(Sx)+(abs(Sx)/15),abs(Sx/4),abs(Sx/4),abs(Sx/8),abs(Sx/8));
}

/*yap section(also obligatory)
  
  i guess its finally come to this.
  i make a complete picture of non roblox kitta
  for the first time(digitally).
  i just wrote all the program structure comments
  so i dont know how long it will take me.
  i guess i just gotta know when to stop.
  anyways time to git add "iwannadrawkitta"&&git commit&&git push
  
  oh dear how far behind am i again
  
  3 projects 1 day no problemo thats cap oh dear
  yowies the arms and legs look nice now hooray
  anyways time to git aas&&git cips
  except cips DOESNT #@%^$@#^ WORK I HATE GIT(and by extension bash)
  aas is Add All and Status and cips is CommIt and PuSh 
  fr this why i never use cips i only do it in a rush
  not that i ever actually have used it before
  where the binary coded decimals >:(
  i wanna do the easiest to remember instruction in the
  whole 68k instruction set, Add Binary Coded Decimal (ABCD)
  and besides, a lot easier to understand than
  10-bit 3 digit numbers (do those even exist?)
*/
