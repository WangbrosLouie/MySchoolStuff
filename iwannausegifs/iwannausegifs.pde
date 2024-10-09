/* Title: Iwannausegifs *\
|* Author: Louie Wang   *|
|* Description: i       *|
|* wonder what gifs i   *|
|* will use in this one *|
\*_Date:_Oct.2,_2024____*/

class Button { //code recycling go brrrr
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
  int tSize = 12;
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
  //text with size button constructor
  Button(int tYPE, int DOwHAT, int x, int y, int xsIZE, int ysIZE, color oUT, color iN, color hoUT, color hiN, color poUT, color piN, color toUT, color thOV, color tiN, String TEXT, int TsIZE) {
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

//man i wanna use the gif library
class Gif extends PImage implements Runnable {
  PImage[] frm;
  int frame = 0;
  int numFrames = 0;
  float frameCnt = frameCount;
  float delay = 1; //in frames
  boolean playing = false;
  Gif(String pre, String suf, int frames) {
    super();
    if(frames>0){
      frame = 0;
      frm = new PImage[frames];
      for(int i=0;i<frames;i++) {
        frm[i] = loadImage(pre+i+suf);
      }
      loadPixels();
      frm[frame].loadPixels();
      pixels = frm[frame].pixels;
      frm[frame].updatePixels();
      updatePixels();
    }
  }
  
  Gif() {
    super();
    frm = new PImage[0];
  }
  
  void run() {
    if(playing&&numFrames>0) {
      if(delay>frameCount-frameCnt) {
        int adv = round(delay%(frameCount-frameCnt));
        frameCnt += adv*delay;
        frameCnt %= numFrames;
        frame += adv;
        loadPixels();
        int[] temp = new int[0];
        arrayCopy(pixels,temp);
        updatePixels();
        frm[frame].loadPixels();
        pixels = temp;
        frm[frame].updatePixels();
      }
    }
  }
  
  void play() {
    if(!playing) {
      playing = true;
    }
  }
  
  void play(float DELAY) {
    if(!playing) {
      delay = DELAY;
      playing = true;
    }
  }
  
  void pause() {
    playing = false;
  }
  
  void stop() {
    playing = false;
    frame = 0;
  }
  
  void restart() {
    if(!playing) {
    frame = 0;
      playing = true;
      while(playing) {
        if(delay>frameCount-frameCnt) {
          int adv = round(delay%(frameCount-frameCnt));
          frameCnt += adv*delay;
          frame += adv;
          loadPixels();
          frm[frame].loadPixels();
          pixels = frm[frame].pixels;
          frm[frame].updatePixels();
          updatePixels();
        }
      }
    }
  }
  
  void restart(float DELAY) {
    if(!playing) {
      frame = 0;
      delay = DELAY;
      playing = true;
      while(playing) {
        if(delay>frameCount-frameCnt) {
          int adv = round(delay%(frameCount-frameCnt));
          frameCnt += adv*delay;
          frame += adv;
          loadPixels();
          frm[frame].loadPixels();
          pixels = frm[frame].pixels;
          frm[frame].updatePixels();
          updatePixels();
        }
      }
    }
  }
  
  void addImage(PImage add) {
    frm = (PImage[])append(frm,add);
    numFrames++;
  }
}

Button[] Btns;
PGraphics Hitbox;
int Btn = 0;
Gif Movie = new Gif();
//the song of la palice is quite funny

void setup() {
  Btns = new Button[] {
  new Button(1,1,0,0,70,480,color(0),color(200),color(0),color(150),color(0),color(100),color(0),color(0),color(0),"Load GIF"),
  new Button(1,2,70,430,200,50,color(0),color(200),color(0),color(150),color(0),color(100),color(0),color(0),color(0),"<<",24),
  new Button(1,3,270,430,170,50,color(0),color(200),color(0),color(150),color(0),color(100),color(0),color(0),color(0),">",24),
  new Button(1,4,440,430,200,50,color(0),color(200),color(0),color(150),color(0),color(100),color(0),color(0),color(0),">>",24)};
  size(640,480);
  Hitbox = createGraphics(640,480);
  //Movie.start();
new Thread(Movie).start();
}

void draw() {
  background(0);
  if(Movie!=null)image(Movie,70,0,570,430);
  process(Btns,Hitbox);
}

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
      selectInput("Get your gif nya","gifGet");
      break;
    case 2:
      //slow/rewind mode
      break;
    case 3:
      if(Movie.playing) {
        Movie.pause();
        for(int i=0;i<Btns.length;i++){
          if(Btns[i].doWhat==Action)Btns[i].text=">";
        }
      } else {
        Movie.play();
        for(int i=0;i<Btns.length;i++){
          if(Btns[i].doWhat==Action)Btns[i].text="| |";
        } 
      }
      break;
    case 4:
      //fast forward
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

void gifGet(File giffy) {
  if(giffy!=null){
    Movie.frm = (PImage[])append(Movie.frm, loadImage(giffy.getAbsolutePath()));
  }
}
// Σ:3 this is sigma cat sigma cat is sigma because the ears are made of a sigma character say mraow to sigma cat
