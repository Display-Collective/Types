/*
 *
 * TODO: implement callback
 *
 */

// ------------------------------------------------------------------------
// Library
// ------------------------------------------------------------------------
import java.util.concurrent.*;


public class Dot {
  public float x, y;
  public float radius;

  public Dot(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;

    ellipse(x, y, radius, radius);
  }
}


public class Halftone {
  // ------------------------------------------------------------------------
  // Properties
  // ------------------------------------------------------------------------
  public float interval = 8;
  public float degree = 45;

  PShape group;


  // ------------------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------------------
  public Halftone(int interval, float degree) {
    this.interval = interval;
    this.degree = degree;
    
    this.group = createShape(GROUP);
  }



  // ------------------------------------------------------------------------
  // Methods
  // ------------------------------------------------------------------------
  public PShape draw() {
    int w = width;
    int h = height;

    float rad = radians(degree % 90);
    float sinr = (float)Math.sin(rad), 
          cosr = (float)Math.cos(rad);
    float ow = w * cosr + h * sinr, 
          oh = h * cosr + w * sinr;

    //    var group = document.groupItems.add();
    //    group.name = "dots";

    for (int y=0; y<oh; y+=interval) {
      for (int x=0; x<ow; x+=interval) {
        float radius = setRadius(x, y, interval);

        if (radius != 0) {
//          Dot dot = new Dot(x, y, radius);
            PShape dot = createShape(
              ELLIPSE,
              x, y, 
              radius, radius
            );
            dot.setFill( color(0) );
            
            group.addChild(dot);
        }
      }
    }

    group.rotate(degree);

    println( group.width );


    //    float rad = (float)((degree % 90) * Math.PI / 180);
    //    float sinr = (float)(Math.sin(rad)),
    //          cosr = (float)(Math.cos(rad));
    //    float ow = width * cosr + height * sinr,
    //          oh = height * cosr + width * sinr;
    //
    //    pushMatrix();
    //    float offx = width * sinr * sinr,
    //          offy = -width * sinr * cosr;
    ////    translate(offx, offy);
    //    rotate(rad);
    //
    //    for (float y=0; y<oh; y+=interval) {
    //      for (float x=0; x<ow; x+=interval) {
    //        float radius = callback(offx+x, offy+y);
    //        Dot dot = new Dot(offx+x, offy+y, radius);
    //      }
    //    }
    //    popMatrix();
    
    return group;
  }

  // ------------------------------------------------------------------------
  public float setRadius(float x, float y, float interval) {
    int w = width;
    int h = height;

    float norm = map(x*y, 0, w*h, 9, 72);
    float r = map(norm, 9, 72, 1, 48);
    float angle = (float)(Math.abs((norm % 90) * Math.PI / 180));

    return (norm < 72 && (int)(Math.random()*r) == 0)
      ? (float)0
      : (float)(Math.sqrt(0.4) * interval * Math.sin(angle));
  };

  // ------------------------------------------------------------------------
  public float callback(float x, float y) {
    float angle = map(x*y, 0, width*height, radians(10), radians(90));
    //    float angle = map(y, 0, height, radians(0), radians(90));
    return (float) (Math.sqrt(2) * interval * Math.sin(angle));
  }
}

