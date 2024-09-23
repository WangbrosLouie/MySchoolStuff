
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
int P1Pos;//you know how it goes
int P2Pos;//top bits columns, bottom bits rows
int BPos;// for the ball too
byte BHeight;//except theres height.
PVector BMove;//ball movement
byte BHMove; //ball gravity
int PWidth = 30;
int BWidth = 25;
int HoopWidth = 50;
int Score;//compressed score; top bits P1, bottom bits P2
int MaxHeight = 255;//max ball height
int HoopHeight = 100;


void setup() {
    size(480,640);
}

void draw() {
  //background with wood boards image and other stuff
  //get player inputs
  //calculate ball movements
  boolean goIn = BHeight>HoopHeight;//if the ball can go in the hoop
  BMove.mult(0.9);
  BHMove--;
  boolean P1Hit = dist(P1Pos/0x10000,P1Pos%0x10000,BPos/0x10000,BPos%0x10000)>PWidth+BWidth;
  boolean P2Hit = dist(P2Pos/0x10000,P2Pos%0x10000,BPos/0x10000,BPos%0x10000)>PWidth+BWidth;
  //calculate collisions
}


float getInput(boolean Player) {
  if (Player) {//player 1
    
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
*/
