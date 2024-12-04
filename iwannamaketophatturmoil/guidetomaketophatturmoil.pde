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

NOTE: Document is subject to change, and may not reflect the current state
of the engine. This document may be behind or ahead of the engine.

    /-contents-/
-Level Data Format
-Character File Format
-Reference

    /-level data format-/
--Types 1 and 2(OUTDATED USE TYPE 3 INSTEAD)
  A valid level file is made of 5 parts:
The layout data - the chunk layout of the level
The enemy data - locations, types, to be implemented later
The plaintext portion - file names for textures and the level name
The parameter bytes - level settings (listed in reference)
The footer - the string "Tophat Turmoil " and the file type
  The file type determines the features of the level. For now, there are
only types 1 and 2. Type 1 is smaller, but it does not support textures.
Type 2 is roughly double the size of Type 1, but supports up to 255 unique
animated(or static)textures for the chunks.
(in hindsight since all of the levels are currently <1kb use Type 2)
  The plaintext portion is where all of the names go. For Type 1, only the
name is stored here. For Type 2, the textures precede the level name.
The textures are formatted as: 00 FC SP PP..PP
where 00 is a null byte, FC is number of animated frames(1 for static),
SP is speed in a special format, and PP..PP is the path in text. The speed
is calculated with SP*0.03125, and the result is the animation frames per
program frame (draw cycle). None of the bytes other than the null byte
should be null.
  The level data uses 1 byte per chunk, or 2 bytes for chunk and texture if
using Type 2. The chunk codes can be found in reference, and the texture
number is indexed at 1, as 00 is used for no texture.
--Type 3
Layout: Variable
  This file type is the extended file type. It will support all of the
features of the engine. However, all of the features are specified in the
same file segment so it will be harder to edit, until I make a level editor
which probably won't happen.
  The segments must be specified with a header, followed by data. White
space between segments will be ignored. Possible segments are:
Level Layout ("Map Layout") - the chunks and their features
Chunk Textures ("Textures") - the paths to the chunk textures
Enemies ("Enemies") - Enemies
  The segments in the file can come in any order. However, for chunk
textures to work, you must specify the level chunks after the texture paths
because the chunks will be loaded and textured before the textures are
loaded. Also, the objects will be graphically layered in the order that
they are specified in the file, as every object that gets added to the
physics world will be on the topmost layer. There will be a foreground
graphics segment to take advantage of this.
  The chunks segment contains the layout of the chunks, as well as any
chunk extensions, like textures, triggers, teleports, damage and more.
For a single chunk, you need to specify the chunk type, and the texture.
After that comes the extensions. They will be specified by a byte, shown in
reference. You must terminate every chunk with 0xFF, or else the parser
will interpret the next chunk as an extension.

    /-character file format-/
To make custom characters, one can either replace the sprites and sounds of
an existing character in the files, but the best way to make a custom
character is to make your own character file. You can customise the
graphics and sounds in a character. If I make attacks, you can also
customise what attacks are bound to what keys and such.
  The file is split into three for graphics, sounds and triggers.
For the graphics, you need to header the data with "Textures". To make an
animation, you need to specify which animation ID (minus 1) to load into
with hex, then list every frame's path (repeats allowed because no custom
frame durations) delimited with a CR(0x0D), and terminated with a LF(0x0A).
The whole section is terminated with a null (0x00).
The sounds follow the same format but is headered with "Sounds" instead.
(well not exactly but i dont care enough to write more right now)
The triggers are what cause the animations or sounds to play. There are 2
trigger types, one for graphics and one for audio. Triggers include moving,
jumping and getting hurt.

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
10 = damage block
11 = water
12 = lava

Chunk Flag Bits (from right to left)
0 = replenishes jump
1 = hurts nyowch
2 = go to next level
3 = unstatic when touched
4 = is decoration
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
7 = Number of Custom Textures (Type 2 & 3)
8 = Gravity X * 2 (signed)
9 = Gravity Y * 2 (signed)
A = Background Colour Red
B = Background Colour Green
C = Background Colour Blue
F = Data Segments (Type 3)

Data Segment Bits (from right to left)
0 = Texture Paths (required for textures)
1 = Layout Data (required)
2 = Enemies

Chunk Extensions
00 = End of Chunk
01 = Chunk Flag Byte +1 byte chunkflags
02 = Speech Trigger +1 byte speechpart
03 = Teleport Location +4 bytes X&Y Position --oh wait how do i make this even
04 = Fill Colour (in ARGB) +4 byte hex colour
05 = Fill Colour (in HSB?) +4 byte hex colour
06 = Stroke Colour (in ARGB) +4 byte hex colour
07 = Stroke Colour (in HSB?) +4 byte hex colour
08 = Chunk Friction +1 byte integer
09 = Chunk Restitution +1 byte integer
*/
