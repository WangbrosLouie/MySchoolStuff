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
int[] Buttons = {50,height/2,25,1,width-50,height/2,25,2};; 
boolean wasPressed = false;
boolean DrawButs = true; //draw buttons
boolean Outlines = true;
void setup() {
  size(640,480);
//  Buttons 
}

void draw() {
  //draw the patterns here and the buttons to
  push();
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
    if(Outlines)stroke(0);else noStroke();
    for(float i=-1;i<SV2;i++) {
      for(float j=0;j<SV1;j++) {
        float Angle = j/SV1*TAU; //who here uses TWO_PI anyways? Also this is wrong but it works, so if it aint broke don't fix it?
        push();
        colorMode(HSB);
        rotate(Angle);//see, I could just rotate this by a fixed value by moving the pushpop to the outside of this nested for(){} nightmare
        float Yoff = PPC*(j/SV1+i); //Y-offset
        fill((frameCount+(i*SV1+j))%127*2,255,255);
        rect(-Longest/2,Yoff,Longest,Longest);
        pop();
      }
    }
    break;
  case 1:
    break;
  }
  pop();
  processButtons(Buttons);
}

void keyPressed() {
  println(keyCode);
  switch(keyCode){
  case 38:
    SV1++;
    break;
  case 40:
    if(SV1>1)SV1--;
    break;
  case 37:
    if(SV2>2)SV2--;
    break;
  case 39:
    SV2++;
    break;
  case 32:
    Outlines = !Outlines;
    break;
  }
}

