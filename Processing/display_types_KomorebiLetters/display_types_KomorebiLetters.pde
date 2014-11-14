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
int w = 6912;
int h = 6912;

int left = 90;
int top  = 108; 

float scalar = 0.0f;

PImage img;
PVector interval;
float[] radiusRange;
float noiseScale = 1.0;//02;



// -----------------------------------------------------------------------------
// Methods
// -----------------------------------------------------------------------------

//
// Setup
//  
void setup() {
  scalar = (float)(displayHeight-100) / (float)(h);
  size(
    (int)(w*scalar),
    (int)(h*scalar),
    P2D
  );
  left *= scalar;
  top *= scalar;
  
  noLoop();
  smooth();

  img = loadImage("display_c1_komorebi_00_kf-01.png");
  img.resize(width, height);
  img.loadPixels();

  interval = new PVector(
    104.161*scalar,
    52.056*scalar
  );
  
  radiusRange = new float[2];
  radiusRange[0] = 30.051*scalar;
  radiusRange[1] = 66.998*scalar;
//}


//
// Draw
//
//void draw() {
  background(255);  

  beginRecord(PDF, "images/display_KomorebiLetters-gotham.pdf");

//  image(img, 0,0);

  fill(0);
  noStroke();
  int dotCount = 0;
  for (int y=0; y<img.height; y+=interval.y) {
    for (int x=0; x<img.width; x+=interval.x) {
      if (y % 2 == 1) {
        x -= interval.x/2;
      }
      
      int argb = img.pixels[y*img.width+x]; 
      float a = brightness(argb);

      // add some noise
      float noise = noise(x*noiseScale, y*noiseScale);
      
      // determine position and snap in place
      float radius = map(a, 255,0, radiusRange[0], radiusRange[1]);
      PVector snap = new PVector(
        FCalculate.snap(x+noise*radius, interval.x),
        FCalculate.snap(y+noise*radius, interval.y)
      );
      
      int rand = (int)(random(0, 6));
      if (rand != 1 && a != 255) {
        float r = constrain(radius*norm(y, img.height, 0), radiusRange[0], radiusRange[1]);
        fill(255,0,0);
        ellipse(snap.x, snap.y, r, r);
        dotCount++;

        float quadScalar = 0.24450340602501;
        r *= quadScalar;
        float offset = radiusRange[1]*0.5;
        
        fill(0);
        // top left
        if ((int)random(0, 4) != 0) {
          ellipse((snap.x-offset)+(r/2), (snap.y-offset)+(r/2), r, r);
          dotCount++;
        }
        // top center
        if ((int)random(0, 4) != 0) {
          ellipse((snap.x)+(r/2), (snap.y-offset)+(r/2), r, r);
          dotCount++;
        }
        //  bottom left
        if ((int)random(0, 4) != 0) {
          ellipse((snap.x-offset)+(r/2), (snap.y)+(r/2), r, r);
          dotCount++;
        }
        //bottom center
        if ((int)random(0, 4) != 0) {
          ellipse((snap.x)+(r/2), (snap.y)+(r/2), r, r);
          dotCount++;
        }

      }
    }
  }
  
  println( dotCount );
  
  endRecord();
  exit();
}



