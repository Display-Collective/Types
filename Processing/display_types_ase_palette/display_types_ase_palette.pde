// ------------------------------------------------------------------------
// Library
// ------------------------------------------------------------------------
import flib.fcolor.*;



// ------------------------------------------------------------------------
// Properties
// ------------------------------------------------------------------------
FASE palette;

int white            = color(255, 255, 255, 255*1.0);
int white_light_gray = color(255, 255, 255, 255*0.45);
int white_dark_gray  = color(255, 255, 255, 255*0.83);

int black            = color( 30,  20,  15, 255*1.0);
int black_light_gray = color( 30,  20,  15, 255*0.10);
int black_dark_gray  = color( 30,  20,  15, 255*0.45);

int light_gray       = color(233, 232, 231, 255*1.0);
int dark_gray        = color(154, 149, 147, 255*1.0);

// primary
int red              = color(255,  68, 100, 255*1.0);
int yellow           = color(242, 204,  68, 255*1.0);
int blue             = color(  0, 204, 255, 255*1.0);

// secondary
int orange           = color(255, 100,  70, 255*1.0);
int green            = color(  0, 238, 153, 255*1.0);
int purple           = color(144,  39, 142, 255*1.0);

int col[] = {
  white,
  light_gray,
  dark_gray,
  black,
  red,
  yellow,
  blue,
  orange,
  green,
  purple
};



// ------------------------------------------------------------------------
// Methods
// ------------------------------------------------------------------------

//
// Setup
//
void setup() {
  size(450, 450);
  noLoop();

  palette = new FASE(this);
  palette.save(col, "/data/display_rgb.ase");

}


//
// Draw
//
void draw() {
  background(255);
  noStroke();

  int w = width/col.length; ///palette.getCount();
  int y = 0;

//  for( int i=0; i<palette.getCount(); i++ ) {
  for( int i=0; i<col.length; i++ ) {
//    int rgb = palette.getColor(i);
    int rgb = col[i];

    int a = (rgb >> 24) & 0xFF;    
    int r = (rgb >> 16) & 0xFF;
    int g = (rgb >> 8) & 0xFF;
    int b = rgb & 0xFF;

    fill(r, g, b, a);
    rect(w*i,y, w,height);
  }

  
}



