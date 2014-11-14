import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class displayRipple extends PApplet {

/*
 * Display Ripple
 *
 * Ken Frederick
 * ken.frederick@gmx.de
 *
 * http://kennethfrederick.de/
 * http://blog.kennethfrederick.de/
 *
 * Ripple effect, modified from:
 * radio79
 * http://www.openprocessing.org/sketch/7715
 * http://www.neilwallis.com/java/water.html
 *
 */


// -----------------------------------------------------------------------------
// Libraries
// -----------------------------------------------------------------------------




// -----------------------------------------------------------------------------
// Properties
// -----------------------------------------------------------------------------
Ripple ripple;

PImage img;
float scalar = 0.33f;

ControlP5 cp5;
Range rippleZone;
int zone[];



// -----------------------------------------------------------------------------
// Methods
// -----------------------------------------------------------------------------

//
// Setup
//
public void setup() {
  img = loadImage("data/image.png");

  size(
    (int)(img.width*scalar),
    (int)(img.height*scalar)+80
  );
  frameRate(60);


  // setup ripple
  img.resize(width, height);
  ripple = new Ripple(img, 1);


  // setup GUI
  int gwidth = (width-(20*6))/7;
  println(gwidth);
  
  cp5 = new ControlP5(this);
  PFont typeface = createFont("arial", 15);

  zone = new int[2];
  zone[0] = img.height/2;
  zone[1] = img.height;

  rippleZone = cp5.addRange("zone")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
    .setPosition(20, 20)
    .setSize((gwidth*2)-40, 30)
    .setHandleSize(20)
    .setRange(0, img.height-1)
    .setRangeValues(zone[0], zone[1])
    // after the initialization we turn broadcast back on again
    .setBroadcast(true)
    .setColorForeground( color(0, 40) )
    .setColorBackground( color(0, 40) )
    .setColorActive( color(0, 0, 255) )
    .setColorCaptionLabel( color(0, 0, 255) )
    .setColorValueLabel( color(0, 0, 255) );

  cp5.addTextfield("multiplier")
    .setPosition((gwidth*2)+20, 20)
    .setSize(gwidth, 30)
    .setFont(typeface)
    .setText(Float.toString(0.25f))
    .setColorForeground( color(0, 40) )
    .setColorBackground( color(0, 40) )
    .setColorActive( color(0, 0, 255) )
    .setColorCaptionLabel( color(0, 0, 255) )
    .setColorValueLabel( color(0, 0, 255) );

  cp5.addTextfield("incrementer")
    .setPosition((gwidth*3)+40, 20)
    .setSize(gwidth, 30)
    .setFont(typeface)
    .setText(Integer.toString(512))
    .setColorForeground( color(0, 40) )
    .setColorBackground( color(0, 40) )
    .setColorActive( color(0, 0, 255) )
    .setColorCaptionLabel( color(0, 0, 255) )
    .setColorValueLabel( color(0, 0, 255) );

  cp5.addTextfield("width")
    .setPosition((gwidth*4)+60, 20)
    .setSize(gwidth, 30)
    .setFont(typeface)
    .setText(Integer.toString(10))
    .setColorForeground( color(0, 40) )
    .setColorBackground( color(0, 40) )
    .setColorActive( color(0, 0, 255) )
    .setColorCaptionLabel( color(0, 0, 255) )
    .setColorValueLabel( color(0, 0, 255) );

  cp5.addTextfield("height")
    .setPosition((gwidth*5)+80, 20)
    .setSize(gwidth, 30)
    .setFont(typeface)
    .setText(Integer.toString(1))
    .setColorForeground( color(0, 40) )
    .setColorBackground( color(0, 40) )
    .setColorActive( color(0, 0, 255) )
    .setColorCaptionLabel( color(0, 0, 255) )
    .setColorValueLabel( color(0, 0, 255) );

  cp5.addTextfield("detail")
    .setPosition((gwidth*6)+100, 20)
    .setSize(gwidth, 30)
    .setFont(typeface)
    .setText(Integer.toString(3))
    .setColorForeground( color(0, 40) )
    .setColorBackground( color(0, 40) )
    .setColorActive( color(0, 0, 255) )
    .setColorCaptionLabel( color(0, 0, 255) )
    .setColorValueLabel( color(0, 0, 255) );

}

//
// Draw
//
public void draw() {
  background(255);

  image( ripple.getTexture(), 0, 80 );
  update();

}


//
// Update
//
public void update() {
  int inc = (cp5.get(Textfield.class, "incrementer").getText().equals(""))
    ? 0
    : Integer.parseInt(cp5.get(Textfield.class, "incrementer").getText());

  float mul = (cp5.get(Textfield.class, "multiplier").getText().equals(""))
    ? 0.0f
    : Float.parseFloat(cp5.get(Textfield.class, "multiplier").getText());
  
  int w = (cp5.get(Textfield.class, "width").getText().equals(""))
    ? 1
    : Integer.parseInt(cp5.get(Textfield.class, "width").getText());

  int h = (cp5.get(Textfield.class, "height").getText().equals(""))
    ? 1
    : Integer.parseInt(cp5.get(Textfield.class, "height").getText());
  
  int detail = (cp5.get(Textfield.class, "detail").getText().equals(""))
    ? 1
    : Integer.parseInt(cp5.get(Textfield.class, "detail").getText());
  
  for (int y=zone[0]; y<zone[1]; y+=detail) {
    ripple.displace(
      (int) random(width), y,
      w, h,
      (y+inc)*mul
    );
  }

  ripple.update();
}


// -----------------------------------------------------------------------------
// Events
// -----------------------------------------------------------------------------
public void mouseDragged() {
  ripple.displace(mouseX, mouseY, 512);
}

// -----------------------------------------------------------------------------
public void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("zone")) {
    zone[0] = PApplet.parseInt(theControlEvent.getController().getArrayValue(0));
    zone[1] = PApplet.parseInt(theControlEvent.getController().getArrayValue(1));
  }
  
}

public class Ripple {
  // -----------------------------------------------------------------------------
  // Properties
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
  // Constructor
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
  // Methods
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "displayRipple" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
