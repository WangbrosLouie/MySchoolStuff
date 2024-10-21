/* Title: Iwannamakesoccar *\
|* Author: Louie Wang      *|
|* Description: rocket     *|
|* league sideswipe ahh    *|
\*_Date:_Oct.10,_2024______*/

import fisica.*;
import processing.sound.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

//classes and stuff
class Gif extends PImage {
  int frames = 0;
  int currentFrame = 0;
  float interval = 0;
  PImage[] images;
  Gif(int FRAMES, float INTERVAL, String filename, String suffix) {
    super(1,1,ARGB);
    frames = FRAMES;
    interval = INTERVAL;
    images = new PImage[frames];
    for(int i=0;i<frames;i++)images[i] = loadImage(filename+i+suffix);
    super.init(images[0].width,images[0].height,ARGB);
    images[0].loadPixels();
    int[] temp = new int[images[0].pixels.length];
    arrayCopy(images[0].pixels,temp);
    images[0].updatePixels();
    super.loadPixels();
    arrayCopy(temp,super.pixels);
    super.updatePixels();
  }
  
  void update() {
    currentFrame++;
    int frm = floor(currentFrame/interval)%frames;
    super.init(images[frm].width,images[frm].height,ARGB);
    images[frm].loadPixels();
    int[] temp = new int[images[frm].pixels.length];
    arrayCopy(images[frm].pixels,temp);
    images[frm].updatePixels();
    super.loadPixels();
    arrayCopy(temp,super.pixels);
    super.updatePixels();
  }
}

