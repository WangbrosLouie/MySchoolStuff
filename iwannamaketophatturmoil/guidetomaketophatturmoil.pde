                  /*----------------------------------*/
                  /*%- Guide to make Tophat Turmoil -%*/
                  /*----------------------------------*/
/*  /-foreword-/
  Heh heh. My game has already become so complicated that I need to write a
reference manual for it. So be it. I will need this later, after all, if I
am to write a very good game engine deserving of my game.

  Forgive my formal language, it is only because of what this document is
supposed to hold that I am making an effort to write neatly and with proper
English conventions.

    /-contents-/
-Level Data Format
-Engine Features

    /-level data format-/
  The engine expects a header with the string "Tophat Turmoil 1" to start
each file. This is to ensure that a valid file is being loaded in. The byte
immediately proceeding it is the length of the level name minus one, since
it is expected that every level has a name of at least one character. The
name of the level follows, with the length specified. If a level name is
not desired, simply specify a name length of 0 and name it with a space.
After the name comes the level parameters. The length of the parameters
will change as the engine develops, but currently it is only 2 bytes, with
one for level width and one for level height. The rest of the file must be
exactly as long as the width multiplied as the height, as an extra file
corruption guard. The level chunks must be specified in hexidecimal, so a
hex editor is strongly recommended.

    /-engine features-/
The engine is a platformer engine. It is physics based, using the Fisica
library. Level chunk loading from files may be implemented in the future
for level making purposes. The engine pregenerates every chunk in each
level.

chunk reference
0 = air
1 = flat ground
2 = slope up
3 = slope down
4 = half block
*/