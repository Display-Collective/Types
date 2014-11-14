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


// ------------------------------------------------------------------------
// Library
// ------------------------------------------------------------------------
import processing.pdf.*;



// ------------------------------------------------------------------------
// Properties
// ------------------------------------------------------------------------
Halftone halftone;
float scalar = 0.25f;




// ------------------------------------------------------------------------
// Methods
// ------------------------------------------------------------------------

//
// Setup
//
void setup() {
  size((int)(2691*scalar), (int)(3420*scalar), P2D);
  noLoop();

  halftone = new Halftone((int)(72*scalar), 45);
}


//
// Draw
//
void draw() {
  background(255);

//  beginRecord(PDF, "line.pdf");

  fill(0);
  noStroke();

  shape( halftone.draw(), 1000, 100 );

//  endRecord();
//  exit();
}