void processButtons(int[] Btns) { //simple button processor
  if(mousePressed&&!wasPressed) {
    for(int i=0;i<Btns.length/4;i++) {
      if(dist(mouseX,mouseY,Btns[i*4],Btns[i*4+1])<Btns[i*4+2]) {
        switch(Btns[i*4+3]){
        case 1:
          Mode=(Mode<=1)?3:Mode-1;
          break;
        case 2:
          Mode=(Mode>=3)?1:Mode+1;
          break;
        }
        fill(127);
      } else fill(255);
      push();
      ellipseMode(CENTER);
      circle(Btns[i*4],Btns[i*4+1],Btns[i*4+2]);
      pop();
    }
  wasPressed = true;
  } else {
    fill(255);
    push();
    ellipseMode(CENTER);
    for(int i=0;i<Btns.length/4;i++){circle(Btns[i*4],Btns[i*4+1],Btns[i*4+2]);println(Btns[i*4],Btns[i*4+1],Btns[i*4+2]);}
    pop();
    if (!mousePressed&&wasPressed) {
      wasPressed = false;
    }
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
  
  Okay, now that I have learned how to merge,
  naturally a rant follows.
  The whole merge business happened because somehow,
  I managed to have time travelled or something,
  as 2 days ago, my computer had the version that
  I thought was gone, but then just this morning,
  I yapped about phighting in this file on the same
  PC, the SAME PC that I used to make the original one,
  but somehow the changes weren't here when I was yapping.
  Then come afterschool, I decide to do a git pl
  since I thought that the original file was kaput,
  but then it told me that there were conflicts,
  and alakazam, the original file somehow reappears here?
  Mind you that I edited the SAME file on the SAME PC
  and this happens somehow. Crazy business.
  Anyhoo, I have english homework to attend to, so 'til next line.
  
  Oh man. I haven't finished the homework because of golf.
  I got coaching from a special someone and it worked wonders.
  My fingers hurt so bad from gripping the club that is isn't even funny.
  It genuinely hurts to grab something with my left hand.
  Almost like the burn on my tongue from eating a fish cake.
  For those of you who think that I ate a cake made of fish,
  what a fish cake actually is is fish tofu, or just blocks of fish.
  It tastes amazing, but it sure wallopped my taste buds with heat.
  I wonder why creative writing is so easy compared to english class.
  Maybe I should take composition next year instead of my current english.
  Man, maybe I should just become a storywriter. It seems so easy.
  I can just plop out a story so fast and just detail it to smithereens.
  Like for example, the first time that Rhythmgunner met Bassblaster.
  They met under a bridge, Bassblaster got shocked over his loss of fame,
  they went to a factory to get a cd press(why i wonder),
  Rhythmgunner met Speedshooter there, yaddayaddayadda
  I mean it's not the best of stories but it's good enough for now.
  I wonder if I will find any success in the computing industry.
  I like computers because I grew up with them, and I mean grew up.
  My first independent usage of electronics as far as I can remember,
  is with a 60ish inch CRT and a DVD player. I could load the DVDs myself.
  I ended up breaking it though because it just sat on top of the TV
  without anything stopping it from falling off, and I pushed it too hard.
  We also had a computer that I unfourtunately threw away years ago.
  It was a perfectly fine XP machine that had a DVD drive and card readers.
  I probably toggled a BIOS setting that made the hard drive unbootable,
  and then we tossed it thinking it was kaput.
  We kept the hard drive and the RAM(for some reason)from it,
  as well as the keyboard, mouse, monitor, and install DVDs.
  The monitor has since broken due to decay, and the mouse due to fraying.
  However, the keyboard I am using right now is that same keyboard.
  I can't imagine switching to a low profile keyboard.
  It just doesn't have that same key depth and that press feeling.
  Surprisingly, the NumLock LED hasn't burned dim yet,
  despite me having NumLock on 100% of the time.
  Guess they used to make these different. Now, they don't even give
  NumLock LEDs or Scroll Lock LEDs on some keyboards.
  Anyways, since I'm procrastinating this much already,
  time to leak more Tophat Turmoil stuff. Yippee hooray.
  I still (unsurprisingly) do not have the time to work on it.
  I just come up with lore too often, like waaay too often.
  For example, Kitta's facility is now a lab and instead of being
  embedded in a forest, it is now embedded in a cave.
  I have thought of lucid gifs of the game, with Kitta's shining
  blue eyes, the light peering through the cave roof, the water
  shining as it ripples, the dust dancing in the air.
  Hooray for figurative language. The personifications run wild.
  About Tophat Turmoil, since I'm expecting that you have seen
  absolutely zero of my planning stuff(since you SHOULDN'T have
  access to that kind of stuff anyways-it's private), I will
  tell stuff from the beginning of the story.
  First, there's Kitta's game, but I'm not gonna detail it much.
  Kitta wakes up to a robot free world, and convinces society to
  re-adopt robots as a part of society rather than a tool.
  Short break here, HOLY HECK I HAVE WRITTEN 3 TIMES TEXT THAN CODE.
  Is that how to grammar it correctly? I kinda forgot.
  At this point I should just make a subfolder in the repository
  that just is this stuff, because that would probably be like,
  50% of the data in the repo? That's what I estimate.
  I know I'm not supposed to write nearly this much
  (heck, I'm not supposed to write this stuff AT ALL)
  but it is just so relieving, like a load off my back or something.
  Anyways, back to Tophat Turmoil, after Kitta's story,
  there's about 10 years until the first Tophat Turmoil game,
  (which is actually the second) Tophat Turmoil -Prequel-.
  In it, you get to do a converging story mode, where you get to
  choose a character's story, and it starts with that character,
  then it merges with another's story, and that until it becomes one.
  Basically aliens from outer space invaded the Earth when they
  shouldn't have, because Mr. God(the god of the T.T. universe)
  expresses displeasure on learning about this fact, and the
  Tophat Turmoilers(better name pending) set off to save the world.
  Then, after that, about 3 or so months (yes, months) after that,
  a villain called Evyle wants to take over the world, inspired
  by those aliens. He makes a fortress in the mountains,
  makes many robot minions, and makes a weaponized duplicate of Kitta.
  Now if that sounds familliar, it's probably because I might have been
  unconsciously influenced by Sonic the Hedgehog, a game series that
  I like more than Mario. Dr. Eggman makes bases in mountains,
  makes many robot minions and made Metal Sonic, a weaponized robotic
  duplicate of the titular character of the series.
  So anyways, the Turmoilers have to make it from Rhythmgunner's
  apartment(where they were partying)to the Evylair, Evyle's base.
  They manage to do so, defeating some boss-robots on the way.
  The ending depends on if you get all the things for [name TBD]
  to make a toy of Kitta or not. [name TBD](or TB for short) is
  a boy who can make a magic pencil with his mind to draw things
  into the real world. He likes robots, and was sad his Kitta toy broke.
  If the toy is not made, you battle DarKitta, then Evyle in his
  control room while avoiding the death traps and such.
  The story ends with the Turmoilers returning to the city after
  the victory. But that's not the true ending, because of DarKitta.
  If you make the you when you reach the Evylair boss room,
  [name TBD] shows the toy to DarKitta, and explains that Kitta is
  a friendly robot who likes to make children happy, and DarKitta
  looks exactly like her. DarKitta then argues with Evyle,
  since Evyle has always told DarKitta that she is the "perfect
  fighting machine", only to be modelled after a childrens' toy.
  This makes DarKitta fight against Evyle with the Turmoilers,
  then when Evyle is defeated, DarKitta goes with them to find out
  more about Kitta, since she was curious about her.
  Then the last(planned)game is now called Tophat Tournament,
  previously Tophat Turmoil. It is now at least 1 month after all
  of that, and Mr. God believes that he has found the cure to his
  seemingly endless boredom.
*/
