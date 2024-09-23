
/* Title: Iwannabeaballer *\
|* Author: Louie Wang     *|
|* Description: I wanna   *|
|* be a baller on these   *|
|* streets, scoring hoops *|
|* and, breaking ankles   *|
|* like chicken feet,     *|
|* 'cause all them ballas *|
|* got it out for me,     *|
|* 'cause they know I'll  *|
|* easily have them beat. *|
\*_Date:Sept.18,2024______*/

import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

//vegetas
int P1Pos = width/2*0x10000+(height/4*3);//you know how it goes
int P2Pos = width/2*0x10000+(height/4);//top bits columns, bottom bits rows
int BPos;// for the ball too
int BHeight;//except theres height.
PVector BMove = new PVector(0,0);//ball movement
byte BHMove = 10; //ball gravity
int PWidth = 30;
int BWidth = 25;
int HoopWidth = 50;
int Score = 0;//compressed score; top bits P1, bottom bits P2
int MaxHeight = 255;//max ball height
int HoopHeight = 100;
int PHight = 80;//hmm i wonder what this is a reference to
boolean[] Keys = new boolean[10];


void setup() {
    size(480,640);
    for(int i=0;i<Keys.length;i++) {
      Keys[i] = false;
    }
}

void draw() {
  PVector P1P = new PVector(P1Pos/0x10000,P1Pos%0x10000);//hooray for redundancy?
  PVector P2P = new PVector(P2Pos/0x10000,P2Pos%0x10000);//next time ill just merge vars
  PVector BP = new PVector(BPos/0x10000,BPos%0x10000);//smooth 12 am brain aint dealin with this
  //background with wood boards image and other stuff
  //get player inputs
  //calculate ball movements
  boolean goIn = BHeight>HoopHeight;//if the ball can go in the hoop
  BMove.mult(0.9);
  BHMove--;
  boolean P1Hit = dist(P1P.x,P1P.y,BP.x,BP.y)>PWidth+BWidth;
  boolean P2Hit = dist(P2P.x,P2P.y,BP.x,BP.y)>PWidth+BWidth;
  if(P1Hit&&P2Hit) {//double collision
    BHeight = PHight;
  }else if(P1Hit) { //oh dear i do not miss angle calculations
    //make a bmove pvector that moves in the direction of the impact please im too tired
  }else if(P2Hit) {
    
  }
  //calculate collisions
}


float getInput(boolean Player) {
  if (Player) {//player 1
    if(Keys[0]==true) {
      
    }
    if(Keys[1]==true) {
      
    }
    if(Keys[2]==true) {
      
    }
    if(Keys[3]==true) {
      
    }
  } else {//player 2
    
  }
  return 0;
}

