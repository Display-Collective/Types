/**
 *  http://processing.org/discourse/yabb2/YaBB.pl?board=OpenGL;action=display;num=1231010113
 */


//-----------------------------------------------------------------------------
//
// Libraries
//
//-----------------------------------------------------------------------------
import java.awt.*;
import javax.swing.*;



public class UIWindow extends PApplet {
  //-----------------------------------------------------------------------------
  //
  // Properties
  //
  //-----------------------------------------------------------------------------
  private PApplet p5;

  private Frame frame;
  private int width;
  private int height;

  // image
  PImage img;

  // preferences
  FPreferences prefs;

  // gui
  ControlP5 cp5;
  Range rippleZone;
  Textfield rippleWidth;
  Textfield rippleHeight;
  Textfield detail;

  int zone[];
  int offsetX, offsetY;
  float scale;
  float multiplier;
  int incrementer;



  //-----------------------------------------------------------------------------
  //
  // Constructor
  //
  //-----------------------------------------------------------------------------
  public UIWindow(PApplet papplet, int w, int h, PImage img) {
    this.p5 = papplet;
    width = w;
    height = h;
    this.img = img;

    frame = new Frame();
    frame.setBounds(0,0, width,height);
    frame.setLocation(0,0);
    frame.add( this );
    this.init();
    frame.show();
    
    prefs = new FPreferences(this.p5, "http://kennethfrederick.de/sandbox/display/mangata/preferences.json");
//    prefs = new FPreferences("preferences.json");
    prefs.setPath("data/");
    
//    prefs.getInt("offsetX") );
//    println( prefs.getInt("offsetY") );
//    println( prefs.getFloat("scale") );
//    println( prefs.getIntArray("zone") );
//    println( prefs.getFloat("multiplier") );
//    println( prefs.getFloat("incrementer") );
//    println( prefs.getString("width") );
//    println( prefs.getString("height") );
//    println( prefs.getString("detail") );

  }



  //-----------------------------------------------------------------------------
  //
  // Methods
  //
  //-----------------------------------------------------------------------------
  public void setup() {
    size(width, height);
    background(0);
    
    setupUI();
  }

  //-----------------------------------------------------------------------------
  public void draw() {
    background(0);
  }

  //-----------------------------------------------------------------------------
  private void setupUI() {
    // setup GUI
    cp5 = new ControlP5(this);
    PFont typeface = createFont("arial", 15);

    zone = new int[2];
    zone[0] = img.height/2;
    zone[1] = img.height;


    // origin of ui elements    
    int x = 20;
    int y = 40;
    int padding = 30;


    // size of ui elements
    int gwidth = width-40;
    int gheight = 20;


    // offset sliders  
    cp5.addSlider("offsetX")
      .setPosition(x, y)
      .setSize(gwidth, gheight)
      .setRange(-p5.width, p5.width)
      .setValue(prefs.getInt("offsetX"));
    setCaptionPosition("offsetX");

    y += gheight+padding;
    cp5.addSlider("offsetY")
     .setPosition(x, y)
     .setSize(gwidth, gheight)
     .setRange(-displayHeight, displayHeight)
     .setValue(prefs.getInt("offsetY"));
    setCaptionPosition("offsetY");
    
    
    // scale slider
    y += gheight+padding;
    cp5.addSlider("scale")
      .setPosition(x, y)
      .setSize(gwidth, gheight)
      .setRange(0.0, 2.0)
      .setValue(prefs.getFloat("scale"))
      .setNumberOfTickMarks(21);
    setCaptionPosition("scale");
  

    // the ripple zone
//    zone = prefs.getIntArray("zone");
    y += gheight+padding;
    rippleZone = cp5.addRange("zone")
      .setBroadcast(false) 
      .setPosition(x, y)
      .setSize(gwidth, gheight)
      .setHandleSize(20)
      .setRange(0, img.height-1)
      .setRangeValues(zone[0], zone[1])
      .setBroadcast(true);
    setCaptionPosition("zone");
  
  
    // multiplier
    y += gheight+padding;
    cp5.addSlider("multiplier")
      .setPosition(x, y)
      .setSize(gwidth, gheight)
      .setRange(0.0, 2.0)
      .setValue(prefs.getFloat("multiplier"))
      .setNumberOfTickMarks(17);
    setCaptionPosition("multiplier");
  
  
    // increment
    y += gheight+padding;
    cp5.addSlider("incrementer")
      .setPosition(x, y)
      .setSize(gwidth, gheight)
      .setRange(0, 1024*2)
      .setValue(prefs.getFloat("incrementer"))
      .setNumberOfTickMarks(17);
    setCaptionPosition("incrementer");


    // ripple width and height
    y += gheight+padding;
    rippleWidth = cp5.addTextfield("width")
      .setPosition(x, y)
      .setSize(gwidth, gheight)
      .setText(prefs.getString("width"));
    setCaptionPosition("width");
  
    y += gheight+padding;
    rippleHeight = cp5.addTextfield("height")
      .setPosition(x, y)
      .setSize(gwidth, gheight)
      .setText(prefs.getString("height"));
    setCaptionPosition("height");


    // ripple detail
    y += gheight+padding;
    detail = cp5.addTextfield("detail")
      .setPosition(x, y)
      .setSize(gwidth, gheight)
      .setText(prefs.getString("detail"));
    setCaptionPosition("detail");
    
    
    // button
    y += gheight+padding;
    cp5.addButton("Save")
      .setPosition(x, y)
      .setSize(gwidth, gheight);

  }

