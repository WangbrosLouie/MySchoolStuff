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

NOTE: Document is subject to change, and may not be accurate as the engine
is developed. This document may be behind or ahead of the engine.

    /-contents-/
-Level Data Format
-Engine Features

    /-level data format-/
  The engine expects a footer with the string "Tophat Turmoil 1" to end a
valid level file. There will be support for levels with the footer string
"Tophat Turmoil 2" with extra features sometime. The 16 bytes preceeding
the footer are the level parameter bytes. The specifics are in -reference-.
The level name comes before the parameter bytes, and the length is stored
in a level parameter byte. There is no safeguard implemented to prevent
invalid names such as names too long which leak into level data or a non
existant name, so make sure the name is correctly specified. The data from
the start of the file ending at the start of the level name are the chunks.
The width and height of the level are specified in the level parameters,
but there currently is no check to verify if the level is long enough for
the width and height, so if you load your level and get a blue screen for a
non existant array element before you can move then make sure the level is
the correct length and the width and height are correctly specified.

    /-engine features-/
The engine is a platformer engine. It is physics based, using the Fisica
library. Level chunk loading from files may be implemented in the future
for level making purposes. The engine pregenerates every chunk in each
level.

    /-reference-/
Chunk IDs
0 = air
1 = flat ground
2 = floorless ground
3 = slope up
4 = slope down
5 = flat half
6 = floorless half
7 = icy flat ground
8 = icy floorless ground
9 = icy slope up
A = icy slope down
B = icy flat half
C = icy floorless half
D = bouncy floor
E = super bounce
F = win zone

Chunk Flag Bits (from right to left)
0 = replenishes jump
1 = hurts nyowch
2 = go to next level
3 = undecided
4 = undecided
5 = undecided
6 = undecided
7 = undecided

Level Parameter Bytes
0 = Level Width - 1 (Chunks)
1 = Level Height - 1 (Chunks)
2 = Player Spawn X (Upper Byte)
3 = Player Spawn X (Lower Byte)
4 = Player Spawn Y (Upper Byte)
5 = Player Spawn Y (Lower Byte)
6 = Level Name Length - 1
7 = Number of Custom Textures
*/
