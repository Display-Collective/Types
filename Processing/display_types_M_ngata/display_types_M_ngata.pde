/*
 * Display Mångata Ripple
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


//-----------------------------------------------------------------------------
//
// Libraries
//
//-----------------------------------------------------------------------------
import controlP5.*;



//-----------------------------------------------------------------------------
//
// Properties
//
//-----------------------------------------------------------------------------
UIWindow guiwin;

// Ripple
Ripple ripple;

PImage src;
PGraphics img;
int xoff, yoff;

boolean isInvert = false;
int prevTime = 0;



//-----------------------------------------------------------------------------
//
// Methods
//
//-----------------------------------------------------------------------------
void setup() {
  size(displayWidth/2, displayHeight/2);
  frameRate(60);

  createImage(1.0);

  // external window
  guiwin = new UIWindow(this, 250, 550, img);
  guiwin.setBounds(0, 0);

  
}


void draw() {
  frame.setTitle(str(frameRate));  
  background(0);
  
  image( ripple.getTexture(), xoff, yoff );
  if (isInvert) {
    filter(INVERT);
  }

  update();
}


//
// Update
//
void update() {
  try {
    // every INTERVAL seconds check pref file
    int interval = 15;
    if( millis() - prevTime >= interval*1000){
      guiwin.load();
      prevTime = millis();
    }

    xoff = guiwin.getOffsetX();
    yoff = guiwin.getOffsetY();

    for (int y=guiwin.getZone()[0]; y<guiwin.getZone()[1]; y+=guiwin.getDetail()) {
      ripple.displace(
        (int) random(width),
        y,
        guiwin.getRippleWidth(),
        guiwin.getRippleHeight(),
        (y+guiwin.getIncrement())*guiwin.getMultiplier()
      );
    }
    
  }
  catch (Exception e) {
  }

  ripple.update();
}

void createImage(float scale) {
  // load image
  src = loadImage("data/image.png");
  src.resize((int)(height*scale), (int)(height*scale));

  // create buffer object
  img = createGraphics((int)(width*scale), (int)(height*scale));
  img.beginDraw();
  img.background(0);
  img.image(src, (width-src.width)/2, 0);
  img.endDraw();

  // setup ripple
  ripple = new Ripple(img, 1);
}



//-----------------------------------------------------------------------------
//
// Events
//
//-----------------------------------------------------------------------------
void mouseDragged() {
  ripple.displace(mouseX, mouseY, 512);
}

//-----------------------------------------------------------------------------
void keyPressed() {
  if (key == 'i' || key == 'I') {
    isInvert = !isInvert;
  }
  
}

//-----------------------------------------------------------------------------
boolean sketchFullScreen() {
  return true;
}

