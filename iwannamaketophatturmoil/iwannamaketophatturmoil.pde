/* Title: Iwannamaketophatturmoil *\
|* Author: Louie Wang             *|
|* Description: woo my unreleased *|
|* game that i havent started     *|
|* working on yet has moved from  *|
|* the sega genesis to processing *|
\*_Date:_Nov.1,_2024______________*/

/*to-do's (i aint usin github issues for this nonsense)
Finish the dingin' chunk extensions
Finish Missiles
Add Lava Entities
Make liquids
checkpoint/goalpost idea: big tv with camera on top, as player goes by it takes a picture and the tv shows the head of the character
Make some dialogs
Make a sonic crackers title card (while blocking worldprocessing during that with a bool)
*/

import fisica.*;
import processing.sound.*;

boolean loading = true;
boolean debug = false;
String[] maps = new String[]{"map01.lvl","map02ext.lvl","map03.lvl","map03tex.lvl","map03ext.lvl","map04.lvl","map05.lvl"};
//String[] maps = new String[]{"map00.lvl"};
byte[] mapData;
String mapName;
byte mapNum = 6;
Gif[] tex = new Gif[255];
byte[] keys = new byte[13];
boolean textures = true;
boolean backgnd = true;
boolean halfFPS = false;
PFont lucid;
PVector playerVec, camVec;
float scl = 1;
boolean camDir = true;
FWorld world;
player you;
FCompound[] chunks;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<FBody> projs = new ArrayList<FBody>();//projectiles
Gif bg;
color backcolour = color(0);
PApplet dis = this;
int mode = 0;

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
  
  void updatePlayer() {//special for player gif
    if(images.length>1) {
      currentFrame+=interval;
    }
    int frm = floor(currentFrame)%frames;
    super.init(images[frm].width,images[frm].height,images[frm].format);
    images[frm].loadPixels();
    super.loadPixels();
    arrayCopy(camDir?images[frm].pixels:flipImagePix(images[frm]),super.pixels);
    images[frm].updatePixels();
    super.updatePixels();
  }
  
  void updatePlayer(float speed) {//special for player gif
    if(images.length>1) {
      currentFrame+=speed;
    }
    int frm = floor(currentFrame)%frames;
    super.init(images[frm].width,images[frm].height,images[frm].format);
    images[frm].loadPixels();
    super.loadPixels();
    arrayCopy(camDir?images[frm].pixels:flipImagePix(images[frm]),super.pixels);
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
  int animNum = 0;
  int invince = 0; //invincible until this frame
  int stunned = 0; //stunned until this frame
  int[] animLookup = {0,1,2,0,0};
  int[] sndLookup = {0,1,2,0,0};
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
    animNum = 0;
    ArrayList<FContact> touchings = super.getContacts();
    keys[3] = 1;
    float oldSpeed = super.getVelocityX();
    float massy = 1.0;
    for(int i=touchings.size()-1;i>-1;i--) {
      int flags = 0;
      if(touchings.get(i).getBody1()==this){
        String name = touchings.get(i).getBody2().getName();
        flags = name!=null?unbinary(name):0;
      } else {
        String name = touchings.get(i).getBody1().getName();
        flags = name!=null?unbinary(name):0;
      }
      //if(flags%0x2/1>0) bittest template
      if(flags%0x2/1>0)keys[3] = 0;
      if(flags%0x4/2>0){hurt(1);}
      if(flags%0x8/4>0&&frameCount!=-1){frameCount=-1;mapNum+=1;mode=3;}
      //make dat unstatic thingy
      if(flags%0x20/0x10>0)touchings.remove(i);
      if(flags%0x40/0x20>0)massy = 2;
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
      anim[animLookup[animNum]].updatePlayer(abs(oldSpeed)/1500);
      break;
    default:
      anim[animLookup[animNum]].updatePlayer();
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

class Enemy extends FBox {//dont use please use the subclasses
  int health = 0;
  Enemy(int HEALTH, int high, int wide) {
    super(high,wide);
    super.setRotatable(false);
    health = HEALTH;
  }
  
  void process() {
    println("bro you forgot to make a process() for this enemy");
  }
  
  void destroy() {//just like roblox.
    loadSound("snd/boom.wav").play();
    world.remove(this);
    enemies.remove(this);
    //then the garbage collects i hope
  }
}

class TestBot extends Enemy {
  int speed = 0;
  boolean dir = true;
  int timer = 0;
  byte state = 0;
  
  TestBot(int HEALTH, int TYPE, int x, int y) {
    super(HEALTH,32,32);
    enemies.add(this);//i wonder if its smart or stupid to allocate this object in the constructor
    switch(TYPE) {
    default://type 0 in here too
      speed = 50;
    }
    super.setPosition(x,y);
    super.attachImage(loadImage("spr/t0.png"));
    world.add(this);
  }
  
  void process() {
    timer++;
    if(random(0,500)<timer){state=(byte)((state+1)%2);timer=0;}
    switch(state) {
    case 0:
      super.setVelocity(dir?50:-50,super.getVelocityY());
      break;
    case 1:
      //if(timer==0)new Missile(super.getX(),super.getY()-10,10,40,new PVector(you.getX()-super.getX(),you.getY()-super.getY()-16),10,0);
      dir = !dir;
      break;
    default:
      println("GUHHHHHHH???????????");
    }
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

class Missile extends FBox {
  int mass = 0;
  PVector direction;
  float speed = 0;
  
  Missile(float x, float y, int high, int wide, PVector DIR, float SPEED, float MASS) {
    super(high,wide);
    super.setFill(0,0,255);
    super.setPosition(x,y);
    speed = SPEED;
    direction = DIR.normalize().mult(SPEED);
    projs.add(this);
    super.setDensity(super.getMass()*world.getGravity().y/(high*wide));
    super.setVelocity(direction.x,direction.y);
    super.addToWorld(world);
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

void settings() {
  size(640,480,P2D);//holy nya why havent i used p2d before
}

void setup() {
  //surface.setResizable(true);
  loading = true;
  lucid = createFont("Lucida Console",14,false);
  Fisica.init(this);
  image(loadImage("spr/loudo.png"),0,0,width,height);
  //convert(loadBytes("map02.lvl"),3,"map02ext.lvl");
  //draw thy loading screen
}

void draw() {
  try {
    switch(mode) {
    case 0:
      //do the buttons the menus the yaddas not the nyaddas
      mode = 1;
    case 1://maybe do the loading while the intro is introing with a thread or something like that
      if(loading){
        loading = false;
        mapData = loadBytes(maps[mapNum%maps.length]);
        makeLevel();
        println(mapName);
        playerVec = new PVector(you.getX(),you.getY());
        camVec = new PVector(playerVec.x+sqrt2(you.getVelocityX()*30)+(camDir?50:-50),playerVec.y+sqrt2(you.getVelocityY()*30));
        mode = 2;
      }
      break;
    case 2:
      //processing objects
      keys = you.process(keys);
      for(int i=0;i<enemies.size();i++)enemies.get(i).process();
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
        //for(int i=0;i<15;i++)line(0,i*16,640,i*16);for(int i=0;i<15;i++)line(i*16,0,i*16,640);
        pop();
      }
      //scl*=6;
      break;
    case 3:
      //a winner is you gotta play dat win animation and score?? what score this aint sonic the hedgehog
      frameCount = -1;
      mode = 1;
      break;
    }
  } catch (Exception e) {
    blueDead(e);
    noLoop();
  }
}

void makeLevel() {
  for(int i=0;i<enemies.size();i++)enemies.get(i).destroy();
  String fileFoot = new String(subset(mapData,mapData.length-16,15));
  mapName = tostring(char(subset(mapData,mapData.length-33-mapData[mapData.length-26],mapData[mapData.length-26]+1)));
  if(!(fileFoot.equals("Tophat Turmoil ")))throw new RuntimeException("Level Footer Not Found");
  char fileType = new String(subset(mapData,mapData.length-1)).charAt(0);
  int lWidth = bi(mapData[mapData.length-32])+1;
  int lHeight = bi(mapData[mapData.length-31])+1;
  println(lWidth, lHeight);
  backcolour = color(int(mapData[mapData.length-22])&0xFF,int(mapData[mapData.length-21])&0xFF,int(mapData[mapData.length-20])&0xFF);
  byte[] map = new byte[0];
  int p = 0;
  tex = new Gif[255];
  java.util.Arrays.fill(tex,new Gif());
  world = new FWorld(-128,-128,lWidth*128+128,lHeight*128+128);
  world.setGravity(mapData[mapData.length-24]*10,mapData[mapData.length-23]*10);
  if(fileType=='3') {
    int contents = mapData[mapData.length-17]&0xFF;
    while(contents!=0) {
      p = 2147483647;//long code gooooo
      byte nextSeg = 0;
      int temp = 0;
      String[] headers = {"Textures","Map Layout","Enemies"};
      for(byte i=0;i<headers.length;i++) {
        if(contents%pow(2,i+1)/pow(2,i)>0) {
          temp = new String(mapData).indexOf(headers[i]);
          if(temp<p&&temp!=-1){p=temp;nextSeg=(byte)(i+1);}
        }
      }
      switch(nextSeg) {
      case 1:
        p = loadTextures(split(new String(subset(mapData,p+8)),(char)0))+8;
        contents^=0x1;
        break;
      case 2:
        p = makeChunks(subset(mapData,p+10),lWidth,lHeight,fileType)+10;
        contents^=0x2;
        break;
      case 3:
        p += makeEnemies(int(subset(mapData,p+7)))+7;
        contents^=0x4;
        break;
      default:
        throw new RuntimeException("Invalid Next Level Segment");
      }
      mapData = subset(mapData,p);
    }
  } else {
    map = mapData;
    //nobody touch the code below its a monster
    if(fileType!='1'){String[]s = split(new String(subset(map,0,map.length-33-map[map.length-26])),(char)0);loadTextures(subset(s,s.length-map[map.length-25]));makeEnemies(int(subset(map,lWidth*lHeight)));}
    makeChunks(mapData,lWidth,lHeight,fileType);
  }
  you = new player(3,(256*bi(mapData[mapData.length-30]))+bi(mapData[mapData.length-29]),(256*bi(mapData[mapData.length-28]))+bi(mapData[mapData.length-27]));
  world.add(you);
  //new TestBot(1,1,640,480);
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
  return p+1;
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

int makeChunks(byte[] map, int lWidth, int lHeight, int fileType) {
  int p = 0;
  chunks = new FCompound[lWidth*lHeight];
  for(int j=0;j<lHeight;j++){
    for(int i=0;i<lWidth;i++) {
      //int chunk = fileType=='3'?p/2:j*lWidth+i;
      int chunk = j*lWidth+i;
      byte ID = map[fileType=='3'?p:chunk*(fileType=='1'?1:2)];
      int texture = fileType=='1'?0:map[1+(fileType=='2'?chunk*2:p)]; //<>//
      texture&=0xFF;
      texture-=1;
      p+=2;
      chunks[chunk] = new FCompound();
      switch(ID){
      case 1:
        FBox gnd = new FBox(128,127);
        gnd.setPosition(65,65.5);
        gnd.setName("00");
        FLine jmp = new FLine(1,1,129,1);
        jmp.setName("01");
        FBox img;
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(65,65);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd,jmp});
        }p++;
        chunks[chunk].addBody(gnd);
        chunks[chunk].addBody(jmp);
        chunks[chunk].setPosition(128*i-1,128*j-1);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 2:
        gnd = new FBox(128,128);
        gnd.setPosition(64,64);
        gnd.setName("00");
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          slo.setNoFill();
          slo.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{slo,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          slo.setNoFill();
          slo.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{slo,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(65,65);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(65,65);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          slo.setNoFill();
          slo.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{slo,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          slo.setNoFill();
          slo.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{slo,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(65,65);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(65,65);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(65,65);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
          jmp.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd,jmp});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd});
        }p++;
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
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd});
        }p++;
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      case 0x12:
        gnd = new FBox(128,128);
        gnd.setPosition(64,64);
        gnd.setName("00100001");
        gnd.setFillColor(0xFF7F7FFF);
        gnd.setFriction(0);
        gnd.setSensor(true);
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
          gnd.setNoFill();
          gnd.setNoStroke();
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{gnd});
        }p++;
        chunks[chunk].addBody(gnd);
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      default: //air for unimplemented chunks
        if(texture!=-1){
          img = new FBox(128,128);
          img.attachImage(tex[texture]);
          img.setSensor(true);
          img.setStatic(true);
          img.setName("1000");
          img.setPosition(64,64);
          chunks[chunk].addBody(img);
        }
        if(fileType==3)while(bi(map[p])!=0xFF) {
          p += extendChunk(subset(map,p),new FBody[]{});
        }p++;
        chunks[chunk].setPosition(128*i,128*j);
        chunks[chunk].setStatic(true);
        world.add(chunks[chunk]);
        break;
      }
    }
  }
  return p;
}

int extendChunk(byte[] stuff, FBody[] parts) {
  int p = 0;
  switch(stuff[p]){
  case 1:
    //get flags and | everything
    p+=2;
    break;
  case 2:
    //gotta implement speech itself first...
    //playSpeech(p+1);
    p+=2;
    break;
  case 3:
    //guh...
    p+=5;
    break;    
  case 4:
    //for(FBody part:parts)part.setFillColor();
  }
  return p;
}

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

void APressed(){if(keys[2]==0)keys[2]=1;}
void AReleased(){keys[2]=0;}
void HPressed(float x) {
  if(x<0){if(keys[0]==0)keys[0]=1;keys[1]=0;}
  if(x==0){keys[0]=0;keys[1]=0;}
  if(x>0){keys[0]=0;if(keys[1]==0)keys[1]=1;}
}

/*
Credits! (because i thought it would be nice.)

Me - literally everything used in the game
Richard Marxer - the fisica library
Processing contributors - the sound library
um thats it unless you count Kitta for emotional support

Tools Used

Furnace - all sound effects and music
MS Paint - simple graphics
GIMP - advanced graphics
Processing - y'know, the thing that runs this code
*/
