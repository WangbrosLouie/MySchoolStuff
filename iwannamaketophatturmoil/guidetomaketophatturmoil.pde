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

P.S. This is probably the only types of texts that I will make in formal
language.

    /-contents-/
-Level Data Format
-Character File Format
-Reference
-Workarounds
-Changelog

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
--Type 3 (READ THIS ONE!!!)
  This file type is the extended file type. It will support all of the
features of the engine. However, all of the features are specified in the
same file segment so it will be harder to edit, until I make a level editor
which probably won't happen. (gotta rewrite this one)
  The segments must be specified with a header, followed by data. White
space between segments will be ignored. Possible segments are:
Level Layout ("Map Layout") - the chunks and their features
Chunk Textures ("Textures") - the paths to the chunk textures
Enemies ("Enemies") - Enemies
Music ("Music") - bgms for level and winning and maybe more.

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

  The textures segment contains all of the texture paths. Every texture
starts with 2 bytes, one for the speed in frames per redraw cycle
multiplied by 32, and one for the amount of frames in the animation. For
static textures the amount of frames is one. Then the full path of the
file(s) are specified. The path is null terminated. If the texture has more
than one frame, rename the frames so that the textures have the same
prefix, have a number corresponding to what frame it is (indexed at 1), and
the same extension, and in the file the number is omitted. For example, to
load in a texture with 2 frames named "a1.png" and "a2.png" at a speed of 1
frame per redraw, you put in the file (in hex):
  10 02 61 2E 70 6E 67 00
I will not be converting that to ASCII because some of the characters are
undrawable.

  The sounds segment contains all of the sounds for the level to play when
things happen. To specify a sound, you need to have the sound ID as the
first byte(more on that below)and the path to the sound followed by a null
byte(0x00). The sound ID is what that sound is played for. You can find all
of the triggers in the reference section. The whole segment is terminated
with a null byte. If you don't want any sounds just put a null byte.

  The script segment is split into two subsegments. The first segment is
made of the animations that are displayed when text is displayed. This
segment is required if you want a picture displayed on the side of the text
but if you only want text it is fine to omit this section. There are a max
of 254 animations that you can specify. An animation is made of its speed
in frames per redraw cycle*32 specified in one byte, then for each picture
the number of gif frames that the picture displays for -1 followed by the
path to the frame and a CR(0x0D) byte. The whole animation is terminated
with a null(0x00) byte. The subsegment is terminated with a null byte.
If you dont want any pictures then just use a null byte. The second sub
section is where the actual text is. Every script is made of one or more
script parts. Every script part starts with the animation ID to play +2
followed by the text to display. The text has to be newlined by CRLFs until
I figure out how to newline them automatically. The text is terminated with
a null byte. The script is terminated with a null as well. The whole
segment is terminated with a null as well. The animation IDs are indexed at
2 because 00 is for terminating the segment and 01 is for no animation,
just text.

    /-character file format-/
To make custom characters, one can either replace the sprites and sounds of
an existing character in the files, but the best way to make a custom
character is to make your own character file. You can customise the
graphics and sounds in a character. If I make attacks, you can also
customise what attacks are bound to what keys and such.
  The file is split into three for graphics, sounds and triggers.
For the graphics, you need to header the data with "Textures". To make an
animation, you need to specify which animation ID to load into with hex,
specify the speed in frames per redraw cycle divided by 32 (except for ID 1
which speed varies with player speed, used for walking), then list every
frame's path (use repeats for repeat frames) delimited with a CR(0x0D), and
terminated with a LF(0x0A). The whole part is terminated with null(0x00).
The sounds follow a similar format but don't have frames (obviously) and
the part is headered with "Sounds" instead.
The triggers are what cause the animations or sounds to play. There are 2
trigger types, one for graphics and one for audio. Triggers include moving,
jumping and getting hurt. The audio triggers are headered with "ATriggers"
and graphics triggers are headered with "GTriggers". Every event has one
byte in each trigger part, and the event number determines which byte is
used. (better explanation: Event 1 will use the animation and sound IDs
specified in the second byte in each part [as Events are indexed at 0])
Note that you need to fill every trigger slot since it is generally not
considered good to be intentionally leaving a used animation or sound
blank, and also it will massively complicate the file if every trigger was
declared explicitly. However, 0x00 can be used to make an audio trigger
silent or to make a graphics trigger play Kitta's idle animation.
If any animation or sound ID is used by a trigger but is not specified in
the file, Kitta's equivalent will be used as a placeholder instead.
If you simply want to mod a part of Kitta, only include the parts you want
to mod (i.e. if you just want to change an animation make a file with only
the graphics part and list only the animation you want to change in it)
The current trigger part length is: 5

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
11 = jumpable damage
12 = water
13 = lava
14 = ladder

Chunk Flag Bits (from right to left)
0 = replenishes jump
1 = hurts nyowch
2 = go to next level
3 = unstatic when touched
4 = is decoration
5 = is liquid
6 = special chunk
7 = is entity (0)

Entity Flag Bits (from right to left)
0-6 = entity type
7 = is entity (1)

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
3 = BGM
4 = Background
5 = Script (story)

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

Sound IDs
01 = Level BGM
02 = Level Finished
03 = Death
04 = Checkpoint

Events (for animations and sound)
00 = Idle
01 = Walking
02 = Jumping
03 = Idle-Moving
04 = Hurt

    /-workarounds-/
Here are the various tricks that I found that are useful.
Byte[](file) to String: Make a new String with the array as the parameter.

    /-changelog-/
Wowza, I'm finally tracking my progress after months of abusing Git's
commit messages. I'm not gonna stop though. I never will.

--Pre Alpha--
|-Made the whole shebang. The shebang includes, but is not limited to:
||-3 different file types
||-The camera system
||-The chunk system
||-The loading system
||-Textures
||-Minimal sound effects
||-(internal) Level names
||-Health system framework
||-Kitta
''-evyles trusty testbot pre-prototype

--Alpha 0.0
|-Title Card (placeholder[?])
|-Level loading overhaul
|-Temporary Level Select
|-The mode framework shoehorned in
'-Level music

--Alpha 0.0a
'-Level loading fix

--Alpha 0.1
|-Lava
|-Entity Rework
|-Particles
|-Dialogs (in progress)
'-Toggleable Level Music (in progress)

--Future Versions
|-Character files
|-More Characters?
|-Kitta's EMP Scratch Attack
|-Menus with buttons
|-Cutscenes
'-Checkpoints

*/
