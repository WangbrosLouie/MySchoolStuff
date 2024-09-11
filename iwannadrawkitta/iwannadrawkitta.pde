/* Title: Iwannadrawkitta *\
|* Author: Louie Wang     *|
|* Description: yay, time *|
|* to draw my favourite   *|
|* robot cat from T.T. :3 *|
\*_Date:Sept.10,2024______*/
//PS that :3 was obligatory

//variables go here (do i even need variables?)

void setup() {
  size(400,640);
  //initialization garbage goes here
}

void draw() {
  //graphics buffer writing stuff goes here
  background(0);
  arm(frameCount,100,100,50,200);
}

//individual parts of kitta go here
void head(int rot, int X, int Y, int Sx, int Sy) {
  translate(X, Y);
  rotate(rot);
  rect(0,0,Sx,Sy,20,20,20,20);
}

void arm(float rot, int X, int Y, int Sx, int Sy) {//(rot)ation, (X)-coordinate, (Y)-coordinate, (S)ize (x), (S)ize (y)
  translate(X, Y);
  rotate(rot/360*PI);
  rect(0,0,Sx,(Sy/2)-((3*Sx)/8)+(Sx*1/19),Sx/2,Sx/2,Sx/4,Sx/4);
  rect(0,(Sy/2)-((3*Sx)/8)-(Sx*1/19),Sx,(Sy/2)-((3*Sx)/8)+(Sx*2/19),10);
  rect(0,Sy-((3*Sx)/4),Sx,(3*Sx)/4,10,10,20,20);
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
*/
