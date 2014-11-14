/*
 * Display Lake
 *
 * Ken Frederick
 * ken.frederick@gmx.de
 *
 * http://kennethfrederick.de/
 * http://blog.kennethfrederick.de/
 *
 * Lake effect, modified from:
 * http://www.openprocessing.org/sketch/7715
 * http://www.neilwallis.com/java/water.html
 *
 */


// -----------------------------------------------------------------------------
// Libraries
// -----------------------------------------------------------------------------
import java.awt.image.BufferedImage;
//import com.jhlabs.image.RippleFilter;
import controlP5.*;



// -----------------------------------------------------------------------------
// Properties
// -----------------------------------------------------------------------------
//Lake ripple;
RippleFilter ripple;

PImage src;
PImage dest;
float scalar = 0.33f;

ControlP5 cp5;
Range rippleZone;
int zone[];

// temp
BufferedImage bsrc;
BufferedImage bdest;

int mod = 0;

// -----------------------------------------------------------------------------
// Methods
// -----------------------------------------------------------------------------

//
// Setup
//
void setup() {
  src = loadImage("data/image.png");

  size(
    (int)(src.width*scalar),
    (int)(src.height*scalar)+80,
    OPENGL
  );
  frameRate(60);


  // setup ripple
  src.resize(width, height);
//  ripple = new Lake(src);//, 1);

  bsrc = (BufferedImage) src.getImage();

  ripple = new RippleFilter();
  ripple.setEdgeAction(1);
  ripple.setWaveType(3);
  bdest = ripple.filter(bsrc, null);

  

  // setup GUI
  int gwidth = (width-(20*6))/7;
  println(gwidth);
  
  cp5 = new ControlP5(this);
  PFont typeface = createFont("arial", 15);

  zone = new int[2];
  zone[0] = src.height/2;
  zone[1] = src.height;

  rippleZone = cp5.addRange("zone")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
    .setPosition(20, 20)
    .setSize((gwidth*2)-40, 30)
    .setHandleSize(20)
    .setRange(0, src.height-1)
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

  image( new PImage(bdest), 0, 0);
//  image( ripple.getTexture(), 0, 80, width, height );
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
  
  
  ripple.setXWavelength(detail);
  ripple.setXAmplitude( (sin(radians(frameCount))*mul)*w );
  ripple.setYAmplitude( (cos(radians(frameCount))*mul)*h );


  bdest = ripple.filter(bsrc, null);

  
//  for (int y=zone[0]; y<zone[1]; y+=detail) {
//    ripple.displace(
//      (int) random(src.width), y,
//      w, h,
//      (y+inc)*mul
//    );
//  }

//  ripple.update();
}


// -----------------------------------------------------------------------------
// Events
// -----------------------------------------------------------------------------
void mouseDragged() {
//  ripple.displace(mouseX, mouseY, 512);
}

// -----------------------------------------------------------------------------
void keyPressed() {
  if (key == 's' || key == 'S') {
    int serial = (int) random(100,999);
//    println( savePath() );
//    ripple.output("display_a_" + serial + ".png");
  }
}

// -----------------------------------------------------------------------------
void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("zone")) {
    zone[0] = int(theControlEvent.getController().getArrayValue(0));
    zone[1] = int(theControlEvent.getController().getArrayValue(1));
  }
  
}
