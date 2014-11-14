//public class Lake {
//  // -----------------------------------------------------------------------------
//  // Properties
//  // -----------------------------------------------------------------------------
//  PImage image;
//  PImage texture;
//  PGraphics outputImage;
//
//  int waves = 10;
//  float scale = 1.0f;
//  float speed = 1.0f;
//
//  int offset = 0;
//  int frame = 0; 
//  int max_frames = 0;
//  int frames[];
//
//  int rippleWidth, rippleHeight;
//
//
//
//  // -----------------------------------------------------------------------------
//  // Constructor
//  // -----------------------------------------------------------------------------
//  public Lake(PImage image) {
//    this.image = image;
//    this.outputImage = createGraphics(this.image.width, this.image.height, OPENGL);
//  }
//
//
//
//  // -----------------------------------------------------------------------------
//  // Methods
//  // -----------------------------------------------------------------------------
//  public void update() {
//    int dw = image.width;
//    int dh = image.height;
//    boolean end = false;
//
//    int[] id = image.pixels;
//    
//    while (!end) {
//      int[] od = image.pixels;
//      int pixel = 0;
//
//      for (int y = 0; y < dh; y++) {
//          for (int x = 0; x < dw; x++) {
////              float displacement = (scale * 10 * (Math.sin((dh/(y/waves)) + (-offset)))) | 0;
//            double displacement = (scale * 10 * Math.sin(y)) + (-offset);
//            int j = (int) (((displacement + y) * image.width + x + displacement) * 4);
//
//            // horizon flickering fix
//            if (j < 0) {
//                pixel += 4;
//                continue;
//            }
//            
//            // get color breakdowns
//            int a = (od[pixel] >> 24) & 0xFF;
//            int r = (od[pixel] >> 16) & 0xFF;
//            int g = (od[pixel] >> 8) & 0xFF;
//            int b = od[pixel] & 0xFF;
//
//            // edge wrapping fix
//            double m = j % (image.width);
//            double n = scale * 10 * (y/waves);
//            if (m < n || m > (image.width)-n) {
//                  int sign = y < image.width/2
//                    ? 1
//                    : -1;
//                    
//                    od[pixel] = od[pixel + 1 * sign];
//                    
////                  od[pixel]   = od[pixel + 4 * sign]; // r
////                  od[++pixel] = od[pixel + 4 * sign]; // g
////                  od[++pixel] = od[pixel + 4 * sign]; // b
////                  od[++pixel] = od[pixel + 4 * sign]; // a
////                  ++pixel;
//                continue;
//            }
////
//            if (id[j+3] != 0) {
////                  od[pixel]   = id[j];
////                  od[++pixel] = id[++j];
////                  od[++pixel] = id[++j];
////                  od[++pixel] = id[++j];
//                ++pixel;
//            }
//            else {
////                  od[pixel]   = od[pixel - w*4];
////                  od[++pixel] = od[pixel - w*4];
////                  od[++pixel] = od[pixel - w*4];
////                  od[++pixel] = od[pixel - w*4];
//                ++pixel;
//            }
//
//          }
//        }
//
//      }
//
////      if (offset > speed * (6/speed)) {
////          offset = 0;
////          max_frames = frame - 1;
////          // frames.pop();
////          frame = 0;
////          end = true;
////      }
////      else {
////          offset += speed;
////          frame++;
////      }
////      frames.push(odd);
//  }
//  
//
//  // -----------------------------------------------------------------------------
//  public void output(String filename) {
//    outputImage.beginDraw();
//    outputImage.image(getTexture(), 0, 0, image.width, image.height);
//    outputImage.endDraw();
//    outputImage.save(filename);    
//  }
//
//
//  // -----------------------------------------------------------------------------
//  //
//  // Gets
//  //
//  public PImage getTexture() {
//    return texture;  
//  }
//
//  
//}