/* yoplar yaplar
you ain't a rappa you a yappa

  Oh, but before I get more into Snowballer,
  I gotta do the planning up here.
  After all, I always plan at the top,
  and yap at the bottom.
  The game takes place in 3 dimensions,
  with a bird's eye view.
  The ball has gravity, and the hoops have height.
  The ball has to have a certain height and position
  for a basket to be scored.
  The players are circles, and when they touch the ball,
  the ball gains upward velocity,
  in addition to bouncing off the player.
  The players also have height though, so
  if the ball is too high it will sail over,
  and if it bounces on the player it just bounces.
  If the ball hits both players, it will dislodge,
  or get squeezed away, through some formula or other.
  How the ball goes in or bounces off the hoop:
  The ball must be higher than the hoop
  before the movement calculations start,
  and be lower after them.
  If the ball is within range(derived from dist()),
  it checks if the ball is in the hoop or on the hoop.
  If it's in, it's a point, but if it's on,
  it bounces off of it like the floor or a player.
  The players are shorter than the hoop,
  like how it is most of the time in real life.
  
  I think this one is a perfect place to discuss
  Snowballer, the resident winter spirit of the
  Tophat Turmoil world.
  
  Snowballer is very good at basketball, her
  accuracy coming from her years of throwing
  snowballs at small targets for fun.
  Therefore, it is no surprise that Snowballer
  will have a skin where she is the iconic Roblox
  B A L L E R
  complete with dodgeball/basketball/whatever.
  As for her lore, she grew up in a snowy village,
  the previous winter spirit passed,
  and she was chosen to be the new winter spirit.
  Now, she had no idea how to be one, so she
  wandered up into the mountains, and made it snow.
  She did that for years without knowing
  her true duties, which was to make sure that
  the winters are nice and snowy, but not too snowy.
  Now the whole seasonal spirits thing was thought up
  not by Mr. God, but by the villagers as part of
  their culture. Mr. God thought it would be
  interesting to make it come true, so he did.
  She then was found by a certain other spirit,
  and she stopped being a hermit and went back
  to living in a society.
  She then met Fireballer, the summer spirit,
  and he promptly started a rivalry.
  Emphasis on "he", because Snowballer didn't care.
  She then adopted [name TBD] for a [TBD] reason.
  And that's about it for her history.
  
  Now time for the actual usual flavoured yap.
  I haven't coded in Java in quite some time,
  so I kinda forgot ints were 32 bits and not 8.
  That 68k assembly be kicking my brain I just wanna
  move.l #'SEGA', $A14000
  although I guess that's more Genesis specific.
  On the good old 68k, there's a stack.
  I like using the stack because it is useful.
  However, to my knowledge, Java does not come
  with a stack, so I made my own.
  It's simply an int array that I push and pop from.
  So in Java, it would be Stack[SP]=Var1;SP--; to pop,
  and Stack=append(Stack,Var1);SP++; to push.
  In 68k assembly, for example,
  it's just move.l d0,--(sp) to push,
  and move.l (sp)++,d0 to pop.
  That pushes and pops d0 to and from stack.
  You can also pushpop 8 bits and 16 bits,
  or as it is known on the 68k, a byte, and a word.
  l stands for long-word, or a double-word.
  The pushpop can actually use any address pointer,
  as sp is just a7, the last address pointer.
  You can even pushpop from and to memory,
  but that is slower, and also unneccesary,
  because if it's in the stack it's being processed.
  The stack should not be used for long term stores,
  because that's what the main RAM is for.
  That's my own two cents on the stack.
  I also made a mistake while writing the 68k code,
  because since I was trying to do anything on
  the Sega Genesis, I also learned Z80 assembly.
  Oh, what a waste of time that was.
  In 68k assembly, when you execute an instruction
  requiring 2 things, the operation goes like
  Thing1 >modifies> Thing2
  since that is just a lot more logical.
  For example, moveq #69,d0 moves #69 INTO d0.
  However, on the Z80, it is reversed, such as
  Thing1 <is modified by< Thing2
  which is weird, because for example
  add a,#69 (a is a register)
  you would see this and think
  "I'm, adding a into #69? That's not an address!"
  but it is actually adding a WITH #69.
  So over some days, I came up with an easy way
  to remember that the Z80 is backwards.
  On the 68k, I think I moveq #69 INTO d0,
  and on the Z80, I think I ld a WITH #69.
  (ld is the LoaD instruction by the way)
  However, there are niceities to the Z80.
  There is an entire other set of registers,
  that you can swap out to use.
  The bytecode for the Z80 is also easier to read,
  way, WAY easier than the 68k's.
  The Z80 uses 1 or 2 bytes to define instruction,
  and the bytes that follow as operands.
  They are also in order.
  The 68k uses a whole mishmash of bits
  and is just so hard to read.
  As if I was reading it though,
  I only do it so I don't have to use
  a hex editor to manually insert my Z80 code
  as raw hex so it can load with the 68k.
  I remember making a small, small demo
  for the Sega Genesis that I wrote myself.
  I didn't follow a demo making tutorial.
  It was simply moving a crosshair around
  with the D-Pad, while the buttons control speed.
  The Start button changed background colour
  every frame, so it looked like a seizure.
  Nowadays, I wouldn't try to make a Genesis game.
  However, I love making chiptunes.
  But ho! I have wrote too much for now.
  I will save that for next time.
  Look forwards to hearing about Rhythmgunner's
  past as well! Till next time.
  
  Personal bit here,
  I swear I will stop fooling around in my code.
  This is actually gonna make me go insane or smth.
  I have so much in my code that is just useless.
  So now I think I will be moving this stuff
  to a new special folder in the repo
  for rants and stuff like this
  just like in my roblox games.
  Hooray for bored me.
*/
