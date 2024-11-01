/* Title: Iwannamaketophatturmoil *\
|* Author: Louie Wang             *|
|* Description: woo my unreleased *|
|* game that i havent started     *|
|* working on yet has moved from  *|
|* the sega genesis to processing *|
\*_Date:_Nov.1,_2024______________*/

import fisica.*;

void settings() {
  size(640,480);
}

boolean loading = true;
String[] maps = new String[]{"map01.lvl"};
File map;

void setup() {
  
}

void draw() {
  if(loading){
    loading = false;
  }
  map = new File(maps[0]);
  //read map info from header and create level
}

//make level chunk generation here

//input events and controller support here

/*colours reference
#440000 floor tile 1 (flat)
#880000 slope top to left
#BB0000 slope top to right
#FF0000 undecided
*/
