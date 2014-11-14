/*
 * Komorebi
 *
 * Ken Frederick
 * ken.frederick@gmx.de
 *
 * http://kennethfrederick.de/
 * http://blog.kennethfrederick.de/
 *
 */

// -----------------------------------------------------------------------------
// Libraries
// -----------------------------------------------------------------------------
import processing.pdf.*;
import flib.ftime.*;
import flib.core.*;



// -----------------------------------------------------------------------------
// Properties
// -----------------------------------------------------------------------------
// margins
//int w = 6912;
//int h = 6912;
int w = 2592;
int h = 3456;

int left = 90;
int top  = 108; 

//String poem = "It is foolish\nto let a young redwood\ngrow next to a house.\nEven in this\none lifetime,\nyou will have to choose.\nThat great calm being,\nthis clutter of soup pots and books—\nAlready the first branch-tips brush at the window.\nSoftly, calmly, immensity taps at your life.";
String poem = "It is foolish to let a young redwood\ngrow next to a house. Even in this\none lifetime, you will have to\nchoose. That great calm being,\nthis clutter of soup pots\nand books— Already the\nfirst branch-tips\nbrush at the\nwindow. Softly,\ncalmly, immensity\ntaps at\nyour\nlife.";

String[] lines;
float scalar = 0.5;

PFont typeface;
int typeSize    = 34;
int typeLeading = 36;

// colors
PImage background;
int blue, green;



// -----------------------------------------------------------------------------
// Methods
// -----------------------------------------------------------------------------

//
// Setup
//  
void setup() {
//  scalar = (float)(displayHeight-100) / (float)(h);
  size(
    (int)(w*scalar),
    (int)(h*scalar)
  );
  left *= scalar;
  top *= scalar;
  
  noLoop();
  smooth();

  // remove spaces
  String newPoem = "";
  for (int i=0; i<poem.length(); i++) {
    if (poem.charAt(i) != ' ') {
      newPoem += " " + poem.charAt(i);
    }
//    println( poem.charAt(i) ); 
  }
  poem = newPoem;

  lines = poem.split("\n");

  // typeface
//  typeface = createFont("Theinhardt-Bold", typeSize*scalar);
  typeface = loadFont("Theinhardt-Bold-51.vlw");
  textFont(typeface);
  textSize(typeSize*scalar);
  textLeading(typeLeading*scalar);
  
  // colors
  background = loadImage("other_side_square.png");
  background.resize(width, height);
  background.loadPixels();

  blue  = color(#74D1EA);
  green = color(#6BA539);
  
}


//
// Setup
//
void draw() {
  beginRecord(PDF, "images/display_komorebi_poster_p5.pdf"); 
  
  background(255);  
//  image(background, 0, 0);
  
//  fill(255);
//  text(poem, 15, 15, width-45, height-45);

  fill(0);
  float prevY = 0.0f;
  for (int i=0; i<lines.length; i++) {
    String line = lines[i].trim();

    float tY = (float) (i)/ (float) (lines.length-1);
    float easeY = (float) Ease.inQuad(tY);
    float y = FCalculate.snap(
      map(easeY, 0.0, 1.0, top, height-top-(typeLeading*scalar)),
      36*scalar
    );

    if (prevY == y) {
      y += (36*scalar);
    } 
    prevY = y;

    String[] words = line.split(" ");
    float prevX = 0.0f;
    for (int j=0; j<words.length; j++) {
      String word = words[j].trim();
      
      float tX = (float) (j)/ (float) (words.length-1);
      float easeX = (float) Ease.inOutQuad(tX);
      float x = FCalculate.snap(
        map(easeX, 0.0, 1.0, left, width-left),
        36*scalar
      );

      float charWidth = textWidth(word);
      if (Math.abs(x-prevX) < charWidth) {
        x = prevX + charWidth;
      } 
      prevX = x;
    
//      fill( background.get((int)x, (int)y) );
      if (j <= 1 ) {
        textAlign(LEFT, TOP);
      }
      else if (j >= words.length-1) {
        textAlign(RIGHT, TOP);
      }
      else {
        textAlign(CENTER, TOP);
      }
      

      if (words.length == 1) {
        textAlign(CENTER, TOP);
        text(words[j], width/2, y);
      }
      else {
        text(word, x, y);
      }

    }
  }
  
  save("images/display_komorebi_poster_p5.tiff");

  endRecord();
}


