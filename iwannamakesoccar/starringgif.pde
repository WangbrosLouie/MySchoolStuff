   /*   Library   */
  /* Gif class   */
 /* version 1   */
/* goofy giffy */

/*class Gif extends PImage {
  int frames = 0;
  float interval = 0;
  PImage[] images;
  Gif(int FRAMES, float INTERVAL, String filename) {
    super(1,1,ARGB);
    frames = FRAMES;
    interval = INTERVAL;
    images = new PImage[frames];
    for(int i=0;i<frames;i++) {
      images[i] = loadImage(filename+i);
    }
    super.init(images[0].width,images[0].height,ARGB);
    images[0].loadPixels();
    int[] temp = new int[0];
    arrayCopy(images[0].pixels,temp);
    images[0].updatePixels();
    super.loadPixels();
    arrayCopy(temp,super.pixels);
    super.updatePixels();
  }
}*/
