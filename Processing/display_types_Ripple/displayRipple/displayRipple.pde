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
import controlP5.*;



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
void setup() {
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
    .setText(Float.toString(0.25))
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
void draw() {
  background(255);

  image( ripple.getTexture(), 0, 80 );
  update();

}


//
// Update
//
void update() {
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
void mouseDragged() {
  ripple.displace(mouseX, mouseY, 512);
}

// -----------------------------------------------------------------------------
void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("zone")) {
    zone[0] = int(theControlEvent.getController().getArrayValue(0));
    zone[1] = int(theControlEvent.getController().getArrayValue(1));
  }
  
}

