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

//vegetas
int P1Pos;//you know how it goes
int P2Pos;//top bits columns, bottom bits rows
int BPos;// for the ball too
byte BHeight;//except theres height.
int Score;//compressed score; top bits P1, bottom bits P2

void setup() {
    size(480,640);
}

void draw() {
  
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
  
  I think this one is a perfect place to discuss
  Snowballer, the resident winter spirit of the
  Tophat Turmoil world.
  
  Snowballer is very good at basketball, her
  accuracy coming from her years of throwing
  snowballs at small targets for fun.
*/
