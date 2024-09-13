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
color KittasCanonEyeColour = #3FDFEF; //yuh huh i do  Yesiree, this is Kitta's canon eye colour.

void setup() {
  size(400,640);
  //initialization garbage goes here
}

void draw() {
  //graphics buffer writing stuff goes here
  background(0);
  head(0,150,50,100,100);
  arm(0,135,160,-40,180);
  arm(0,265,160,40,180);
  leg(0,130,305,50,180);
  leg(0,205,305,50,180);
  body(0,130,145,140,180);
}

//individual parts of kitta go here
void head(int rot, int X, int Y, int Sx, int Sy) {
  push();
  translate(X, Y);
  rotate(rot);
  fill(240);
  rect(0,0,Sx,Sy,Sy/3);
  eye(0,Sx/15*8,Sy/15*3,-Sx/15*5,Sy/15*7,KittasCanonEyeColour,#000000);
  eye(0,Sx/15*9,Sy/15*3,Sx/15*5,Sy/15*7,KittasCanonEyeColour,#000000);
  nose(0,Sx/15*7,Sy/15*10,Sx/15*3,Sy/15);
  pop();
}

void eye(int rot, int X, int Y, int Sx, int Sy, color BCol, color ECol) {
  push();
  translate(X, Y);
  rotate(rot);
  noStroke();
  fill(BCol);
  if(Sx>0){
    rect(0,0,Sx,Sy,(abs(Sx)+abs(Sy))/8,(abs(Sx+Sy))/4,(abs(Sx)+abs(Sy))/8,(abs(Sx)+abs(Sy))/8);
  }else{
    rect(0,0,Sx,Sy,(abs(Sx)+abs(Sy))/4,(abs(Sx)+abs(Sy))/8,(abs(Sx)+abs(Sy))/8,(abs(Sx)+abs(Sy))/8);
  }
  fill(ECol);
  rect(Sx/5,Sy/5,Sx/5*2,Sy/5*3,(abs(Sx)+abs(Sy))/8);
  pop();
}

void nose(int rot, int X, int Y, int Sx, int Sy) {
  push();
  translate(X, Y);
  println(X);
  rotate(rot);
  noStroke();
  fill(0);
  triangle(0,0,Sx,0,Sx/2,Sy);
  pop();
}

void arm(float rot, int X, int Y, int Sx, int Sy) {//(rot)ation, (X)-coordinate, (Y)-coordinate, (S)ize (x), (S)ize (y)
  push();
  translate(X, Y);
  rotate(rot/360*TAU);
  fill(240);
  rect(0,0,Sx,(Sy-(1.3*abs(Sx))+(abs(Sx)/10))/2,abs(Sx/2),abs(Sx/2),abs(Sx/4),abs(Sx/4));
  rect(0,(Sy-(1.3*abs(Sx))+(abs(Sx)/20))/2,Sx,(Sy-(1.3*abs(Sx))+(abs(Sx)/10))/2,abs(Sx/4),abs(Sx/4),abs(Sx/4),abs(Sx/4));
  rect(0,Sy-(0.6*abs(Sx))-(abs(Sx)/30),Sx,0.6*abs(Sx)+(abs(Sx)/15),abs(Sx/8),abs(Sx/8),abs(Sx/3),abs(Sx/3));
  rect(0,Sy-(1.3*abs(Sx))-(abs(Sx)/30),Sx,0.7*abs(Sx)+(abs(Sx)/15),abs(Sx/8),abs(Sx/8),abs(Sx/8),abs(Sx/8));
  pop();
}

void leg(float rot, int X, int Y, int Sx, int Sy) {//(rot)ation, (X)-coordinate, (Y)-coordinate, (S)ize (x), (S)ize (y)
  push();
  translate(X, Y);
  rotate(rot/360*PI);
  fill(240);
  rect(0,0,Sx,(Sy-(0.7*abs(Sx))+(abs(Sx)/10))/2,abs(Sx/8),abs(Sx/8),abs(Sx/8),abs(Sx/8));
  rect(0,(Sy-(0.7*abs(Sx))+(abs(Sx)/20))/2,Sx,(Sy-(0.7*abs(Sx))+(abs(Sx)/10))/2,abs(Sx/8),abs(Sx/8),abs(Sx/8),abs(Sx/8));
  rect(-Sx*0.15,Sy-(0.7*abs(Sx))-(abs(Sx)/30),Sx*1.3,0.7*abs(Sx)+(abs(Sx)/15),abs(Sx/4),abs(Sx/4),abs(Sx/8),abs(Sx/8));
  pop();
}

void body(float rot, int X, int Y, int Sx, int Sy) {
  push();
  translate(X, Y);
  rotate(rot/360*PI);
  fill(240);
  rect(0,0,Sx,Sy,(abs(Sx)+abs(Sy))/8);
  fill(200);
  rect(0,Sy/3*2,Sx,Sy/3,0,0,(abs(Sx)+abs(Sy))/8,(abs(Sx)+abs(Sy))/8);
  pop();
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
  
  Man, I miss the days when I would just have the largest rant sections.
  I used to write at least 100 lines of pure nothing every project.
  It was kind of like my day to day diary of sorts, because
  I wrote a lot of stuff that was happening in my life around those times.
  I guess there's nothing stopping me right now...
  ...other than how this is probably supposed to be more professional.
  (I mean like I'm uploading this to my GitHub for everyone to see.)
  Oh well, like I actually will ever be professional. To heck with it.
  Hoo boy, this phestival sure opened my eyes like never before.
  I knew I was terrible at Phighting (the 1-2-4 KDA says it all) but
  I thought that I would have at least been a little better.
  I'm playing casual lobbies (because I am not a stinkin' pro) and
  I'm still getting destroyed. 2 games I got a <1 KDR, and those were
  played as non-support characters. I actually did better with support.
  Oh right, I almost forgot about the new character Coil.
  I knew there was gonna be a Coil before Vine Staff was added,
  because the 4 coils were one of the cornerstones of OG Roblox,
  and even Roblox today. (Although the Speed and Grav coils are most known.)
  Coil is cool, but what I don't like is how you reload to change coils.
  Just like when Sword got up/downgraded when he got the sword meter
  (and lost his old 5 shield gain per hit!), you need to press R.
  I know if it was bound to something like RMB (like Scythe),
  Coil's moveset would be a lot more barren, but still, I like to whine.
  I don't know how Coil actually plays though, following my habit of
  not playing new characters since Vine Staff. I just know basic Coil.
  The only good games I've bowled this phestival are with Sword,
  Rocket, Skate(board) and Subby(Subspace T. Mine).
  I always come in 2nd place, and justifiably so.
  In fact, if I ever MVP I will consider that a disgrace because
  that would mean that I stole so many kills (cause I suck) that
  I got to the top of the scoreboard. In my words, "I would never live it down."
  But enough about my poor performance in Phighting, you say.
  What about my own game Tophat Turmoil? My answer is "SHUT-"
  I have done approximately zero about Team Storymode 2.rbxl.
  I will do basically nothing until I catch up on my schoolwork.
  I can't catch up on my schoolwork until I stop procrastinating.
  I can't stop procrastinating until I have destressed myself.
  I can't destress myself until I finish all my schoolwork,
  as well as my online schoolwork, my game and my volunteer work.
  Well golly, you say, why the dingus do you not just get therapy?
  My answer is as good as any, and that is "I just don't care."
  Oh well, I think that, 141 lines later, I am done ranting for the day.
  I guess I will further pad this file uselessly tomorrow. Ashita ni.
  P.S. I can't wait for all my game details to leak through these rants..
  
  Oh wahoo, another programming class. I'm so thrilled(I actually am).
  But seriously, today actually is the(prob?)only day that
  I get to play twoplayergames.org for inspiration for a project.
  Of course, I actually want to work because I like programming.
  Soccer Random, a childhood game, is very fun though.
  I would make it, but I would need to learn a physics lib first.
  Y'know, I actually forgot the existence of Ctrl+T.
  I never, NEVER use autoformat because I'm stupid and stubborn.
  I like to write my code in my own stupid little style and stick with it.
  However, feel free to suggest the use of Ctrl+T if it doesn't look good.
  Or instead, you could just download the source code and processing
  then just Ctrl+T it yourself.
*/
