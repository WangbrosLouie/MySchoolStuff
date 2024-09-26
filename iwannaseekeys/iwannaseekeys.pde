/* Title: Iwannaseekeys *\
|* Author: Louie Wang   *|
|* Description: I just  *|
|* wanna see key codes  *|
\*_Date:Sept.18,2024____*/

char Key = '_';
String Ascii = "_";
String KCode = "_";

void setup() {
  size(200,200);
}

void draw() {
  background(255);
  textAlign(CENTER,CENTER);
  fill(#1F000000);
  textSize(30);
  text("key",100,120);
  textSize(25);
  text("ASCII",50,185);
  text("KeyCode",150,185);
  fill(#FF000000);
  textSize(100);
  text(Key,100,50);
  textSize(50);
  text(Ascii,50,150);
  text(KCode,150,150);
}

void keyPressed() {
  Key = key;
  Ascii = str(byte(key));
  KCode = str(keyCode);
}
