/* Title: Iwannamakepatterns *\
|* Author: Louie Wang        *|
|* Description: processing   *|
|* asked how many patterns   *|
|* will you make and the     *|
|* programmer said "yes"     *|
\*_Date:Sept.11,2024_________*/

//jk im not makin crap probs

//vegetables
int Mode = 0;
int SV1 = 10;
int SV2 = 12;

void setup() {
  size(640,480);
}

void draw() {
  //draw the patterns here and the buttons to
  switch(Mode){//why the dingus does processing autoformat the switch case to be so hard to read? do people actually write them that way? OG Comment: seriously, why don't people write switch cases like this? It's so much easier to read.
  case 0://rectanglopulous; SV1 = number of rects per ring, SV2 = number of rings OG Comment: image 1: coloured rect whirlpool thingy
  translate(width/2,height/2);
    float PPC; //Pixels Per Circle, not PowerPC
    int Longest;
    if(width>height){
      Longest = width;
    }else{
      Longest = height;
    }
    PPC = Longest / (SV2-1);
    for(float i=0;i<SV2;i++) {
      for(float j=0;j<SV1;j++) {
        float Angle = j/SV1*TAU; //who here uses TWO_PI anyways? Also this is wrong but it works, so if it aint broke don't fix it?
        push();
        colorMode(HSB);
        rotate(Angle);//see, I could just rotate this by a fixed value by moving the pushpop to the outside of this nested for(){} nightmare
        float Yoff = PPC*(j/SV1+i); //Y-offset
        fill((frameCount+(i*SV1+j))%255,255,255);
        rect(-Longest/2,Yoff,Longest,Longest);
        pop();
      }
    }
    break;
  case 1:
    break;
  }
}

/* yup section

  heyo, I'm not even finished my last project yet.
  Actually I haven't even started this one.
  I just want to note down that I want to make a
  golf game for the twoplayergames thingy.
  It's gonna be like the EA golf games on the GB.
  
  Okay, so maybe I will do a twoplayergames game.
  I actually don't think the golf game will be
  fitting of the criteria.

  Ok, even though this isnt the file with the yap,
  I'm going to record my thoughts on the Phestival,
  just so I can learn to merge changes and so I
  don't forget about it like the idiot I am.
  The Phestival ended at 9:23 PM yesterday,
  while I was marvelling at how a skateboard and
  a shuriken managed to get on the lost temple tunnel.
  Needless to say, team pirate won, maybe since
  it was the most popular team (probably).
  We won 6 of the 8 categories, with the first half
  being fully won by the pirates, which meant
  the scoring for the first half was 40-0, with
  10 points per category. The second half,
  it became 80-40 because it was 20 points per.
  The reward skin was Coil 2.0, which I IMMEDIATELY
  called "Coilgraft" because it looked like Coil
  was a Biograft, kinda.
  Anyways, I only found 2 other skins in the lobby.
  The first one was Steampunk(?) Scythe, who now
  occupies the murder apartment room. Obviously,
  I did not buy since I don't play Scythe.
  *catshot intensifies*
  The other one was on the flingy cheese side
  of the Rat Zone. Now, I thought the skin was like
  Piratekit 2.0 or something, because in the game
  icon and banner, it looked like it was Medkit.
  However the skin turned out to be Captain Rocket,
  which I bought anyway because cool rocket skin.
  Now I am only 32k bux poorer since the phestival
  awarded a whopping 3k bux to me for winning.
  Or maybe I read the price wrong and it was 32k bux.
  Anyways I gotta go to school cause school.
  I'm gonna learn how to merge no matter what.
  
  GRRRR it didn't save my work so I have to rewrite
  all of the yap manually. i hate this game
  At least I learned how to merge things.
  Or not really, but oh well, good enough for now.
  Holy heck, the bad piggies tusk till dawn theme is
  straight fire, head banger, super bop, turbo beat.
  I made the last 2 up, but this song is so good.
  Especially the perfect loop made from the game file.
  It's not like sonic mania where it's looped in software.
  The song was just baked as a perfect looping song.
  And now, I'm making a planning section just like old times.
  Also known as I'm too stupid to do this all in my head.
  
  Plannings upon thy wheels of colour:
  SV1 is for how many rects are per full circle of the pattern.
  SV2 is for how many full circles to draw in the pattern.
  Every rect gets offset Y-wise based on which rect it is.
  The function find out if width or height is longest,
  then it makes the thickness of a full circle into
  SV2-1 divided by width or height. This makes it draw offscreen.
  The rotation per rect is already figured out.
  The colour will be frameCount+(i*SV1+j) to cycle.
  Man, I miss programming for the Sega Genesis...
  At this point I feel like I'm writing a periodical
  rather than a computer program. I mean,
  the amount of lines that I have wrote down here
  is more than the lines of code that I wrote up there.
  Maybe I should just start a blog or something.
  Also, MisakiGothic(or Mincho) is crazy at 8pt.
  I think I should start using git for Tophat Turmoil.
  It is just more useful and stuff because
  I don't have to rely on OneDrive's version history.
  I mean, it deletes them after 90 days, so I should git.
*/