class Button {
  int Type = 0; //positive type is text, negative type is image
  int X = 0;
  int Y = 0;
  int XSize = 0;
  int YSize = 0;
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
  Button(int tYPE, int DOwHAT, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, color hoUT, color hiN, color poUT, color piN, color toUT, color thOV, color tiN, String TEXT) {
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

byte screen = 2;
int Btn = 0;
//arena size variables
int AWidth;
int AHeight;
int goalHeight;
//player status vars
int scor1 = 0;
int scor2 = 0;
int boos1 = 100;
int boos2 = 100;
byte jmp1 = 0;
byte jmp2 = 0;
//camera variables
float ballVelo = 0;
int camX = 0;
int camY = 0;
boolean dispBG = true;//add a button to toggle this
//game control
boolean loading = true;
boolean halfFPS = true;
boolean paused = false;
boolean afterParty = false;
//replay variables
boolean replaying = false;
int replayFrame = 0;
int lastGoal = 0;
int goalSpeed = 0;
//fixed variables
final int tireSpeed = 100;
final int tireSpeed30 = 720;
final int tireSpeedMax = 500;
final int jumpPower = 15000;
final int boostPower = 500;
final int boostPower30 = 1000;
final int replayLength = 150;
final float bgX = 300;
final float bgY = 200;
final float tireSoftness = 1;
//physics variables
FWorld myWorld, play1, play2;
FBox floor, lwall, rwall, roofe, lgol1, lgol2, rgol1, rgol2, lgoal, rgoal;
FPoly frame, fram2;
FCircle ball, tire1, tire2, tire3, tire4, carp1, carp2;
FDistanceJoint[] axles;
//other class variables
Gif bg;
SoundFile bgm;
PImage tire;
PImage[] replay = new PImage[0];
PGraphics gcar1, gcar2, pcar1, pcar2, Hitbox;
PFont Lucid;
boolean[] Keys = new boolean[20]; //0-5 keys 6&7 debounce for jump key 8-11 wheels touching floor? 12&13 can jump? 14&&15 body touching floor?
Button play30 = new Button(1, 1, width/8, height/2, width/4*3, height/8, color(0), color(50,83,184), color(0), color(30,60,150), color(0), color(10,23,100), color(0), color(0), color(0),"Play with 30 FPS");
Button play60;
Button pause;
//controller stuff
ControlIO CtrlIO;
ControlDevice N64;
ControlHat DPad;
ControlButton A, L, R;

void settings() {
  Fisica.init(this);
  size(640,480);
}

void setup() {
  //loading screen 'w'
  push();
  background(255);
  tire = loadImage("=3.PNG");
  image(tire,0,0,width,height);
  textSize(64);
  fill(0);
  textAlign(CENTER,CENTER);
  text("Loading...",width/2,height/2);
  pop();
  Lucid = createFont("Lucida Console",14,false);
}

//controller plugs
void APressed(){Keys[2]=true;}
void LPressed(){Keys[16]=true;}
void RPressed(){Keys[17]=true;}
void AReleased(){Keys[2]=false;}
void LReleased(){Keys[16]=false;}
void RReleased(){Keys[17]=false;}
//2 dummy float params needed for ControlHat's plug() to work
//also the stupid values dont even update in time for the plug
void HPressed(float x) {
  if(x<0){Keys[0]=true;Keys[1]=false;}
  if(x==0){Keys[0]=false;Keys[1]=false;}
  if(x>0){Keys[0]=false;Keys[1]=true;}
}

void draw() {
  switch(screen) {
  case 0://title screen
    play30.draw();
    play60.draw();
    break;
  case 1://ingame
    if(loading) {//draw the loadscreen
      loading = false;
      frameRate(30);
      AWidth = width*4;//note to self: dont use width or height outside of a function if settings() is used
      AHeight = height*3;
      goalHeight = height;
      java.util.Arrays.fill(Keys,false);
      bg = new Gif(53,3,"chip/",".png");//load assets
      bgm = new SoundFile(this,"grent_looped.ogg");
      for(int i=0;i<replay.length;i++) {
        replay[i] = new PImage(width,height,RGB);
      }
      tire.resize(30,30);
      //initialize physics instances
      myWorld = new FWorld(-AWidth/2+width-500,-AHeight+height-100,AWidth/2+width+500,height+100);
      myWorld.setGrabbable(false);
      myWorld.setGravity(0,500);
      ball = new FCircle(60);
      ball.setPosition(width/2,height-31);
      ball.setFriction(0.5);
      ball.setDensity(0.1);
      ball.setRestitution(1);
      ball.setBullet(true);
      ball.setAllowSleeping(false);
      myWorld.add(ball);
      makeImages();
      makeArena();
      makeCars();
      //controller detection
      CtrlIO = ControlIO.getInstance(this);
      ControlDevice[] Controllers = CtrlIO.getDevices().toArray(new ControlDevice[0]); 
      if(Controllers.length>3) {
        N64 = Controllers[2];
        N64.open();
        A = N64.getButton(2);
        L = N64.getButton(7);
        R = N64.getButton(8);
        DPad = N64.getHat(0);
        A.plug("APressed",ControlIO.ON_PRESS);
        L.plug("LPressed",ControlIO.ON_PRESS);
        R.plug("RPressed",ControlIO.ON_PRESS);
        A.plug("AReleased",ControlIO.ON_RELEASE);
        L.plug("LReleased",ControlIO.ON_RELEASE);
        R.plug("RReleased",ControlIO.ON_RELEASE);
      }
      bgm.loop();
    } else if(replaying) {
      background(0);
      if(replay.length<replayLength)image(replay[frameCount-replayFrame-1],0,0,width,height);
      else image(replay[frameCount%replay.length],0,0,width,height);
      text(goalSpeed,200,height-50);
      text(toTime(lastGoal,replayFrame),width-100,height-50);
      if(frameCount-replayFrame>replay.length-1) {
        replaying=false;
        replay = new PImage[0];
        frameCount = replayFrame;
      }
    } else {
      //process gameplay
      if(halfFPS)processKeys30fps();else processKeys();
      if(!(N64==null))HPressed(DPad.getX());
      boos1 = constrain(boos1,0,100);
      boos2 = constrain(boos2,0,100);
      myWorld.step();
      if(halfFPS)myWorld.step();
      //camera stuff
      ballVelo = constrain(lerp(ballVelo,round(pow((dist(0,0,ball.getVelocityX(),ball.getVelocityY())+1)*0.01,2)/0.5)*0.5,0.25),0.5,50);
      if(mousePressed) {
        camX += mouseX-pmouseX;
        camY += mouseY-pmouseY;
      }
      background(200);
      if(drawBG) {
        bg.update();
        for(int i=-1;i<1+height/bgY;i++) {
          for(int j=-1;j<1+width/bgX;j++) {
            image(bg,(j*bgX)+(-ball.getX()/10%bgX),(i*bgY)-(-ball.getY()/10%bgY),bgX,bgY);
          }
        }
      }
      push();
      translate(round((width-ball.getX())/2)+ballVelo+camX,round((height-ball.getY())/2)+ballVelo+camY);
      scale(0.5-ballVelo/400);
      fill(200);//bg scoreboard
      rect(width/2-25,height,50,-200);
      rect(width/2-100,height-250,200,50);
      strokeWeight(10);
      line((-AWidth/2)+(width/2)+295,height-goalHeight,(-AWidth/2)+(width/2)+295,height);
      line((AWidth/2)+(width/2)-295,height-goalHeight,(AWidth/2)+(width/2)-295,height);
      myWorld.draw();
      saveReplayFrame();
      //draw player trackers
      PVector temp = PVector.sub(new PVector(ball.getX(),ball.getY()),new PVector(frame.getX(),frame.getY())).normalize().mult(ball.getSize());
      stroke(80,110,255,127);
      line(ball.getX(),ball.getY(),ball.getX()-temp.x,ball.getY()-temp.y);
      stroke(240,130,30,127);
      temp = PVector.sub(new PVector(ball.getX(),ball.getY()),new PVector(fram2.getX(),fram2.getY())).normalize().mult(ball.getSize());
      line(ball.getX(),ball.getY(),ball.getX()-temp.x,ball.getY()-temp.y);
      pop();
      textSize(50);
      fill(0);
      rect(0,height,100,-30);
      rect(width,height,-100,-30);
      fill(boos1*2.55,0,0);
      rect(0,height,boos1,-30);
      fill(boos2*2.55,0,0);
      rect(width,height,-boos2,-30);
      fill(0);
      rect(width/2-75,0,150,60);
      fill(255);
      textAlign(CENTER,CENTER);
      text(toTime(frameCount,halfFPS?30*300:60*300),width/2,25);
      textAlign(LEFT,CENTER);
      text(scor1,30,30);
      text(boos1,0,height-25);
      textAlign(RIGHT,CENTER);
      text(scor2,width-30,30);
      text(boos2,width,height-25);
      carp1.setRotation(frame.getRotation());
      carp2.setRotation(fram2.getRotation());
      pcar1 = createGraphics(100,100);
      pcar2 = createGraphics(100,100);
      pcar1.beginDraw();
      pcar2.beginDraw();
      carp1.draw(pcar1);
      carp2.draw(pcar2);
      pcar1.endDraw();
      pcar2.endDraw();
      image(pcar1,0,height-130,100,100);
      image(pcar2,width-100,height-130,100,100);
      push();
      textFont(createFont("Unifont",36));
      textAlign(CENTER,CENTER);
      colorMode(HSB);
      fill(frameCount*11%255,255,255);
      if(afterParty) {
        text("ゴール！",width/2,height/2);
        ball.setFill(255,255-((float)(frameCount-replayFrame)/(replayLength/5))*255);
        if(frameCount-replayFrame>replayLength/5){replaying=true;reset();afterParty=false;if(replay.length<replayLength)frameCount=replayFrame;}
      }
      text(frameRate,width/2,height*3/4);
      pop();
    }
    break;
  default:
//funny ^w^
    blueDead("Screen "+screen,"404 Not Found","Screen = "+screen);
  }
}

void makeArena() {
  floor = new FBox(AWidth,100);
  floor.setPosition(width/2,height+50);
  roofe = new FBox(AWidth-500,100);
  roofe.setPosition(width/2,-AHeight+height-50);
  lwall = new FBox(50,AHeight-goalHeight);
  lwall.setPosition((-AWidth/2)+(width/2)+275,height-(AHeight/2)-(goalHeight/2));
  lgol1 = new FBox(300,50);
  lgol1.setPosition((-AWidth/2)+(width/2)+150,height-goalHeight);
  lgol2 = new FBox(50,goalHeight+25);
  lgol2.setPosition((-AWidth/2)+(width/2)+25,height/2-12.5);
  rwall = new FBox(50,AHeight-goalHeight);
  rwall.setPosition((AWidth/2)+(width/2)-275,height-(AHeight/2)-(goalHeight/2));
  rgol1 = new FBox(300,50);
  rgol1.setPosition((AWidth/2)+(width/2)-150,height-goalHeight);
  rgol2 = new FBox(50,goalHeight+25);
  rgol2.setPosition((AWidth/2)+(width/2)-25,height/2-12.5);
  lgoal = new FBox(250-ball.getSize(),goalHeight-25);
  lgoal.setPosition((-AWidth/2)+(width/2)+175-(ball.getSize()/2),height/2+12.5);
  rgoal = new FBox(250-ball.getSize(),goalHeight-25);
  rgoal.setPosition((AWidth/2)+(width/2)-175+(ball.getSize()/2),height/2+12.5);
  floor.setStatic(true);
  roofe.setStatic(true);
  lwall.setStatic(true);
  lgol1.setStatic(true);
  lgol2.setStatic(true);
  rwall.setStatic(true);
  rgol1.setStatic(true);
  rgol2.setStatic(true);
  lgoal.setStatic(true);
  rgoal.setStatic(true);
  lgoal.setSensor(true);
  rgoal.setSensor(true);
  lgoal.setNoFill();
  rgoal.setNoFill();
  lgoal.setNoStroke();
  rgoal.setNoStroke();
  myWorld.add(floor);
  myWorld.add(roofe);
  myWorld.add(lwall);
  myWorld.add(lgol1);
  myWorld.add(lgol2);
  myWorld.add(rwall);
  myWorld.add(rgol1);
  myWorld.add(rgol2);
  myWorld.add(lgoal);
  myWorld.add(rgoal);
}

void makeCars() {
  frame = new FPoly();
  frame.vertex(0,20);
  frame.vertex(20,20);
  frame.vertex(30,0);
  frame.vertex(70,0);
  frame.vertex(80,20);
  frame.vertex(100,20);
  frame.vertex(100,50);
  frame.vertex(0,50);
  frame.setPosition(0,height-125);
  frame.setDensity(3);
  fram2 = new FPoly();
  fram2.vertex(0,20);
  fram2.vertex(20,20);
  fram2.vertex(30,0);
  fram2.vertex(70,0);
  fram2.vertex(80,20);
  fram2.vertex(100,20);
  fram2.vertex(100,50);
  fram2.vertex(0,50);
  fram2.setPosition(width-100,height-125);
  fram2.setDensity(3);
  tire1 = new FCircle(30);
  tire2 = new FCircle(30);
  tire3 = new FCircle(30);
  tire4 = new FCircle(30);
  tire1.setPosition(20,height-80);
  tire2.setPosition(80,height-80);
  tire3.setPosition(width-80,height-80);
  tire4.setPosition(width-20,height-80);
  tire1.setFriction(10);
  tire2.setFriction(10);
  tire3.setFriction(10);
  tire4.setFriction(10);
  tire1.setBullet(true);
  tire2.setBullet(true);
  tire3.setBullet(true);
  tire4.setBullet(true);
  axles = new FDistanceJoint[] {new FDistanceJoint(frame,tire1),
  new FDistanceJoint(frame,tire2),
  new FDistanceJoint(fram2,tire3),
  new FDistanceJoint(fram2,tire4)};
  for(int i=0;i<2;i++) {
    axles[i*2].setAnchor1(20,50);
    axles[i*2].setAnchor2(0,0);
    axles[i*2].setLength(0);
    axles[i*2].setDamping(0);
    axles[i*2+1].setAnchor1(80,50);
    axles[i*2+1].setAnchor2(0,0);
    axles[i*2+1].setLength(0);
    axles[i*2+1].setDamping(0);
  }
  frame.setGroupIndex(-1);
  tire1.setGroupIndex(-1);
  tire2.setGroupIndex(-1);
  fram2.setGroupIndex(-2);
  tire3.setGroupIndex(-2);
  tire4.setGroupIndex(-2);
  frame.setFill(80,110,255);
  fram2.setFill(240,130,30);
  tire1.setFill(0);
  tire2.setFill(0);
  tire3.setFill(0);
  tire4.setFill(0);
  tire1.setRestitution(tireSoftness);
  tire2.setRestitution(tireSoftness);
  tire3.setRestitution(tireSoftness);
  tire4.setRestitution(tireSoftness);
  //tire1.attachImage(tire);
  //tire2.attachImage(tire);
  //tire3.attachImage(tire);
  //tire4.attachImage(tire);
  myWorld.add(frame);
  myWorld.add(fram2);
  myWorld.add(tire1);
  myWorld.add(tire2);
  myWorld.add(tire3);
  myWorld.add(tire4);
  for(int i=0;i<4;i++) {
    axles[i].setDrawable(false);
    myWorld.add(axles[i]);
  }
}

void makeImages() {//for car rotation view
  play1 = new FWorld(0,0,100,100);
  play2 = new FWorld(0,0,100,100);
  gcar1 = createGraphics(100,100);
  gcar2 = createGraphics(100,100);
  gcar1.beginDraw();
  gcar1.fill(80,110,255);
  gcar1.beginShape();
  gcar1.vertex(0,45);
  gcar1.vertex(20,45);
  gcar1.vertex(30,25);
  gcar1.vertex(70,25);
  gcar1.vertex(80,45);
  gcar1.vertex(100,45);
  gcar1.vertex(100,75);
  gcar1.vertex(0,75);
  gcar1.endShape(CLOSE);
  gcar1.fill(0);
  gcar1.circle(20,75,30);
  gcar1.circle(80,75,30);
  gcar1.endDraw();
  gcar2.beginDraw();
  gcar2.fill(240,130,30);
  gcar2.beginShape();
  gcar2.vertex(0,45);
  gcar2.vertex(20,45);
  gcar2.vertex(30,25);
  gcar2.vertex(70,25);
  gcar2.vertex(80,45);
  gcar2.vertex(100,45);
  gcar2.vertex(100,75);
  gcar2.vertex(0,75);
  gcar2.endShape(CLOSE);
  gcar2.fill(0);
  gcar2.circle(20,75,30);
  gcar2.circle(80,75,30);
  gcar2.endDraw();
  carp1 = new FCircle(50);
  carp2 = new FCircle(50);
  carp1.setPosition(50,50);
  carp2.setPosition(50,50);
  carp1.attachImage(gcar1);
  carp2.attachImage(gcar2);
  carp1.setStatic(true);
  carp2.setStatic(true);
}

void reset() {
  push();
  colorMode(RGB);
  ball = new FCircle(60);
  ball.setPosition(width/2,height-31);
  ball.setFriction(0.5);
  ball.setDensity(0.1);
  ball.setRestitution(1);
  ball.setBullet(true);
  ball.setAllowSleeping(false);
  myWorld.add(ball);
  myWorld.clear();
  makeArena();
  makeCars();
  boos1 = 100;
  boos2 = 100;
  pop();
}

void saveReplayFrameRedraw() {//very laggy maybe dont use
  replay[frameCount%replay.length].beginDraw();
  replay[frameCount%replay.length].background(0);
  replay[frameCount%replay.length].push();
  replay[frameCount%replay.length].translate(round((width-ball.getX())/2)+ballVelo+camX,round((height-ball.getY())/2)+ballVelo+camY);
  replay[frameCount%replay.length].scale(0.5-ballVelo/400);
  replay[frameCount%replay.length].fill(200);
  replay[frameCount%replay.length].rect(width/2-25,height,50,-200);
  replay[frameCount%replay.length].rect(width/2-100,height-250,200,50);
  replay[frameCount%replay.length].strokeWeight(10);
  replay[frameCount%replay.length].line((-AWidth/2)+(width/2)+295,height-goalHeight,(-AWidth/2)+(width/2)+295,height);
  replay[frameCount%replay.length].line((AWidth/2)+(width/2)-295,height-goalHeight,(AWidth/2)+(width/2)-295,height);
  myWorld.draw(replay[frameCount%replay.length]);
  replay[frameCount%replay.length].pop();
  replay[frameCount%replay.length].endDraw();
  println(frameCount%replay.length);
}

void saveReplayFrame() {
  loadPixels();
  if(replay.length<replayLength) {
    replay = (PImage[])append(replay,new PImage(width,height,RGB));
    replay[replay.length-1].loadPixels();
    arrayCopy(pixels,replay[replay.length-1].pixels);
    replay[replay.length-1].updatePixels();
  } else {
    replay[frameCount%replay.length].loadPixels();
    arrayCopy(pixels,replay[frameCount%replay.length].pixels);
    replay[frameCount%replay.length].updatePixels();
  }
  updatePixels();
}

void processKeys() {//backport stuff from the 30 fps version
//or maybe merge functions and use some halfFPS?30fps:60fps
  if(Keys[0]){
    tire1.addTorque(-tireSpeed);
    tire2.addTorque(-tireSpeed/2);
    if(!Keys[8]&&!Keys[9])frame.addTorque(-500);
  }
  if(Keys[1]){
    tire1.addTorque(tireSpeed/2);
    tire2.addTorque(tireSpeed);
    if(!Keys[8]&&!Keys[9])frame.addTorque(500);
  }
  if(Keys[2]&&!Keys[6]&&Keys[12]){
    PVector jump = PVector.fromAngle(frame.getRotation()-HALF_PI).mult(jumpPower);
    frame.addImpulse(jump.x,jump.y,0,25);
    Keys[12] = false;
  } else if(Keys[2]&&!Keys[6]&&!(Keys[8]&&Keys[9])&&Keys[14]) {//flip car
    frame.setAngularVelocity(-frame.getRotation()*4);
    frame.addImpulse(0,2500,0,0);
  }
  if(!(Keys[16]&&Keys[17])) {
    if(Keys[16]&&boos1>0) {PVector jump = PVector.fromAngle(frame.getRotation()-PI).mult(boostPower);
      frame.addImpulse(jump.x,jump.y,0,0);
      boos1 -= 1;
    }else if(Keys[17]&&boos1>0) {PVector jump = PVector.fromAngle(frame.getRotation()).mult(boostPower);
      frame.addImpulse(jump.x,jump.y,0,0);
      boos1 -= 1;
    }
  }
  if(!(Keys[16]||Keys[17])) {
    boos1 += 1;
  }
  if(Keys[3]){
    tire3.addTorque(-tireSpeed);
    tire4.addTorque(-tireSpeed/2);
    if(!Keys[10]&&!Keys[11])fram2.addTorque(-500);
  }
  if(Keys[4]){
    tire3.addTorque(tireSpeed/2);
    tire4.addTorque(tireSpeed);
    if(!Keys[10]&&!Keys[11])fram2.addTorque(500);
  }
  if(Keys[5]&&!Keys[7]&&Keys[13]){
    PVector jump = PVector.fromAngle(fram2.getRotation()-HALF_PI).mult(jumpPower);
    fram2.addImpulse(jump.x,jump.y,0,25);
    Keys[13] = false;
  } else if(Keys[5]&&!Keys[7]&&!(Keys[10]&&Keys[11])&&Keys[15]) {//flip car
    fram2.setAngularVelocity(-fram2.getRotation()*4);
  }
  if(!(Keys[18]&&Keys[19])){
    if(Keys[18]&&boos2>0) {PVector jump = PVector.fromAngle(fram2.getRotation()-PI).mult(boostPower);
      fram2.addImpulse(jump.x,jump.y,0,0);
      boos2 -= 1;
    }
    if(Keys[19]&&boos2>0) {PVector jump = PVector.fromAngle(fram2.getRotation()).mult(boostPower);
      fram2.addImpulse(jump.x,jump.y,0,0);
      boos2 -= 1;
    }
  }
  if(Keys[2]&&!Keys[6])Keys[6]=true;
  if(Keys[6]&&!Keys[2])Keys[6]=false;
  if(Keys[5]&&!Keys[7])Keys[7]=true;
  if(Keys[7]&&!Keys[5])Keys[7]=false;
  if(jmp1>0)Keys[12]=true;
  if(jmp2>0)Keys[13]=true;
  tire1.setAngularVelocity(constrain(tire1.getAngularVelocity(),-tireSpeedMax,tireSpeedMax));
  tire2.setAngularVelocity(constrain(tire2.getAngularVelocity(),-tireSpeedMax,tireSpeedMax));
  tire3.setAngularVelocity(constrain(tire3.getAngularVelocity(),-tireSpeedMax,tireSpeedMax));
  tire4.setAngularVelocity(constrain(tire4.getAngularVelocity(),-tireSpeedMax,tireSpeedMax));
  frame.setRotation((((((frame.getRotation()+PI)%TAU)+TAU)%TAU)-PI));
  fram2.setRotation((((((fram2.getRotation()+PI)%TAU)+TAU)%TAU)-PI));
}

void processKeys30fps() {
  if(Keys[0]){
    tire1.addTorque(-tireSpeed30);
    tire2.addTorque(-tireSpeed30/2);
    if(!Keys[8]&&!Keys[9])frame.addTorque(-1000);
  }
  if(Keys[1]){
    tire1.addTorque(tireSpeed30/2);
    tire2.addTorque(tireSpeed30);
    if(!Keys[8]&&!Keys[9])frame.addTorque(1000);
  }
  if(Keys[2]&&!Keys[6]&&Keys[12]){
    PVector jump = PVector.fromAngle(frame.getRotation()-HALF_PI).mult(jumpPower);
    frame.addImpulse(jump.x,jump.y,0,25);
    Keys[12] = false;
  } else if(Keys[2]&&!Keys[6]&&!(Keys[8]&&Keys[9])&&Keys[14]) {//flip car
    frame.setAngularVelocity(-frame.getRotation()*4);
    frame.addImpulse(0,2500,0,0);
  }
  if(!(Keys[16]&&Keys[17])) {
    if(Keys[16]&&boos1>0) {PVector jump = PVector.fromAngle(frame.getRotation()-PI).mult(boostPower30);
      frame.addImpulse(jump.x,jump.y,0,0);
      boos1 -= 1;
    }else if(Keys[17]&&boos1>0) {PVector jump = PVector.fromAngle(frame.getRotation()).mult(boostPower30);
      frame.addImpulse(jump.x,jump.y,0,0);
      boos1 -= 1;
    }
  }
  if(!(Keys[16]||Keys[17])) {
    boos1 += 1;
  }
  if(Keys[3]){
    tire3.addTorque(-tireSpeed30);
    tire4.addTorque(-tireSpeed30/2);
    if(!Keys[10]&&!Keys[11])fram2.addTorque(-1000);
  }
  if(Keys[4]){
    tire3.addTorque(tireSpeed30/2);
    tire4.addTorque(tireSpeed30);
    if(!Keys[10]&&!Keys[11])fram2.addTorque(1000);
  }
  if(Keys[5]&&!Keys[7]&&Keys[13]){
    PVector jump = PVector.fromAngle(fram2.getRotation()-HALF_PI).mult(jumpPower);
    fram2.addImpulse(jump.x,jump.y,0,25);
    Keys[13] = false;
  } else if(Keys[5]&&!Keys[7]&&!(Keys[10]&&Keys[11])&&Keys[15]) {//flip car
    fram2.setAngularVelocity(-fram2.getRotation()*4);
  }
  if(!(Keys[18]&&Keys[19])){
    if(Keys[18]&&boos2>0) {PVector jump = PVector.fromAngle(fram2.getRotation()-PI).mult(boostPower30);
      fram2.addImpulse(jump.x,jump.y,0,0);
      boos2 -= 1;
    }
    if(Keys[19]&&boos2>0) {PVector jump = PVector.fromAngle(fram2.getRotation()).mult(boostPower30);
      fram2.addImpulse(jump.x,jump.y,0,0);
      boos2 -= 1;
    }
  }
  if(!(Keys[18]||Keys[19])) {
    boos2 += 1;
  }
  if(Keys[2]&&!Keys[6])Keys[6]=true;
  if(Keys[6]&&!Keys[2])Keys[6]=false;
  if(Keys[5]&&!Keys[7])Keys[7]=true;
  if(Keys[7]&&!Keys[5])Keys[7]=false;
  if(jmp1>0)Keys[12]=true;
  if(jmp2>0)Keys[13]=true;
  tire1.setAngularVelocity(constrain(tire1.getAngularVelocity(),-tireSpeedMax,tireSpeedMax));
  tire2.setAngularVelocity(constrain(tire2.getAngularVelocity(),-tireSpeedMax,tireSpeedMax));
  tire3.setAngularVelocity(constrain(tire3.getAngularVelocity(),-tireSpeedMax,tireSpeedMax));
  tire4.setAngularVelocity(constrain(tire4.getAngularVelocity(),-tireSpeedMax,tireSpeedMax));
  frame.setRotation((((((frame.getRotation()+PI)%TAU)+TAU)%TAU)-PI));
  fram2.setRotation((((((fram2.getRotation()+PI)%TAU)+TAU)%TAU)-PI));
}

String toTime(int first, int second) {//cause im lazy
  int elapsed = halfFPS?(second-first)/30:(second-first)/60;
  int minutes = elapsed/60;
  int seconds = elapsed%60;
  return(String.format(minutes+":"+"%1$02d",seconds));
}

//backported from tophat clicker(dont ask)!
void blueDead(String CALLEDFR, String STOPCODE, String INFOSCND) { //funny
  background(#000080);
  fill(255);
  textFont(Lucid);
  text("A problem has been detected and Windows has halted your application to\nprevent further damage to your computer.\n\nThis application has called for\n"+CALLEDFR+"\nbut it was not found.\n\nIf this is the first time you've seen this STOP error screen,\nrestart the application. If this screen appears again, try these steps:\n\nCheck to make sure that you haven't modified the application in any way\nshape or form. It may be corrupted. Check that there are no warnings in the\nProcessing 4 console.\n\nIf problems continue, contact the developer of the application and see if\nthey have an updated version of the application that has bug fixes that may\npertain to this issue. Alternatively, give the information below to the\ndeveloper to aid them in the fixing of this problem.\n\nTechnical information:\n\n*** STOP: "+STOPCODE+"\n\n***    "+INFOSCND, 0, 24);
}

void keyPressed() {
  switch(keyCode){
  case 65:
    Keys[0] = true;
    break;
  case 68:
    Keys[1] = true;
    break;
  case 87:
    Keys[2] = true;
    break;
  case 127:
    Keys[3] = true;
    break;
  case 34:
    Keys[4] = true;
    break;
  case 36:
    Keys[5] = true;
    break;
  case 81:
    Keys[16] = true;
    break;
  case 69:
    Keys[17] = true;
    break;
  case 155://insert on windows
    Keys[18] = true;
    break;
  case 156://insert on mac
    Keys[18] = true;
    break;
  case 33:
    Keys[19] = true;
    break;
  }
}

void keyReleased() {
  switch(keyCode){
  case 65:
    Keys[0] = false;
    break;
  case 68:
    Keys[1] = false;
    break;
  case 87:
    Keys[2] = false;
    break;
  case 127:
    Keys[3] = false;
    break;
  case 34:
    Keys[4] = false;
    break;
  case 36:
    Keys[5] = false;
    break;
  case 81:
    Keys[16] = false;
    break;
  case 69:
    Keys[17] = false;
    break;
  case 155:
    Keys[18] = false;
    break;
  case 156:
    Keys[18] = false;
    break;
  case 33:
    Keys[19] = false;
    break;
  }
}
//finish implementing buttons

void mousePressed() {
  int Action = Hitbox.get(mouseX,mouseY);
  Btn = round(red(Action))*0x100+round(green(Action))*0x100+ceil(blue(Action));
}

void mouseReleased() {
  int Action = Hitbox.get(mouseX,mouseY);
  Action = round(red(Action))*0x100+round(green(Action))*0x100+ceil(blue(Action));
  if(Action==Btn&&Action!=0) {
    Action = Btns[Action-1].doWhat;
    switch(Action) {
    case 1:
      if(BGCol>0)BGCol--;else BGCol=0;
      break;
    case 2:
      if(BGCol<0xF)BGCol++;else BGCol=0xF;
      break;
    case 3:
      Btns[Action-1].XSize+=3;
      Btns[Action-1].YSize+=3;
      break;
    default:
      
    }
  }
  Btn = 0;
}

void process(Button[] B, PGraphics H) {
  H.beginDraw();
  H.background(0);
  for(int i=0;i<B.length;i++)B[i].drawHit(i,H);
  for(int i=0;i<B.length;i++) {//draw buttons
    byte Status = 0;
    int Hover = Hitbox.get(mouseX,mouseY);
    Hover = round(red(Hover))*0x100+round(green(Hover))*0x100+ceil(blue(Hover));
    if(Hover-1==i)Status = 1;
    if(Btn-1==i)Status = 2;
    B[i].draw(Status);
  }
  H.endDraw();
}

void contactStarted(FContact contact) { //add boost if car is on ground and not boosting like in sideswipe
  if(contact.contains(tire1,floor))jmp1++;
  if(contact.contains(tire2,floor))jmp1++;
  if(contact.contains(tire3,floor))jmp2++;
  if(contact.contains(tire4,floor))jmp2++;
  if(contact.contains(tire1,ball))jmp1++;
  if(contact.contains(tire2,ball))jmp1++;
  if(contact.contains(tire3,ball))jmp2++;
  if(contact.contains(tire4,ball))jmp2++;
  if(contact.contains(frame,floor))Keys[14]=true;
  if(contact.contains(fram2,floor))Keys[15]=true;
  if(!afterParty) {
    if(contact.contains(ball,rgoal)){scor1++;ball.setNoStroke();lastGoal=replayFrame;replayFrame=frameCount;afterParty=true;goalSpeed=round(dist(0,0,ball.getVelocityX(),ball.getVelocityY()));}
    if(contact.contains(ball,lgoal)){scor2++;ball.setNoStroke();lastGoal=replayFrame;replayFrame=frameCount;afterParty=true;goalSpeed=round(dist(0,0,ball.getVelocityX(),ball.getVelocityY()));}
  }
}

void contactPersisted(FContact contact) {
  if(contact.contains(frame,floor))Keys[14]=true;
  if(contact.contains(fram2,floor))Keys[15]=true;
}

void contactEnded(FContact contact) {
  if(contact.contains(tire1,floor))jmp1--;
  if(contact.contains(tire2,floor))jmp1--;
  if(contact.contains(tire3,floor))jmp2--;
  if(contact.contains(tire4,floor))jmp2--;
  if(contact.contains(tire1,ball))jmp1--;
  if(contact.contains(tire2,ball))jmp1--;
  if(contact.contains(tire3,ball))jmp2--;
  if(contact.contains(tire4,ball))jmp2--;
  if(contact.contains(frame,floor))Keys[14]=false;
  if(contact.contains(fram2,floor))Keys[15]=false;
}
