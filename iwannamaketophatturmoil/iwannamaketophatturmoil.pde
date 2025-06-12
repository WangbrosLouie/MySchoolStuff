/* Title: Iwannamaketophatturmoil *\ //<>//
|* Author: Louie Wang             *|
|* Description: woo my unreleased *|
|* game that i havent started     *|
|* working on yet has moved from  *|
|* the sega genesis to processing *|
\*_Date:_Nov.1,_2024______________*/

/* bugs list
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Libraries
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import fisica.*;
import processing.sound.*;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Variables
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Game Control and Parameters
int mode = 0;
boolean loading = true;
boolean drawing = false;
boolean debug = false;
boolean textures = true;
boolean backgnd = true;
boolean halfFPS = false;
boolean buttonsEnabled = false;
byte mapNum = 2;
float scl = 1; //render scale
PVector playerVec, camVec;
boolean camDir = true;
//  Map Variables and Assets
String[] maps = new String[]{"map02ext.lvl","map05.lvl","kit/01.lvl"};
byte[] mapData;
String mapName;
Gif[] tex = new Gif[255];
Gif bg;
color backcolour = color(0);
SoundFile[] mus = new SoundFile[4];
Gif[] dial = new Gif[254];
Dialog[][] talks;
int dialNum = -1;
int subDialNum = 0;
int talkTimer = 0;
PFont lucid;
byte[] keys = new byte[13];
//  Physics Variables
FWorld world;
FCompound[] chunks;
player you;
ArrayList<Entity> entities = new ArrayList<Entity>();
ArrayList<Projectile> projs = new ArrayList<Projectile>();//projectiles
PApplet dis = this;//for referencing inside of classes
//  Miscellaneous Variables
PGraphics Hitbox;
int Btn = 0;
Button[] buttonList = new Button[]{};
int[] buttonDraw = new int[]{};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Classes
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Gif extends PImage { //make custom loop points
  int frames = 0;//also custom frame orders
  float currentFrame = 0;
  float interval = 0;
  PImage[] images;
  Gif(int FRAMES, float INTERVAL, String filename, String suffix) {
    super(1,1,ARGB);
    frames = FRAMES;
    interval = INTERVAL;
    images = new PImage[frames];
    if(frames>1){
      for(int i=0;i<frames;i++)images[i] = loadImage(filename+i+suffix);
    } else images[0] = loadImage(filename+suffix);
    super.init(images[0].width,images[0].height,images[0].format);
    images[0].loadPixels();
    super.loadPixels();
    arrayCopy(images[0].pixels,super.pixels);
    images[0].updatePixels();
    super.updatePixels();
  }
  
  Gif(float INTERVAL, String[] filenames) {//gonna make the character files laters
    super(1,1,ARGB);
    frames = filenames.length;
    interval = INTERVAL;
    images = new PImage[frames];
    if(frames>1){
      for(int i=0;i<frames;i++)images[i] = loadImage(filenames[i]);
    } else images[0] = loadImage(filenames[0]);
    super.init(images[0].width,images[0].height,images[0].format);
    images[0].loadPixels();
    super.loadPixels();
    arrayCopy(images[0].pixels,super.pixels);
    images[0].updatePixels();
    super.updatePixels();
  }
  
  Gif() {
    super(1,1,ARGB);
    frames = 1;
    interval = 1;
    images = new PImage[]{new PImage(1,1,ARGB)};
  }
  
  void update() {
    if(images.length>1) {
      currentFrame+=interval;
      int frm = floor(currentFrame)%frames;
      super.init(images[frm].width,images[frm].height,images[frm].format);
      images[frm].loadPixels();
      super.loadPixels();
      arrayCopy(images[frm].pixels,super.pixels);
      images[frm].updatePixels();
      super.updatePixels();
    }
  }
  
  void updatePlayer(boolean dir) {//special for turning gifs
    if(images.length>1) {//advance that gif
      currentFrame+=interval;
    }
    int frm = floor(currentFrame)%frames;//what frame is it mr wolf
    super.init(images[frm].width,images[frm].height,images[frm].format);
    images[frm].loadPixels();
    super.loadPixels();
    arrayCopy(dir?images[frm].pixels:flipImagePix(images[frm]),super.pixels);
    images[frm].updatePixels();
    super.updatePixels();
  }
  
  void updatePlayer(float speed, boolean dir) {//special for turning gifs
    if(images.length>1) {
      currentFrame+=speed;
    }
    int frm = floor(currentFrame)%frames;
    super.init(images[frm].width,images[frm].height,images[frm].format);
    images[frm].loadPixels();
    super.loadPixels();
    arrayCopy(dir?images[frm].pixels:flipImagePix(images[frm]),super.pixels);
    images[frm].updatePixels();
    super.updatePixels();
  }
  
  void reset() {//reset to frame 1
    if(images.length>1) {
      currentFrame=0;
    }
    int frm = floor(currentFrame)%frames;
    super.init(images[frm].width,images[frm].height,images[frm].format);
    images[frm].loadPixels();
    super.loadPixels();
    arrayCopy(camDir?images[frm].pixels:flipImagePix(images[frm]),super.pixels);
    images[frm].updatePixels();
    super.updatePixels();
  }
  
  void resizeGif(int x, int y) {
    for(PImage pic:images) {
      pic.resize(x,y);
    }
  }
}

class player extends FBox {
  int health = 5;
  Gif[] anim = new Gif[]{new Gif(2.0/60,new String[]{"spr/ka0.png","spr/ka1.png","spr/ka2.png","spr/ka1.png"}),new Gif(2.0/60,new String[]{"spr/ka0.png","spr/kb0.png","spr/kb1.png","spr/kb0.png"}),new Gif(5.0/60,new String[]{"spr/kc.png"})};
  SoundFile[] snd = new SoundFile[]{new SoundFile(dis,"snd/kwlk.wav"),new SoundFile(dis,"snd/kjmp.wav"),new SoundFile(dis,"snd/khrt.wav")};
  int animNum = 0; //which animation to play
  int invince = 0; //invincible until this frame
  int stunned = 0; //stunned until this frame
  int[] animLookup = {0,1,2,0,0};
  int[] sndLookup = {0,1,2,0,0};
  int talkIndex = -1;
  
  player(int HEALTH, float x, float y) {//placeholder for now
    super(32,64);
    health = HEALTH;
    java.util.Arrays.fill(anim, new Gif(2.0/60,new String[]{"spr/ka0.png","spr/ka1.png","spr/ka2.png","spr/ka1.png"}));
    anim[1] = new Gif(2.0/60,new String[]{"spr/ka0.png","spr/kb0.png","spr/kb1.png","spr/kb0.png","spr/ka0.png","spr/kb2.png","spr/kb3.png","spr/kb2.png"});
    anim[2] = new Gif(5.0/60,new String[]{"spr/kc.png"});
    super.attachImage(anim[0]);
    super.setPosition(x,y);
    super.setRotatable(false);
    super.setFriction(100);
    super.setName("00");
  }
  
  player(int HEALTH, float x, float y, byte[] fichier) {//and the one taking its place now
    super(32,64);
    health = HEALTH;
    int what = -1;
    while(what!=0) {
      what = 0;
      
    }
    java.util.Arrays.fill(anim, new Gif(3,2.0/60,"spr/ka",".png"));
    anim[1] = new Gif(3,5.0/60,"spr/kb",".png");
    anim[2] = new Gif(1,5.0/60,"spr/kc",".png");
    super.attachImage(anim[0]);
    super.setPosition(x,y);
    super.setRotatable(false);
    super.setFriction(100);
    super.setName("00");
  }
  
  byte[] process(byte[] keys) { //change this stuff so the pointers work
    ArrayList<FBody> touchings = super.getTouching();//super.getContacts();
    keys[3] = 1;
    float oldSpeed = super.getVelocityX();
    float massy = 1.0;
    
    for(int i=touchings.size()-1;i>-1;i--) {
      String name = touchings.get(i).getName();
      String[] names = name!=null?splitTokens(name,","):new String[]{"0"};
      int flags = unbinary(names[0]);
      //if(flags%0x2/1>0) bittest template
      if(flags%0x2/1>0)keys[3] = 0;
      if(flags%0x4/2>0)hurt(1);
      if(flags%0x8/4>0&&frameCount!=0)mode=3;
      //make dat unstatic thingy
      if(flags%0x20/0x10>0)touchings.remove(i);
      if(flags%0x40/0x20>0)massy = 2;
      if(names.length>1) {
        for(int j=1;j<names.length;j++) {
          switch(names[j].getBytes()[0]) {
          case 'S'://peech
            int index = int(names[j].substring(names[j].indexOf(':')+1));
            if(talkIndex!=index){//||talkTimer<0){
              index = talkIndex;
              dialNum = int(names[j].substring(1));
              subDialNum = -1;
              talkTimer = 0;
            }
            break;
          case 'T'://eleport
            break;
          }
        }
      }
    }
    super.setDensity(massy); //nvm me stupid
    if(touchings.size()==0)keys[3]=2;
    if(debug)keys[3]=0;
    if(abs(super.getVelocityX())>100)animNum = animLookup[2];//if moving but no inputs
    if(stunned<=frameCount) {
      if(!((keys[0]>1)&&(keys[1])>1)) {
        if(keys[0]>1) {
          if(super.getVelocityX()>200)super.setVelocity(super.getVelocityX()-100,super.getVelocityY());//super.addForce(-5000,0);
          else super.setVelocity(-200,super.getVelocityY());
          camDir = false;
          animNum = 1;
          if(keys[3]==2){animNum = 2;snd[sndLookup[0]].stop();}
          else{animNum=1;if(!snd[sndLookup[0]].isPlaying())snd[sndLookup[0]].play();}
        } else if(keys[1]>1) {
          if(super.getVelocityX()<-200)super.setVelocity(super.getVelocityX()+100,super.getVelocityY());//super.addForce(5000,0);
          else super.setVelocity(200,super.getVelocityY());
          camDir = true;
          animNum = 1;
          if(keys[3]==2){animNum = animLookup[2];snd[0].stop();}
          else{animNum=1;if(!snd[0].isPlaying())snd[0].play();}
        } else {
          super.addImpulse(-super.getVelocityX()/5,0);
          snd[sndLookup[0]].stop();
          if(keys[3]==2)animNum = 2;
          else animNum=0;
        }
      }
      if(keys[2]>1&&keys[3]==0) {
          keys[3] = 1;
          super.setVelocity(super.getVelocityX(),-200);
          animNum = animLookup[2];
          snd[0].stop();
          snd[1].stop();
          snd[1].play();
      }
    }
    switch(animNum) {
    case 1:
      anim[animLookup[animNum]].updatePlayer(abs(oldSpeed)/1500,camDir);
      break;
    default:
      anim[animLookup[animNum]].updatePlayer(camDir);
    }
    super.attachImage((invince>frameCount)&&(frameCount%4>1)?new PImage(0,0,RGB):anim[animLookup[animNum]]);
    for(int i=0;i<keys.length;i++)if(keys[i]==1)keys[i]=2;
    return keys;
  }
  
  void hurt(int dmg) {
    if(invince<=frameCount) {
      animNum = 4;
      invince = frameCount + 120;
      stunned = frameCount + 30;
      health -= dmg;
      snd[2].play();
    }
  }
}

class Particle extends FBox {
  float originY;
  Particle(float x, float y, float size, color colour, float veloW, float veloH) {
    super(size,size);
    super.setPosition(x,y);
    super.setNoStroke();
    super.setFill(colour);
    super.setDensity(100);
    super.setVelocity(veloW,veloH);
    super.setSensor(true);
    originY = y;
    world.add(this);
  }
  
  int process() {
    if(super.getY()>originY+2) {
      return this.destroy();
    }
    return 0;
  }
  
  int destroy() {
    world.remove(this);
    return 1;
  }
}

class Entity extends FBox {
  
  Entity(float high, float wide) {
    super(high,wide);
    super.setRotatable(false);
  }
  
  void process() {
    println("yo is this entity supposed to process somethin");
  }
  
  void destroy() {
    println("yo is this entity supposed to be destroyed");
  }
  
}

class Enemy extends Entity {//dont use please use the subclasses
  int health = 0;
  Enemy(int HEALTH, int high, int wide) {
    super(high,wide);
    health = HEALTH;
  }
  
  void process() {
    println("bro you forgot to make a process() for this enemy");
  }
  
  void destroy() {//just like roblox.
    loadSound("snd/boom.wav").play();
    world.remove(this);
    entities.remove(this);
    //then the garbage collects i hope
  }
}

class TestBot extends Enemy {
  int speed = 0;
  boolean dir = true;
  int timer = 0;
  byte state = 0;
  Gif anims[] = new Gif[2];
  
  TestBot(int HEALTH, int TYPE, int x, int y) {
    super(HEALTH,32,32);
    entities.add(this);//i wonder if its smart or stupid to allocate this object in the constructor
    switch(TYPE) {
    default://type 0 in here too
      speed = 50;
    }
    super.setPosition(x,y);
    anims[0] = new Gif(2,1.0/20,"spr/t",".png");
    super.attachImage(anims[0]);
    world.add(this);
  }
  
  void process() {
    timer++;
    if(random(0,2500)<timer){state=(byte)((state+1)%2);timer=0;}
    switch(state) {
    case 0:
      super.setVelocity(dir?50:-50,super.getVelocityY());
      break;
    case 1:
      if(timer==0) {
        new Missile(super.getX(),super.getY()-10,10,4,new PVector(you.getX()-super.getX(),you.getY()-super.getY()),50,0,this);
        dir = !dir;
      }
      break;
    default:
      println("GUHHHHHHH???????????");
    }
    anims[0].updatePlayer(dir);
    if(super.isTouchingBody(you)) {
      if(you.getY()+(you.getHeight()/2)-4<=super.getY()-(super.getHeight()/2)) {
        super.destroy();
        you.setVelocity(you.getVelocityX(),-abs(you.getVelocityY()));
      } else {
        you.hurt(1);
      }
    }
  }
}

class Water extends Entity {
  ArrayList<Particle> parts = new ArrayList<Particle>();
  
  Water(float x, float y) {
    super(128,126);
    entities.add(this);//i wonder if its smart or stupid to allocate this object in the constructor
    super.setPosition(x,y);
    super.setNoFill();
    super.setNoStroke();
    super.setStatic(true);
    super.setSensor(true);
    world.add(this);
  }
  
  void process() {
    if(isTouchingBody(you)) {
      parts.add(new Particle(you.getX(),constrain(you.getY(),super.getY()-64,super.getY()),2,color(random(0,32),random(64,128),random(128,255)),random(-100,100),random(-100,0)));
    }
  }
  
  void destroy() {
    world.remove(this);
    entities.remove(this);
  }
}

class Lava extends Entity {
  int speed = 0;
  int timer = 0;
  ArrayList<Particle> parts = new ArrayList<Particle>();
  //Gif anim;
  
  Lava(float x, float y) {
    super(128,126);
    entities.add(this);//i wonder if its smart or stupid to allocate this object in the constructor
    super.setPosition(x,y);
    super.setNoFill();
    super.setNoStroke();
    super.setStatic(true);
    super.setSensor(true);
    speed = round(random(120,240));
    //anim = new Gif(1,1,"tex/lazylava",".png");
    //super.attachImage(anim);
    world.add(this);
  }
  
  void process() {
    timer++;
    if(random(0,speed)<timer) {
      parts.add(new Particle(random(0,64)+super.getX(),super.getY()-64,2,color(random(230,255),random(96,108),random(0,32)),random(-100,100),random(-100,0)));
    }
    if(isTouchingBody(you)) {
      parts.add(new Particle(you.getX(),constrain(you.getY(),super.getY()-64,super.getY()),2,color(random(230,255),random(96,108),random(0,32)),random(-100,100),random(-100,0)));
      //make some particles of them colours
    }
    for(int i=parts.size()-1;i>-1;i--) {
      int retVal = parts.get(i).process();
      if(retVal==1)parts.remove(i);
    }
    //anim.update();
  }
  
  void destroy() {
    world.remove(this);
    entities.remove(this);
  }
}

class Projectile {
  PVector direction;
  FBody hit;
  
  Projectile(FBody HIT) {
    hit = HIT;
  }
  
  void process() {
    println("bro you forgot to make a process() for this projectile");
  }
  
  void destroy() {
    println("bro you forgot to make a destroy() for this projectile");
  }
}

class Missile extends Projectile {// the attack of the testbot
  int mass = 0;
  float speed = 0;
  FBody creator;
  SoundFile sound;
  
  Missile(float x, float y, int wide, int high, PVector DIR, float SPEED, float MASS, FBody CREATOR) {
    super(new FBox(wide,high));
    world.addBody(hit);
    hit.setFill(0,0,255);
    hit.setPosition(x,y);
    speed = SPEED;
    direction = DIR.normalize().mult(SPEED);
    creator = CREATOR;
    //sound = new SoundFile(dis,"snd/disconnect.mp3");
    //sound.loop();
    //super.setDensity(super.getMass()*world.getGravity().y/-(high*wide));
    hit.setRotation(degrees(DIR.heading()));
    hit.setDensity(0.0001);
    hit.setVelocity(direction.x,direction.y);
    hit.setAngularVelocity(0);
    hit.setRotatable(false);
    projs.add(this);
  }
  
  void process() {
    hit.setVelocity(direction.x,direction.y);
    hit.setAngularVelocity(0);
    ArrayList<FBody> touchings = hit.getTouching();
    for(int i=touchings.size()-1;i>-1;i--){
      String name = touchings.get(i).getName();
      if((name!=null?unbinary(name):0)%0x20/0x10>0)touchings.remove(i);
    }
    if(touchings.size() != 0 && !hit.isTouchingBody(creator))destroy();
  }
  
  void destroy() {
    //sound.stop();
    sound = null;
    loadSound("snd/boom.wav").play();
    new Explosion(hit.getX(),hit.getY(),new FCircle(50));
    projs.remove(this);
    world.remove(hit);
  }
}

class Explosion extends Projectile {//daibakuhatsu
  Explosion(float x, float y, FBody hitbox) {
    super(hitbox);
    hit.setPosition(x,y);
    hit.setSensor(true);
    projs.add(this);
    world.addBody(hit);
  }
  
  void process() {
    if(hit.isTouchingBody(you))you.hurt(1);
    projs.remove(this);
    world.remove(hit);
  }
}

class Sensor extends FBox { //chunk extension method is here!

  int chunkID = 0;
  
  Sensor(float x, float y, float xPos, float yPos) {
    super(x,y);
    setPosition(xPos,yPos);
    setSensor(true);
    setStatic(true);
    setName("10000");
  }
  
  int extendChunk(byte[] stuff, int chunkNum) {
    ArrayList<FBody> parts = chunks[chunkNum].getBodies();//i modify your variables directly!
    int p = 0;
    switch(stuff[0]){
    case 0:
      //get flags and | everything
      for(FBody part:parts) {
        String[] names = splitTokens(part.getName(),",");
        int namae = unbinary(names[0]);
        namae |= stuff[1];
        names[0] = binary(namae);
        part.setName(join(names,"")); 
      }
      p+=2;
      break;
    case 1:
      //gotta implement speech itself first...
      int which = stuff[1] & 0xFF;
      setName(getName()+",S"+which+","+chunkNum);
      p+=2;
      break;
    case 2:
      //guh...
      int x = stuff[1]&0xFF;
      x *= 0x100;
      x += stuff[2]&0xFF;
      int y = stuff[3]&0xFF;
      y *= 0x100;
      y += stuff[4]&0xFF;
      setName(getName()+"T"+x+":"+y);
      p+=5;
      break;
    case 3:
      color iro = color(stuff[1]&0xFF,stuff[2]&0xFF,stuff[3]&0xFF,stuff[4]&0xFF);
      for(FBody part:parts)part.setFillColor(iro);
      break;
    case 4:
      println("Sorries no HSB yet me too lazy to push pop colours");
      break;
    case 5:
      iro = color(stuff[1]&0xFF,stuff[2]&0xFF,stuff[3]&0xFF,stuff[4]&0xFF);
      for(FBody part:parts)part.setStrokeColor(iro);
      break;
    case 6:
      println("Sorries no HSB yet me too lazy to push pop colours");
      break;
    case 7:
      for(FBody part:parts)part.setFriction(stuff[1]&0xFF);
      break;
    case 8:
      for(FBody part:parts)part.setFriction(stuff[1]&0xFF);
      break;
    }
    return p;
  }
}

class Button {
  int Type = 0; //positive type is text, negative type is image
  int X = 0;
  int Y = 0;
  int XSize = 0;
  int YSize = 0;
  float tSize = 0;
  color Out = color(0,0,0);// idle outline
  color In = color(0,0,0);// idle fill
  int doWhat = 0;
  String text = "";
  PImage img = new PImage();
  color TOut = color(0,0,0);// text/tint unpressed
  color TIn = color(0,0,0);// text/tint depressed
  color POut = color(0,0,0);// pressed outline
  color PIn = color(0,0,0);// pressed fill
  color THov = color(0,0,0);// text/tint hover
  color HOut = color(0,0,0);// hover outline
  color HIn = color(0,0,0);// hover fill
  //text button constructor
  Button(int tYPE, int DOwHAT, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, color hoUT, color hiN, color poUT, color piN, color toUT, color thOV, color tiN, String TEXT, float TsIZE) {
    if(tYPE<0||x<0||y<0||xsIZE<0||ysIZE<0||DOwHAT<0) {
      Type = 1;
    } else {
      Type = abs(tYPE);
      X = x;
      Y = y;
      XSize = xsIZE;
      YSize = ysIZE;
      Out = oUT;
      In = iN;
      doWhat = DOwHAT;
      text = TEXT;
      TOut = toUT;
      THov = thOV;
      TIn = tiN;
      POut = poUT;
      PIn = piN;
      HIn = hiN;
      HOut = hoUT;
      tSize = TsIZE;
    }
  }
  //image button constructor
  Button(int tYPE, int DOwHAT, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, color hoUT, color hiN, color poUT, color piN, color toUT, color thOV, color tiN, PImage IMG) {
    if(tYPE<0||x<0||y<0||xsIZE<0||ysIZE<0||DOwHAT<0) {
      Type = -1;
    } else {
      Type = -abs(tYPE);
      X = x;
      Y = y;
      XSize = xsIZE;
      YSize = ysIZE;
      Out = oUT;
      In = iN;
      doWhat = DOwHAT;
      img = IMG;
      TOut = toUT;
      THov = thOV;
      TIn = tiN;
      POut = poUT;
      PIn = piN;
      HIn = hiN;
      HOut = hoUT;
    }
  }
  
  void draw(byte Active) {//2 is pressed, 1 is hover, 0 is idle
    if(Type==0||Type==-0) {
      println("Warning: Uninitialized button.");
    } else {
      if(Type>0) {
        push();
        textAlign(CENTER,CENTER);
        //println(tSize);
        textSize(tSize);
        switch(Active) {
        case 0:
          fill(TOut);
          push();
          stroke(Out);
          fill(In);
          break;
        case 1:
          fill(THov);
          push();
          stroke(HOut);
          fill(HIn);
          break;
        case 2:
          fill(TIn);
          push();
          stroke(POut);
          fill(PIn);
          break;
        default:
          println("Naked grandma!");
        }
        switch(Type) {
        case 1:
          rect(X,Y,XSize,YSize);
          pop();
          text(text,XSize/2+X,YSize/2+Y);
          break;
        case 2:
          ellipse(X,Y,XSize,YSize);
          pop();
          text(text,XSize/2+X,YSize/2+Y);
        }
        pop();
      } else {
        push();
        switch(Active) {
        case 0:
          tint(TOut);
          stroke(Out);//ya need to keep these parts in case of transparent images
          fill(In);
          break;
        case 1:
          tint(THov);
          stroke(HOut);
          fill(HIn);
          break;
        case 2:
          tint(TIn);
          stroke(POut);
          fill(PIn);
          break;
        default:
          println("Naked huh?");
        }
        switch(-Type) {
        case 1:
          rect(X,Y,XSize,YSize);
          image(img,X,Y,XSize,YSize);
          break;
        case 2:
          ellipse(X,Y,XSize,YSize);
          text(text,XSize/2+X,YSize/2+Y);
        }
        pop();
      }
    }
  }
  
  void drawHit(int i, PGraphics H) {
    i++;
    H.fill(color(i%0x1000000/0x10000,i%0x10000/0x100,i%0x100));
    switch(abs(Type)) {
    case 1:
      H.rect(X,Y,XSize,YSize);
      break;
    case 2:
      H.ellipse(X,Y,XSize,YSize);
    }
  }
}

class Dialog {
  int pic = 0;
  String whatSay = "";
  Dialog(int PIC, String WHATsAY) {
    pic = PIC;
    whatSay = WHATsAY;
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main Program
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void settings() {
  size(640,480,P2D);//holy nya why havent i used p2d before
}

void setup() {
  //surface.setResizable(true);
  Hitbox = createGraphics(640,480,P2D);
  Hitbox.noStroke();
  lucid = createFont("Lucida Console",14,false);
  camDir = false;
  noLoop();
  thread("loadLevelFile");
  //convert(loadBytes("map02.lvl"),3,"map02ext.lvl");
  //draw thy loading screen
}

void draw() {
  try {
    drawing = true;
    switch(mode) {
    case 0:
      background(0);
      
      //do the buttons the menus the yaddas not the nyaddas
      //mode = 4;
      //frameCount = 0;
    case 1://maybe do the loading while the intro is introing with a thread or something like that
      if(!camDir){
        push();
        noStroke();
        fill(63,63,95);
        if(frameCount<=30) {
          rect(0,-height+(height*frameCount/30.0),width,height);
        } else if(frameCount<=60) {
          rect(0,0,width,height);
          fill(159,159,191);
          rect(width-(width*(frameCount-30)/30.0),0,width,height/5);
        } else if(frameCount<=75) {
          rect(0,0,width,height);
          fill(159,159,191);
          rect(0,0,width,height/5);
          fill(255);
          rect(((-75+frameCount)/60.0)*width,0,width/4,height);
        } else if(frameCount<=90) {
          rect(0,0,width,height);
          fill(159,159,191);
          rect(0,0,width,height/5);
          fill(255);
          rect(0,0,width/4,height);
          fill(127,127,255,127);
          rect(width*(1.63-(frameCount/120.0)),0,width*0.125,height);
          rect(0,height*(2.25-(frameCount/60.0)),width,height*0.25);
          fill(255,31,31);
          rect(width*(6.175-(frameCount/15.0)),height/4,width*33/40,height/14);
          textAlign(LEFT,CENTER);
          textSize(48);
          text(mapName,width*(6.175-(frameCount/15.0)),height*2/7);
          fill(255);
          text(mapName,width*(6.175-(frameCount/15.0))+2,height*2/7-2);
        } else if(!loading) {
          if(keyPressed){camDir = true;frameCount=0;}
        }
        pop();
      } else {
        push();
        background(backcolour);
        scale(scl);
        translate((int)(width/2-camVec.x-((width-(width/scl))/2)),(int)(height/2-camVec.y-((height-(height/scl))/2)));
        world.draw();
        pop();
        push();
        fill(63,63,95);
        noStroke();
        fill(63,63,95);
        if(frameCount<=15) {
          rect(0,0,width,height);
          fill(159,159,191);
          rect(0,0,width,height/5);
          fill(255);
          rect(0,0,width/4,height);
          fill(127,127,255,127);
          rect(width*(0.875+(frameCount/120.0)),0,width*0.125,height);
          rect(0,height*(0.75+(frameCount/60.0)),width,height*0.25);
          fill(255,31,31);
          rect(width*(0.175+(frameCount/15.0)),height/4,width*33/40,height/14);
          textAlign(LEFT,CENTER);
          textSize(48);
          text(mapName,width*(0.175+(frameCount/15.0)),height*2/7);
          fill(255);
          text(mapName,width*(0.175+(frameCount/15.0))+2,height*2/7-2);
        } else if(frameCount<=30) {
          rect(0,0,width,height);
          fill(159,159,191);
          rect(0,0,width,height/5);
          fill(255);
          rect(((15-frameCount)/60.0)*width,0,width/4,height);
        } else if(frameCount<=60) {
          rect(0,0,width,height);
          fill(159,159,191);
          rect((width*(frameCount-30)/30.0),0,width,height/5);
        } else if(frameCount<=90) {
          rect(0,height*((60-frameCount)/30.0),width,height);
        } else {mode = 2;frameCount=0;if(mus[0]!=null)mus[0].loop();}
        pop();
      }
      break;
    case 2:
      //processing objects
      keys = you.process(keys);
      for(int i=entities.size();i>0;i--)entities.get(i-1).process();
      for(int i=projs.size();i>0;i--)projs.get(i-1).process();
      for(Gif pic:tex)pic.update();
      world.step();
      //camera stuff
      playerVec.set(you.getX(),you.getY());
      camVec.lerp(PVector.add(playerVec,new PVector(sqrt2(you.getVelocityX()*30)+(camDir?50:-50),sqrt2(you.getVelocityY()*30))),0.05);
      scl = lerp(scl,constrain(1.0-dist(0,0,you.getVelocityX()/2500.0,you.getVelocityY()/2500.0),0.5,1),0.1);
      //scl/=6;
      if(!(frameCount%2>0&&halfFPS)) {//draw?
        push();
        background(backcolour);
        scale(scl);
        //stroke(127,127);
        //strokeWeight(0.5);
        translate((int)(width/2-camVec.x-((width-(width/scl))/2)),(int)(height/2-camVec.y-((height-(height/scl))/2)));
        world.draw();
        //stroke(133,234,82);
        //line(128,2048-128,256,2048-128);
        //for(int i=0;i<15;i++)line(0,i*16,640,i*16);for(int i=0;i<15;i++)line(i*16,0,i*16,640);
        pop();
        dispDialog();
      }
      //scl*=6;
      
      break;
    case 3:
      //a winner is you gotta play dat win animation and score?? what score this aint sonic the hedgehog
      mode = 4;
      thread("loadLevelFile");
      break;
    case 4:
      frameCount = 0;
    }
    drawing = false;
  } catch (Exception e) {
    blueDead(e);
    noLoop();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main Functions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void makeLevel(File level) {
  if(level!=null) {
  mapData = loadBytes(level.getAbsolutePath());
  thread("makeLevel");
  mode = 4;
  } else {
    exit();
    //thread("loadLevelFile");
  }
}

void makeLevel() {
  try {
    //while(drawing) {
    //  print("");
    //}
    loop();
    loading = true;
    mapName = "man your storage device is slow";
    //mapData = loadBytes(maps[mapNum%maps.length]);
    String fileFoot = new String(subset(mapData,mapData.length-16,15)); //make sure that level valid
    if(!(fileFoot.equals("Tophat Turmoil ")))throw new RuntimeException("Level Footer Not Found");
    mapName = tostring(char(subset(mapData,mapData.length-33-mapData[mapData.length-26],mapData[mapData.length-26]+1)));//load the map name first so the title card can work better
    if(debug)println("Map Name: "+mapName);
    camDir = false;
    for(int i=0;i<entities.size();i++)entities.get(i).destroy();
    if(you!=null)world.remove(you);
    if(mus[0]!=null){mus[0].stop();mus[0] = null;}
    Fisica.init(this);
    char fileType = new String(subset(mapData,mapData.length-1)).charAt(0);
    int lWidth = bi(mapData[mapData.length-32])+1;
    int lHeight = bi(mapData[mapData.length-31])+1;
    println("Width: "+lWidth+" Height: "+lHeight);
    backcolour = color(int(mapData[mapData.length-22])&0xFF,int(mapData[mapData.length-21])&0xFF,int(mapData[mapData.length-20])&0xFF);
    byte[] map = new byte[0];
    int p = 0;
    tex = new Gif[255];
    java.util.Arrays.fill(tex,new Gif());
    world = new FWorld(-128,-128,lWidth*128+128,lHeight*128+128);
    world.setGravity(mapData[mapData.length-24]*10,mapData[mapData.length-23]*10);
    if(fileType=='3') {
      int contents = mapData[mapData.length-17]&0xFF;
      PVector[] entityList = new PVector[0];
      while(contents!=0) {
        p = 2147483647;//long code gooooo
        byte nextSeg = 0;
        int temp = 0;
        String[] headers = {"Textures","Map Layout","Enemies","Sounds","Background","Scripts"};
        for(byte i=0;i<headers.length;i++) {
          if(contents%pow(2,i+1)/pow(2,i)>0) {
            temp = new String(mapData).indexOf(headers[i]);
            if(temp<p&&temp>-1){p=temp;nextSeg=(byte)(i+1);}
          }
        }
        println(nextSeg);
        switch(nextSeg) {
        case 1:
          if(textures)p += loadTextures(split(new String(subset(mapData,p+8)),(char)0))+8;
          contents^=0x1;
          break;
        case 2:
          entityList = makeChunks(subset(mapData,p+10),lWidth,lHeight,fileType);
          p += entityList[0].x+10;
          entityList = (PVector[])subset(entityList,1,entityList.length-1);
          contents^=0x2;
          break;
        case 3:
          p += makeEnemies(int(subset(mapData,p+7)))+7;
          contents^=0x4;
          break;
        case 4:
          p += loadMusic(subset(mapData,p+6))+6;
          contents^=0x8;
          break;
        case 6:
          p += loadScripts(subset(mapData,p+7))+7;
          contents^=0x20;
          break;
        default:
          throw new RuntimeException("Invalid Next Level Segment");
        }
        mapData = subset(mapData,p);
      }
      makeEntities(entityList);
    } else {
      map = mapData;
      //nobody touch the code below its a monster
      if(fileType!='1'){String[]s = split(new String(subset(map,0,map.length-33-map[map.length-26])),(char)0);loadTextures(subset(s,s.length-map[map.length-25]));makeEnemies(int(subset(map,lWidth*lHeight)));}
      makeChunks(mapData,lWidth,lHeight,fileType);
    }
    you = new player(3,(256*bi(mapData[mapData.length-30]))+bi(mapData[mapData.length-29]),(256*bi(mapData[mapData.length-28]))+bi(mapData[mapData.length-27]));
    world.add(you);
    playerVec = new PVector(you.getX(),you.getY());
    camVec = new PVector(playerVec.x+sqrt2(you.getVelocityX()*30)+(camDir?50:-50),playerVec.y+sqrt2(you.getVelocityY()*30));
    mode = 1;
    dialNum = -1;
    subDialNum = 0;
    talkTimer = 0;
    for(int i=0;i<keys.length;i++)keys[i]=0;
    loading = false;
  } catch (Exception e) {
    blueDead(e);
    noLoop();
  }
}

int loadTextures(String[] texList) {
  int p = 0;
  if(texList.length>=mapData[mapData.length-25]){
    //texList = subset(texList,0,mapData[mapData.length-25]);
    for(int i=0;i<mapData[mapData.length-25];i++) {
      int gifLen = texList[i].getBytes()[0]&0xFF;
      p+=texList[i].length();
      if(gifLen>0) {
        String[] fileName = split(new String(subset(texList[i].getBytes(),2,texList[i].length()-2)),'.');
        p+=fileName.length-1;
        tex[i] = new Gif(gifLen,mf(texList[i].getBytes()[1]),join(subset(fileName,0,fileName.length-1),"."),"."+fileName[fileName.length-1]);
        tex[i].resizeGif(128,128);
      } else {
        tex[i] = new Gif();
      }
    }
  }
  return p;
}

void makeEntities(PVector[] ents) {
  for(PVector itis:ents) {
    switch(round(itis.x)){
    case 1: //water
      new Water(itis.y,itis.z);
      break;
    case 2:
      new Lava(itis.y,itis.z);
      break;
    }
  }
}

int makeEnemies(int[] bads) {
  for(int i=0;i<bads.length;i++)bads[i]&=0xFF;
  int p = 0;
  boolean finish = false;
  while(!finish) {
    switch(bads[p]) {
    case 1:
      new TestBot(bads[p+1],bads[p+2],bads[p+3]*256+bads[p+4],bads[p+5]*256+bads[p+6]);
      p+=7;
      break;
    default: //includes 00 which is finished
      finish = true;
    }
  }
  return p;
}

int loadMusic(byte[] mussy) {
  int p = 0;
  while(mussy[p]!=0) {
    String path = new String(subset(mussy,p+1));
    path = path.substring(0,path.indexOf((char)0));
    switch(mussy[p]) {//prob gonna have different audio variables later so gonna use a switch here
    case 1:
      mus[0] = new SoundFile(this,path);
      break;
    case 2:
      mus[1] = new SoundFile(this,path);
      break;
    default:
      print("hey this aint a valid trigger (yet?)");
    }
    p+=1+path.length();
  }
  return p;
}

int loadScripts(byte[] stuff) {
  int p = 0;//pointer to be returned
  int a = 0;//pointer for what gif/dialog is being loaded
  //int b = 0;//pointer for what script part is being loaded(is this even needed?)
  while(stuff[p]!=0) {//load them picture gifs (for now only dem single images i think at least)
    String filePaths[] = new String[0];
    float gifSpeed = mf(stuff[p]);
    p++;
    while(stuff[p]!=0x00) {
      int frames = bi(stuff[p]);
      String filePath = new String(subset(stuff,p+1));//dont forget that there are multiple frames
      filePath = filePath.substring(0,filePath.indexOf((char)0x0D));
      for(int i=0;i<frames;i++) {
        filePaths = append(filePaths,filePath);
      }
      p+=filePath.length()+2;
      //String[] filePaths = split(filePath,(char)0x0A);//i hope this works
      //String[] filePaths = split(filePath,(char)0x0D);
    }
    //println(a);
    dial[a] = new Gif(gifSpeed,filePaths);
    //p+=String.join("",filePaths).length();
    a++;
  }
  p+=2;
  talks = new Dialog[0][0];
  while(stuff[p]!=0) {//load them scripts
    Dialog[] temp = new Dialog[0];
    while(stuff[p]!=0) {//load one script part
      int animNum = bi(stuff[p])-2; //what animation to display
      String text = new String(subset(stuff,p+1)); //what is said
      text = text.substring(0,text.indexOf((char)0x00));
      p+=text.length()+2;
      temp = (Dialog[])append(temp,new Dialog(animNum,text));
    }
    talks = (Dialog[][])append(talks,temp);
    p++;
  }
  return p;
}

PVector[] makeChunks(byte[] map, int lWidth, int lHeight, int fileType) {
  int p = 0;
  PVector[] ret = new PVector[]{new PVector()};
  chunks = new FCompound[lWidth*lHeight];
  for(int j=0;j<lHeight;j++){
    for(int i=0;i<lWidth;i++) {
      //int chunk = fileType=='3'?p/2:j*lWidth+i;
      int chunk = j*lWidth+i;
      byte ID = map[fileType=='3'?p:chunk*(fileType=='1'?1:2)];
      int texture = fileType=='1'||!textures?0:map[1+(fileType=='2'?chunk*2:p)];
      texture&=0xFF;
      texture-=1;
      p+=2;
      chunks[chunk] = new FCompound();
      float xPos = 0;//for the background images
      float yPos = 0;
      switch(ID){
      case 1:
        FBox gnd = new FBox(128,127);
        gnd.setPosition(65,65.5);
        gnd.setName("00");
        FLine jmp = new FLine(1,1,129,1);
        jmp.setName("01");
        xPos = 65;
        yPos = 65;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i-1,128*j-1);
        chunks[chunk].setStatic(true);
        break;
      case 2:
        gnd = new FBox(128,128);
        gnd.setPosition(64,64);
        gnd.setName("00");
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 3:
        FPoly slo = new FPoly();
        slo.vertex(1,128);
        slo.vertex(128,1);
        slo.vertex(128,128);
        slo.vertex(1,128);
        slo.setName("00");
        jmp = new FLine(0,128,127,1);
        jmp.setName("01");
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          slo.setNoFill();
          slo.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(slo);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 4:
        slo = new FPoly();
        slo.vertex(0,1);
        slo.vertex(127,128);
        slo.vertex(0,128);
        slo.vertex(0,1);
        slo.setName("00");
        jmp = new FLine(1,1,128,128);
        jmp.setName("01");
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          slo.setNoFill();
          slo.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(slo);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 5:
        gnd = new FBox(128,63);
        gnd.setPosition(65,97.5);
        gnd.setName("00");
        jmp = new FLine(1,65,129,65);
        jmp.setName("01");
        xPos = 65;
        yPos = 65;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i-1,128*j-1);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 6:
        gnd = new FBox(128,64);
        gnd.setPosition(64,112);
        gnd.setName("00");
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j-1);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 7:
        gnd = new FBox(128,127);
        gnd.setPosition(65,65.5);
        gnd.setName("00");
        gnd.setFillColor(0xFFAFAFFF);
        gnd.setFriction(0);
        jmp = new FLine(1,1,129,1);
        jmp.setName("01");
        jmp.setFriction(0);
        xPos = 65;
        yPos = 65;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i-1,128*j-1);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 8:
        gnd = new FBox(128,128);
        gnd.setPosition(64,64);
        gnd.setName("00");
        gnd.setFillColor(0xFFAFAFFF);
        gnd.setFriction(-1);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 9:
        slo = new FPoly();
        slo.vertex(1,128);
        slo.vertex(128,1);
        slo.vertex(128,128);
        slo.vertex(1,128);
        slo.setFriction(0);
        slo.setName("00");
        slo.setFillColor(0xFFAFAFFF);
        slo.setFriction(0);
        jmp = new FLine(0,128,127,1);
        jmp.setName("01");
        jmp.setFriction(0);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          slo.setNoFill();
          slo.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(slo);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0xA:
        slo = new FPoly();
        slo.vertex(0,1);
        slo.vertex(127,128);
        slo.vertex(0,128);
        slo.vertex(0,1);
        slo.setFriction(0);
        slo.setName("00");
        slo.setFillColor(0xFFAFAFFF);
        slo.setFriction(0);
        jmp = new FLine(1,1,128,128);
        jmp.setName("01");
        jmp.setFriction(0);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          slo.setNoFill();
          slo.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(slo);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0xB:
        gnd = new FBox(128,63);
        gnd.setPosition(65,97.5);
        gnd.setName("00");
        gnd.setFillColor(0xFFAFAFFF);
        gnd.setFriction(0);
        jmp = new FLine(1,65,129,65);
        jmp.setName("01");
        jmp.setFriction(0);
        xPos = 65;
        yPos = 65;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i-1,128*j-1);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0xC:
        gnd = new FBox(128,64);
        gnd.setPosition(64,112);
        gnd.setName("00");
        gnd.setFillColor(0xFFAFAFFF);
        gnd.setFriction(0);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0xD:
        gnd = new FBox(128,127);
        gnd.setPosition(65,65.5);
        gnd.setName("00");
        gnd.setFillColor(0xFF000000);
        gnd.setRestitution(3);
        jmp = new FLine(1,1,129,1);
        jmp.setName("01");
        jmp.setRestitution(3);
        xPos = 65;
        yPos = 65;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i-1,128*j-1);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0xE:
        gnd = new FBox(128,127);
        gnd.setPosition(65,65.5);
        gnd.setName("00");
        gnd.setFillColor(0xFF3F009F);
        gnd.setRestitution(50);
        jmp = new FLine(1,1,129,1);
        jmp.setName("01");
        jmp.setRestitution(50);
        xPos = 65;
        yPos = 65;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i-1,128*j-1);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0xF:
        chunks[chunk] = new FCompound();
        gnd = new FBox(128,128);
        gnd.setPosition(64,64);
        gnd.setName("100");
        gnd.setSensor(true);
        gnd.setFillColor(0x7F3FFF3F);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0x10:
        gnd = new FBox(128,128);
        gnd.setPosition(64,64);
        gnd.setName("10");
        gnd.setFillColor(0xFFAFAFFF);
        gnd.setFriction(0);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0x11:
        gnd = new FBox(128,128);
        gnd.setPosition(64,64);
        gnd.setName("11");
        gnd.setFillColor(0xDF9F9FFF);
        gnd.setFriction(0);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0x12:
        gnd = new FBox(128,126);
        gnd.setPosition(64,65);
        gnd.setName("00100001");
        gnd.setFillColor(0xFF7F7FFF);
        gnd.setFriction(0);
        gnd.setSensor(true);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        ret = (PVector[])append(ret,new PVector(1,128*i+64,128*j+66));
        break;
      case 0x13:
        gnd = new FBox(128,126);
        gnd.setPosition(64,65);
        gnd.setName("00100011");
        gnd.setFillColor(0xFFFF3F3F);
        gnd.setFriction(0);
        gnd.setSensor(true);
        xPos = 64;
        yPos = 64;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        ret = (PVector[])append(ret,new PVector(2,128*i+64,128*j+66));
        break;
      case 0x14:
        gnd = new FBox(126,128);
        gnd.setPosition(65,65);
        gnd.setName("00");
        jmp = new FLine(1,1,129,1);
        jmp = new FLine(1,65,129,65);
        jmp.setName("01");
        FLine jm2 = new FLine(1,33,129,33);
        jm2 = new FLine(1,129,129,129);
        jm2.setName("01");
        FLine jm3 = new FLine(1,63,129,63);
        jm3.setName("01");
        FLine jm4 = new FLine(1,95,129,95);
        jm4.setName("01");
        xPos = 65;
        yPos = 65;
        if(texture!=-1){
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
          jm2.setNoStroke();
          jm3.setNoStroke();
          jm4.setNoStroke();
        }
        chunks[chunk].addBody(gnd);
        chunks[chunk].addBody(jmp);
        chunks[chunk].addBody(jm2);
        chunks[chunk].setPosition(128*i-1,128*j-1);
        chunks[chunk].setStatic(true);
        break;
      case 0x15:
        xPos = 64;
        yPos = 64;
        Sensor img = new Sensor(128,128,xPos,yPos);
        chunks[chunk].addBody(img);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        //do more checkpoint garbage
        ret = (PVector[])append(ret,new PVector(2,128*i+64,128*j+66));
        break;
      default: //air for unimplemented chunks
        xPos = 64;
        yPos = 64;
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
      }
      Sensor img = new Sensor(128,128,xPos,yPos);
      if(texture!=-1) {
        img.attachImage(tex[texture]);
      } else {
        img.setNoFill();
        img.setNoStroke();
      }
      if(fileType=='3')while(bi(map[p])!=0xFF) {        
        p += img.extendChunk(subset(map,p),chunk);
      }p++;
      chunks[chunk].addBody(img);
      world.add(chunks[chunk]);
    }
  }
  ret[0].x = p;
  return ret;
}

void dispDialog(Dialog what) {//this ones for a specific dialog (maybe menu screens?)
  push();
  fill(127,127);
  noStroke();
  rect(width/10,height/16*12,width/10*8,height/16*3);
  textAlign(LEFT,TOP);
  if(what.pic<0) {
    text(what.whatSay,width/10,height/16*12);
  } else {
    image(dial[what.pic],width/10,height/16*12,height/16*3,height/16*3);
    text(what.whatSay,(width/10)+(height/16*3),height/16*12);
    dial[what.pic].update();
  }
  pop();
}

void dispDialog() {//to start the dialog make subdialnum -1
  if(dialNum>-1&&subDialNum<talks[dialNum].length-1&&talkTimer<=0) {
    subDialNum++;
    talkTimer = talks[dialNum][subDialNum].whatSay.length()*4;
  }
  if(talkTimer>0) {
    push();
    fill(127,127);
    noStroke();
    rect(width/10,height/16*12,width/10*8,height/16*3);
    textSize(16);
    textAlign(LEFT,TOP);
    Dialog what = talks[dialNum][subDialNum];
    if(what.pic<0) {
      text(what.whatSay,width/10,height/16*12);
    } else {
      image(dial[what.pic],width/10,height/16*12,height/16*3,height/16*3);
      text(what.whatSay,(width/10)+(height/16*3),height/16*12);
      dial[what.pic].update();
    }
    pop();
  }
  talkTimer--;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Side Functions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

String tostring(char[] chars) { //oh lua how i wish i were programming in thy scrypt
  String retVal = "";
  for(char c:chars) {
    retVal += str(c);
  }
  return retVal;
}

String reverse(String str) {
  return new String(reverse(str.getBytes()));
}

int bi(byte b) {//byte to int
  //return unbinary(binary(b));
  return (int)(b)&0xFF;
}//alas, unsigned byte problem, i hath defeated thee!

float sqrt2(float num) {
  return num<0?-sqrt(0-num):sqrt(num);
}

float mf(byte b) {//myfloat (so many calculations...)
  int flags = b&0xFF;
  return (flags/0x80>0?4:0)+(flags%0x80/0x40>0?2:0)+(flags%0x40/0x20>0?1:0)+(flags%0x20/0x10>0?0.5:0)+(flags%0x10/0x8>0?0.25:0)+(flags%0x8/0x4>0?0.125:0)+(flags%0x4/0x2>0?0.0625:0)+(flags%0x2>0?0.03125:0);
}

int[] flipImagePix(PImage pic) {
  int[] flipped = new int[pic.width*pic.height];
  pic.loadPixels();
  for(int i=0;i<pic.height;i++) {
    for(int j=0;j<pic.width;j++) {
      flipped[i*pic.width+j] = pic.pixels[(i+1)*pic.width-j-1];
    }
  }
  pic.updatePixels();
  return flipped;
}

//input events and controller support here
void blueDead(Exception e) { //funny
  try{while(true)pop();}catch(Exception f){}//remove all transforms
  noLoop();
  background(#000080);
  fill(255);
  textFont(lucid);
  textAlign(LEFT,TOP);
  text("A problem has been detected and this application has been halted to prevent\nfurther problems from occuring.\n\nThis application has thrown a(n)\n"+e.toString()+"\nand halted itself.\n\nIf this is the first time you've seen this STOP error screen,\nrestart the application. If this screen appears again, try these steps:\n\nCheck to make sure that you haven't modified the application in any way\nshape or form. It may be corrupted. Check that there are no warnings in the\nProcessing console if you are running this application from Processing.\n\nIf problems continue, contact the developer of the application and see if\nthey have an updated version of the application that has bug fixes that may\npertain to this issue. Alternatively, give the information below to the\ndeveloper to aid them in the fixing of this problem.\n\nTechnical information:\n\n*** STOP: "+e.getMessage()+"\n\n***    "+e.getStackTrace()[0].toString(), 0, 24);
  e.printStackTrace();
}

byte[] convert(byte[] map, int toversion, String output) {//only old to new for now, sorry
  char fileType = new String(subset(map,map.length-1)).charAt(0);
  int lWidth = bi(map[map.length-32])+1;
  int lHeight = bi(map[map.length-31])+1;
  byte[] converted = new byte[0];
  switch(fileType) {
  case '1':
    byte[] chunks = subset(map,0,lWidth*lHeight-1);
    byte[] footer = subset(map,map.length-33-map[map.length-26]);
    switch(toversion) {
    case 1:
      println("Erm, actually, the file is already in the file type you wanted it to be.");
      converted = map;
      break;
    case 2:
      map[map.length-25] = 0;
      arrayCopy(chunks,converted);
      for(int i=chunks.length;i>0;i--)converted = (byte[])splice(converted,(byte)0,i);
      converted = concat(converted,footer);
      break;
    case 3:
      map[map.length-25] = 0;
      converted = new byte[chunks.length];
      arrayCopy(chunks,converted);
      for(int i=converted.length;i>0;i--){converted = (byte[])splice(converted,(byte)0xFF,i);converted = (byte[])splice(converted,(byte)0,i);}
      converted = concat(new String("Map Layout").getBytes(),converted);
      converted = concat(converted,footer);
      converted[converted.length-17] = (byte)2;
      converted[converted.length-1] = "3".getBytes()[0];
      break;
    default:
      println("file type not supported bro");
    }
    break;
    
  default:
    println("guh...nya?");
  }
  if(output!=null)saveBytes(output,converted);
  return converted;
  //if(fileType!='1'){loadTextures(split(new String(subset(map,0,map.length-33-map[map.length-26])),(char)0));makeEnemies(int(subset(map,lWidth*lHeight)));}
  //makeChunks(mapData,lWidth,lHeight,fileType);
}

SoundFile loadSound(String path) {
  return new SoundFile(this,path);
}

void loadLevelFile() {
  selectInput("Select a level file (ends with a .lvl)","makeLevel");//calls callback before file is chosen on linux?
}

void keyPressed() {
  switch(keyCode){
  case 65:
    if(keys[0]==0)keys[0] = 1;
    break;
  case 68:
    if(keys[1]==0)keys[1] = 1;
    break;
  case 32:
    if(keys[2]==0)keys[2] = 1;
    break;
    //addin actions n stuff later
  }
}

void keyReleased() {
  switch(keyCode){
  case 65:
    keys[0] = 0;
    break;
  case 68:
    keys[1] = 0;
    break;
  case 32:
    keys[2] = 0;
    break;
  }
}

void mousePressed() {
  if(buttonsEnabled){
    int Action = Hitbox.get(mouseX,mouseY);
    Btn = round(red(Action))*0x100+round(green(Action))*0x100+ceil(blue(Action));
  }
}

void mouseReleased() {
  if(frameCount>1&&!loading){
    int Action = Hitbox.get(mouseX,mouseY);
    Action = round(red(Action))*0x100+round(green(Action))*0x100+ceil(blue(Action));
    if(Action==Btn&&Action!=0) {
      //Action = title[Action-1].doWhat;
      switch(Action) {
      default:
        //blueDead("Button Action "+Action,"404 Not Found","Action = "+Action);
      }
    }
    Btn = 0;
  }
}

void processButtons(int[] B, PGraphics H) {
  H.beginDraw();
  H.background(0);
  for(int i=0;i<B.length;i++)buttonList[buttonDraw[i]].drawHit(buttonDraw[i],H);
  for(int i=0;i<B.length;i++) {//draw buttons
    byte Status = 0;
    int Hover = Hitbox.get(mouseX,mouseY);
    Hover = round(red(Hover))*0x100+round(green(Hover))*0x100+ceil(blue(Hover));
    if(Hover-1==B[i])Status = 1;
    if(Btn-1==B[i])Status = 2;
    buttonList[buttonDraw[i]].draw(Status);
  }
  H.endDraw();
}

/*
Credits! (because i thought it would be nice.)

Me - literally everything used in the game
Johang727 - bug reporting
Richard Marxer - the fisica library
Processing contributors - the sound library
um thats it unless you count Kitta for emotional support
Current title card lovingly stolen from Sonic Crackers

Tools Used

Furnace - all sound effects and music
MS Paint - simple graphics
GIMP - advanced graphics
Processing - y'know, the thing that runs this code
foobar2000 - converting audio
Windows 10 & 11 - IMO one good and one bad
macOS 10.13 - would be nice if my mac could do processing 4
Ubuntu 22.04.6 LTS - the ancient fossil on my hard drive 

temporary planning part

checkpoint

when kitta die she respawn at the last checkpoint she touched
this is stored in the level file
the checkpoint changes the spawn point part of the level file
then the level reloads
when the checkpoint is touched it changes picture
the checkpoint is an entity
the checkpoint changes itself in the level file to reflect its toggledness
note changes to the level file are only in ram the actual file is untouched
*/
