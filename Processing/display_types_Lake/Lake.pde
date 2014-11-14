/**
 * 
 * Lake
 *
 * code inpsired taken from:
 * http://alligatr.co.uk/lake.js/
 * https://raw.githubusercontent.com/Alligator/lake.js/master/lake.js
 *
 */

public class Lake {
  // -----------------------------------------------------------------------------
  //
  // Properties
  //
  // -----------------------------------------------------------------------------
  private float speed = 1.0f;
  private float scale = 1.0f;
  private int waves = 10;
  
  private PImage src;
  private PImage dest;

  float offset = 0;
  int fr = 0;
  int max_frs = 0;
  ArrayList<int[]> frs = new ArrayList<int[]>();
//  int frs[];



  // -----------------------------------------------------------------------------
  //
  // Constructor
  //
  // -----------------------------------------------------------------------------
  public Lake(PImage src, float speed, float scale, int waves) {
    this.src   = src;
//    dest = createGraphics(this.src.width, this.src.height, OPENGL);
    dest = new PImage(this.src.width, this.src.height);
    this.speed = speed/4;
    this.scale = scale/2;
    this.waves = waves;
    
    load();
  }



  // -----------------------------------------------------------------------------
  //
  // Methods
  //
  // -----------------------------------------------------------------------------
  private void load() {
    int w = src.width;
    int h = src.height;
    int dw = w;
    int dh = h;

    
    src.loadPixels();
    int[] id = src.pixels;
    boolean end = false;

    // precalc frs
    // image displacement
    while (!end) {
      int[] odd = src.pixels;

      int pixel = 0;
      for (int y=0; y<dh; y++) {
        for (int x=0; x<dw; x++) {
//          float displacement = (scale * odd[pixel]);
          float displacement = 0.0f;
          float ywaves = (float) (y/waves);
          if (ywaves != 0) {
            displacement = (float) (scale * 10 * (Math.sin((dh/ywaves) + (-offset))));
          }
          int j = (int) ((displacement + y) * w + x + displacement);
                    
          // pixel color components
          int oa = (odd[pixel] >> 24) & 0xFF;
          int or = (odd[pixel] >> 16) & 0xFF;
          int og = (odd[pixel] >> 8) & 0xFF;
          int ob = odd[pixel] & 0xFF;          
          
          // horizon flickering fix
          if (j < 0) {
            pixel++;
            continue;
          }
          
          // edge wrapping fix
          int m = j % w;
          float n = scale * 10 * (y/waves);
          if (m < n || m > w-n) {
            int sign = (y < w)
              ? 1
              : -1;
            
            odd[pixel] = odd[pixel + 1 * sign];
            ++pixel;
            continue;
          } 
          
          if (id[(j+3) % id.length] != 0) {
            odd[pixel] = id[j % id.length];
            ++pixel;
          }
          else {
            odd[pixel] = odd[pixel - w];
            ++pixel;
          }
          
        }
      }
//      
      if (offset > speed * (6/speed)) {
        offset = 0;
        max_frs = fr - 1;
        fr = 0;
        end = true;
      }
      else {
        offset += speed;
        fr++;
      }
      frs.add( odd );
      
    } // end while


  }


  // -----------------------------------------------------------------------------
  public void update() {
//    if (!settings.image) {
//      c.putImageData(frs[fr], 0, 0);
//    }
//   else {
//      c.putImageData(frs[fr], 0, h/2);
//    }

    dest.loadPixels();
    for (int loc=0; loc <(src.width*src.height); loc++) {
      dest.pixels[loc] = frs.get(fr)[loc];
    }
    dest.updatePixels();

    if (fr < max_frs) {
      fr++;
    }
    else {
      fr = 0;
    }
    println( "fr\t" + fr );
    
  }


  // -----------------------------------------------------------------------------
  //
  // Gets
  //
  public PImage output() {
    return dest;
  }

}



//                if (offset > speed * (6/speed)) {
//                    offset = 0;
//                    max_frs = fr - 1;
//                    // frs.pop();
//                    fr = 0;
//                    end = true;
//                } else {
//                    offset += speed;
//                    fr++;
//                }
//                frs.push(odd);
//            }
//            c.restore();
//            if (!settings.image) {
//                c.height = c.height/2;
//            }
//        };
//
//
//        setInterval(function() {
//            if (img_loaded) {
//                if (!settings.image) {
//                    c.putImageData(frs[fr], 0, 0);
//                } else {
//                    c.putImageData(frs[fr], 0, h/2);
//                }
//                // c.putImageData(frs[fr], 0, h/2);
//                if (fr < max_frs) {
//                    fr++;
//                } else {
//                    fr = 0;
//                }
//            }
//        }, 33);
//        return this;
//    }
//})(jQuery);