  //-----------------------------------------------------------------------------
  public void load() {
    try {
      prefs.reload();

      cp5.getController("offsetX").setValue( prefs.getInt("offsetX") );
      cp5.getController("offsetY").setValue( prefs.getInt("offsetY") );
      cp5.getController("scale").setValue( prefs.getFloat("scale") );
      cp5.getController("multiplier").setValue( prefs.getFloat("multiplier") );
      cp5.getController("incrementer").setValue( prefs.getFloat("incrementer") );
      rippleZone.setRangeValues( prefs.getIntArray("zone")[0], prefs.getIntArray("zone")[1] );
      rippleWidth.setValue( prefs.getString("width") );
      rippleHeight.setValue( prefs.getString("height") );
      detail.setText( prefs.getString("detail") );
    }
    catch (Exception e) {
    }
  }

  private void save() {
    try {
      prefs.setInt("offsetX",       getOffsetX());
      prefs.setInt("offsetY",       getOffsetY());
      prefs.setFloat("scale",       getScale());
      prefs.setIntArray("zone",     getZone());
      prefs.setFloat("multiplier",  getMultiplier());
      prefs.setFloat("incrementer", getIncrement());
      prefs.setString("width",      Integer.toString(getRippleWidth()));
      prefs.setString("height",     Integer.toString(getRippleHeight()));
      prefs.setString("detail",     Integer.toString(getDetail()));
  
      prefs.save();
    }
    catch (Exception e) {
    }
  }


  //-----------------------------------------------------------------------------

  //
  // Sets
  //
  public void setBounds(int x, int y) {
    frame.setBounds(x,y, width,height);
  }

  private void setCaptionPosition(String element) {
    cp5.getController(element)
     .getCaptionLabel()
     .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(4);
  }


  //-----------------------------------------------------------------------------

  //
  // Gets
  //
  public int getOffsetX() {
    return offsetX;
  }   
  public int getOffsetY() {
    return offsetY;
  }   

  public float getScale() {
    return scale;
  }

  //-----------------------------------------------------------------------------
  public int[] getZone() {
    return zone;
  }

  //-----------------------------------------------------------------------------
  public int getIncrement() {
    return incrementer;
  }

  //-----------------------------------------------------------------------------
  public float getMultiplier() {
    return multiplier;
  }

  //-----------------------------------------------------------------------------
  public int getDetail() {
    String val = cp5.get(Textfield.class, "detail").getText();
    return (val.equals(""))
      ? 1
      : int(val);
  }

  //-----------------------------------------------------------------------------
  public int getRippleWidth() {
    String val = cp5.get(Textfield.class, "width").getText();
    return (val.equals(""))
      ? 1
      : int(val);
  }
  public int getRippleHeight() {
    String val = cp5.get(Textfield.class, "height").getText();
    return (val.equals(""))
      ? 1
      : int(val);
  }

  


  //-----------------------------------------------------------------------------
  //
  // Events
  //
  // -----------------------------------------------------------------------------
  public void controlEvent(ControlEvent event) {
    if (event.isFrom("zone")) {
      zone[0] = int(event.getController().getArrayValue(0));
      zone[1] = int(event.getController().getArrayValue(1));
    }

    // on change save values
    if (event.isFrom("Save")) {
      save();
    }
  }


}

