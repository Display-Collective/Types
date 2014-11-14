public class Ripple {
  // -----------------------------------------------------------------------------
  //
  // Properties
  //
  // -----------------------------------------------------------------------------
  PImage image;
  PImage texture;

  int i, a, b;
  int prevIndex, newIndex, mapIndex;
  int col[]; 

  int rippleRadius;
  short rippleHeightMap[]; 
  int rippleWidth, rippleHeight;


  // -----------------------------------------------------------------------------
  //
  // Constructor
  //
  // -----------------------------------------------------------------------------
  public Ripple(PImage image, int rippleRadius) {
    this.image = image;
    this.rippleRadius = rippleRadius;

    col = new int[image.width * image.height];
    texture = new PImage(image.width, image.height);

    rippleWidth = image.width >> 1;
    rippleHeight = image.height >> 1;
    rippleHeightMap = new short[(image.width * (image.height + 2) * 2)];

    prevIndex = image.width;
    newIndex = image.width * (image.height + 3);
  }
  
  public Ripple(PImage image) {
    this(image, 3);
  }

  public Ripple() {
    this(new PImage(width, height), 3);
  }
  


  // -----------------------------------------------------------------------------
  //
  // Methods
  //
  // -----------------------------------------------------------------------------
  public void update() {
    texture.loadPixels();
//    image.loadPixels();
    for (int loc=0; loc <(image.width*image.height); loc++) {
      texture.pixels[loc] = col[loc];
    }
  //  image.updatePixels();
    texture.updatePixels();

    // update the height map and the image
    i = prevIndex;
    prevIndex = newIndex;
    newIndex = i;

    i = 0;
    mapIndex = prevIndex;
    for (int y=0; y<image.height; y++) {
      for (int x=0; x<image.width; x++) {
        short data = (short)(
          (rippleHeightMap[mapIndex - image.width] + rippleHeightMap[mapIndex + image.width] +
           rippleHeightMap[mapIndex - 1] + rippleHeightMap[mapIndex + 1]) >> 1
        );
        data -= rippleHeightMap[newIndex + i];
        data -= data >> 4;

        // avoid the wraparound effect
        if (x == 0 || y == 0) {
          rippleHeightMap[newIndex + i] = 0;
        }
        else {
          rippleHeightMap[newIndex + i] = data;
        }

        // where data = 0 then still, where data > 0 then wave
        data = (short)(1024 - data);

        // offsets
        a = ((x - rippleWidth) * data / 1024) + rippleWidth;
        b = ((y - rippleHeight) * data / 1024) + rippleHeight;

        //bounds check
        if (a >= image.width) {
          a = image.width - 1;
        }
        if (a < 0) { 
          a = 0;
        }
        if (b >= image.height) { 
          b = image.height-1;
        }
        if (b < 0) { 
          b = 0;
        }

        col[i] = image.pixels[a + (b * image.width)];
        mapIndex++;
        i++;
      }
    }

  }

  // -----------------------------------------------------------------------------
  public void displace(int x, int y, int w, int h, float amt) {
    for (int j=(y - h); j<(y + h); j++) {
      for (int k=(x - w); k<(x + w); k++) {
  
        if (j >= 0 && j < image.height &&
            k >= 0 && k < image.width) {
          rippleHeightMap[prevIndex + (j * image.width) + k] += amt;
        }
  
      }
    }

  }

  public void displace(int x, int y, float amt) {
    displace(x, y, rippleRadius, rippleRadius, amt);
  }
  

  // -----------------------------------------------------------------------------
  //
  // Gets
  //
  public PImage getTexture() {
    return texture;  
  }




}
